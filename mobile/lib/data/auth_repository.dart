import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/app_config.dart';
import '../models/auth_api_models.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';

/// Persists tokens and coordinates mock vs live API.
class AuthRepository {
  /// Same rule as backend [otp.js]: 10-digit numbers starting with this prefix use fixed OTP 560102.
  static const String _qaPhonePrefix = '123456';
  static const String _qaFixedOtp = '560102';

  static bool _isQaTestLine(String digits10) =>
      digits10.length == 10 && digits10.startsWith(_qaPhonePrefix);

  static String _digitsOnly(String raw) => raw.replaceAll(RegExp(r'\D'), '');

  AuthRepository({
    required FlutterSecureStorage storage,
    required AuthService authService,
  })  : _storage = storage,
        _authService = authService;

  static const _kAccess = 'dk_access_token';
  static const _kRefresh = 'dk_refresh_token';
  static const _kProfile = 'dk_profile_json';

  final FlutterSecureStorage _storage;
  final AuthService _authService;

  Future<UserSession?> restoreSession() async {
    final access = await _storage.read(key: _kAccess);
    if (access == null || access.isEmpty) return null;
    final refresh = await _storage.read(key: _kRefresh);
    final effectiveRefresh = (refresh == null || refresh.isEmpty) ? access : refresh;
    final profileJson = await _storage.read(key: _kProfile);
    final profile = profileJson != null
        ? UserProfile.fromJson(jsonDecode(profileJson) as Map<String, dynamic>)
        : UserProfile(
            id: 'local',
            phoneE164: '',
            onboardingComplete: false,
          );

    // Demo session should never be validated against the backend.
    if (access == 'mock_access' || profile.id == 'demo-user') {
      return UserSession(accessToken: access, refreshToken: effectiveRefresh, profile: profile);
    }

    if (!AppConfig.useMockApi) {
      try {
        final fresh = await _authService.getMeWithAccessToken(access).timeout(const Duration(seconds: 8));
        await _storage.write(key: _kProfile, value: jsonEncode(_profileToJson(fresh)));
        return UserSession(accessToken: access, refreshToken: effectiveRefresh, profile: fresh);
      } on DioException {
        await _storage.deleteAll();
        return null;
      } on TimeoutException {
        // Backend is slow/unreachable: keep local session so the app can still boot
        // (and let the user proceed via demo/offline flows).
        return UserSession(accessToken: access, refreshToken: effectiveRefresh, profile: profile);
      }
    }

    return UserSession(accessToken: access, refreshToken: effectiveRefresh, profile: profile);
  }

  Future<OtpSendResponse> sendOtp(String phoneDigits) async {
    final d = _digitsOnly(phoneDigits);
    // Internal testing or non-live-OTP builds should not hit send-OTP on the backend.
    if (!AppConfig.useLiveOtp) {
      return OtpSendResponse(requestId: d);
    }
    return _authService
        .sendOtp(phoneE164: '+91$d')
        .timeout(
          const Duration(seconds: 25),
          onTimeout: () => throw TimeoutException(
            'Could not reach the server to send OTP. Check internet and try again.',
          ),
        );
  }

  Future<UserSession> verifyOtp({
    required String phoneDigits,
    required String requestId,
    required String code,
  }) async {
    final normalizedPhone = _digitsOnly(phoneDigits);
    final normalizedCode = _digitsOnly(code);
    if (normalizedCode.length != 6) {
      throw ArgumentError('OTP must be 6 digits');
    }

    // QA numbers: complete immediately — avoids hung HTTP (cold Render, DNS) and Android Keystore
    // deadlocks in FlutterSecureStorage that leave the UI stuck on "Verifying…".
    if (_isQaTestLine(normalizedPhone) && normalizedCode == _qaFixedOtp) {
      return _createDemoSession(
        phoneDigits: normalizedPhone,
        onboardingComplete: AppConfig.testingSkipToHomeAfterLocalOtp,
      );
    }

    // Testing / internal APK: bypass server verify unless [AppConfig.useLiveOtp].
    if (!AppConfig.useLiveOtp) {
      return _createDemoSession(
        phoneDigits: normalizedPhone,
        onboardingComplete: AppConfig.testingSkipToHomeAfterLocalOtp,
      );
    }

    try {
      final result = await _authService
          .verifyOtp(
            phoneDigits: normalizedPhone,
            requestId: _digitsOnly(requestId),
            code: normalizedCode,
          )
          .timeout(
            const Duration(seconds: 25),
            onTimeout: () => throw TimeoutException(
              'Verification timed out. Check internet or try again.',
            ),
          );

      final access = result.accessToken;
      final refresh = result.refreshToken;
      if (access.isEmpty) {
        throw StateError('Server returned no token');
      }
      final profile = UserProfile.fromJson(result.profile);
      await _persistTokens(access: access, refresh: refresh, profile: profile);
      return UserSession(accessToken: access, refreshToken: refresh, profile: profile);
    } on DioException catch (e) {
      final msg = _dioMessage(e);
      throw Exception(msg);
    }
  }

  String _dioMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['error'] is Map) {
      final m = (data['error'] as Map)['message']?.toString();
      if (m != null && m.isNotEmpty) return m;
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Check internet and try again.';
      case DioExceptionType.connectionError:
        return 'No connection. Check internet or try again later.';
      default:
        return e.message ?? 'Verification failed';
    }
  }

  Future<UserSession> createDemoSessionForTesting({required String phoneDigits}) async {
    return _createDemoSession(
      phoneDigits: phoneDigits,
      onboardingComplete: AppConfig.testingSkipToHomeAfterLocalOtp,
    );
  }

  Future<UserSession> _createDemoSession({
    required String phoneDigits,
    bool onboardingComplete = false,
  }) async {
    final d = _digitsOnly(phoneDigits);
    final profile = UserProfile(
      id: 'demo-user',
      phoneE164: '+91$d',
      displayName: 'Demo User',
      displayNameNative: null,
      contentLanguage: 'te',
      isAdmin: d == '6301567773',
      onboardingComplete: onboardingComplete,
      joinedAt: DateTime.now(),
    );
    const access = 'mock_access';
    await _persistTokens(access: access, refresh: access, profile: profile);
    return UserSession(
      accessToken: access,
      refreshToken: access,
      profile: profile,
    );
  }

  Future<UserProfile> refreshProfileFromServer() async {
    final existing = await restoreSession();
    if (existing?.accessToken == 'mock_access' || AppConfig.useMockApi) {
      return existing?.profile ?? const UserProfile(id: 'demo', phoneE164: '', onboardingComplete: true);
    }
    final profile = await _authService.getMe();
    await _storage.write(key: _kProfile, value: jsonEncode(_profileToJson(profile)));
    return profile;
  }

  Future<UserSession> applyProfile(UserProfile profile) async {
    final existing = await restoreSession();
    if (existing?.accessToken == 'mock_access' || AppConfig.useMockApi) {
      final access = existing?.accessToken ?? 'mock_access';
      final refresh = existing?.refreshToken ?? access;
      await _persistTokens(access: access, refresh: refresh, profile: profile);
      return UserSession(accessToken: access, refreshToken: refresh, profile: profile);
    }

    if (existing == null) {
      throw StateError('No session');
    }
    final access = existing.accessToken;
    final refresh = existing.refreshToken.isEmpty ? access : existing.refreshToken;
    final server = await _authService.updateMe(profile);
    await _persistTokens(access: access, refresh: refresh, profile: server);
    return UserSession(accessToken: access, refreshToken: refresh, profile: server);
  }

  Future<UserSession> completeOnboardingOnServer({
    required String contentLanguage,
    String? religionId,
    required List<String> interestIds,
  }) async {
    final existing = await restoreSession();
    if (existing == null) {
      throw StateError('No session');
    }

    // TESTING / demo session: do not call backend. Persist locally and continue.
    if (existing.accessToken == 'mock_access' || AppConfig.useMockApi) {
      final updated = existing.profile.copyWith(
        contentLanguage: contentLanguage,
        religionId: religionId,
        interestIds: interestIds,
        onboardingComplete: true,
      );
      await _persistTokens(
        access: existing.accessToken,
        refresh: existing.refreshToken,
        profile: updated,
      );
      return UserSession(
        accessToken: existing.accessToken,
        refreshToken: existing.refreshToken,
        profile: updated,
      );
    }

    final partial = existing.profile.copyWith(
      contentLanguage: contentLanguage,
      religionId: religionId,
      onboardingComplete: true,
    );
    await _authService.updateMe(partial);
    await _authService.updateInterests(interestIds);
    final fresh = await _authService.getMe();
    await _persistTokens(
      access: existing.accessToken,
      refresh: existing.refreshToken,
      profile: fresh,
    );
    return UserSession(
      accessToken: existing.accessToken,
      refreshToken: existing.refreshToken,
      profile: fresh,
    );
  }

  Future<void> signOut() async {
    await _storage.deleteAll();
  }

  /// Alias for sign-out flows (e.g. global 401 handler).
  Future<void> logout() => signOut();

  Future<void> _persistTokens({
    required String access,
    required String refresh,
    required UserProfile profile,
  }) async {
    try {
      await Future<void>(() async {
        await _storage.write(key: _kAccess, value: access);
        await _storage.write(key: _kRefresh, value: refresh.isEmpty ? access : refresh);
        await _storage.write(key: _kProfile, value: jsonEncode(_profileToJson(profile)));
      }).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Secure storage timed out'),
      );
    } on TimeoutException catch (e, st) {
      debugPrint('AuthRepository: secure storage timed out (session works until app restart): $e');
      debugPrint('$st');
    } catch (e, st) {
      // Release devices sometimes throw from Keystore / EncryptedSharedPreferences; still allow in-memory session.
      debugPrint('AuthRepository: secure storage write failed (session works until app restart): $e');
      debugPrint('$st');
    }
  }

  Map<String, dynamic> _profileToJson(UserProfile p) => {
        'id': p.id,
        'phone': p.phoneE164,
        'displayName': p.displayName,
        'displayNameNative': p.displayNameNative,
        'contentLanguage': p.contentLanguage,
        'religionId': p.religionId,
        'interestIds': p.interestIds,
        'onboardingComplete': p.onboardingComplete,
      };
}
