import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_config.dart';
import '../models/auth_api_models.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/user_display_name.dart';

/// Persists tokens and coordinates mock vs live API.
class AuthRepository {
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
    final profileRaw = profileJson != null
        ? UserProfile.fromJson(jsonDecode(profileJson) as Map<String, dynamic>)
        : UserProfile(
            id: 'local',
            phoneE164: '',
            onboardingComplete: false,
          );
    final profile = UserDisplayName.withNativeSynced(profileRaw);

    // Demo session should never be validated against the backend.
    if (access == 'mock_access' || profile.id == 'demo-user') {
      await _storage.deleteAll();
      return null;
    }

    if (!AppConfig.useMockApi) {
      try {
        final fresh = await _authService.getMeWithAccessToken(access).timeout(const Duration(seconds: 8));
        final synced = UserDisplayName.withNativeSynced(fresh);
        await _storage.write(key: _kProfile, value: jsonEncode(_profileToJson(synced)));
        return UserSession(accessToken: access, refreshToken: effectiveRefresh, profile: synced);
      } on DioException catch (e) {
        // Keep local session on transient auth/network errors — wiping here races splash navigation.
        if (e.response?.statusCode == 401) {
          return UserSession(accessToken: access, refreshToken: effectiveRefresh, profile: profile);
        }
        return UserSession(accessToken: access, refreshToken: effectiveRefresh, profile: profile);
      } on TimeoutException {
        // Backend is slow/unreachable: keep local session so the app can still boot
        // (and let the user proceed via demo/offline flows).
        return UserSession(accessToken: access, refreshToken: effectiveRefresh, profile: profile);
      }
    }

    return UserSession(accessToken: access, refreshToken: effectiveRefresh, profile: profile);
  }

  Future<UserSession> signInWithTruecaller({
    required String authorizationCode,
    required String codeVerifier,
    required String state,
  }) async {
    final result = await _authService.truecallerLogin(
      authorizationCode: authorizationCode,
      codeVerifier: codeVerifier,
      state: state,
    );
    final profile = UserProfile.fromJson(result.profile);
    final synced = await _persistTokens(
      access: result.accessToken,
      refresh: result.refreshToken,
      profile: profile,
    );
    return UserSession(
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
      profile: synced,
    );
  }

  Future<OtpSendResponse> sendOtp(String phoneDigits) async {
    final d = _digitsOnly(phoneDigits);
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
      final synced = await _persistTokens(access: access, refresh: refresh, profile: profile);
      return UserSession(accessToken: access, refreshToken: refresh, profile: synced);
    } on DioException catch (e) {
      throw Exception(_dioMessage(e));
    }
  }

  Future<UserProfile> refreshProfileFromServer() async {
    final existing = await restoreSession();
    if (existing?.accessToken == 'mock_access' || AppConfig.useMockApi) {
      return existing?.profile ?? const UserProfile(id: 'demo', phoneE164: '', onboardingComplete: true);
    }
    final profile = await _authService.getMe();
    final synced = UserDisplayName.withNativeSynced(profile);
    await _storage.write(key: _kProfile, value: jsonEncode(_profileToJson(synced)));
    return synced;
  }

  Future<UserSession> applyProfile(UserProfile profile) async {
    final existing = await restoreSession();
    if (existing?.accessToken == 'mock_access' || AppConfig.useMockApi) {
      final access = existing?.accessToken ?? 'mock_access';
      final refresh = existing?.refreshToken ?? access;
      final synced = await _persistTokens(access: access, refresh: refresh, profile: profile);
      return UserSession(accessToken: access, refreshToken: refresh, profile: synced);
    }

    if (existing == null) {
      throw StateError('No session');
    }
    final access = existing.accessToken;
    final refresh = existing.refreshToken.isEmpty ? access : existing.refreshToken;
    final server = await _authService.updateMe(profile);
    final synced = await _persistTokens(access: access, refresh: refresh, profile: server);
    return UserSession(accessToken: access, refreshToken: refresh, profile: synced);
  }

  Future<UserSession> completeOnboardingOnServer({
    required String contentLanguage,
    String? religionId,
    List<String> interestIds = const [],
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
      final synced = await _persistTokens(
        access: existing.accessToken,
        refresh: existing.refreshToken,
        profile: updated,
      );
      return UserSession(
        accessToken: existing.accessToken,
        refreshToken: existing.refreshToken,
        profile: synced,
      );
    }

    final partial = existing.profile.copyWith(
      contentLanguage: contentLanguage,
      religionId: religionId,
      onboardingComplete: true,
    );
    await _authService.updateMe(partial);
    if (interestIds.isNotEmpty) {
      await _authService.updateInterests(interestIds);
    }
    final fresh = await _authService.getMe();
    final completed = fresh.copyWith(
      onboardingComplete: true,
      interestIds: fresh.interestIds.isNotEmpty ? fresh.interestIds : interestIds,
    );
    final synced = await _persistTokens(
      access: existing.accessToken,
      refresh: existing.refreshToken,
      profile: completed,
    );
    return UserSession(
      accessToken: existing.accessToken,
      refreshToken: existing.refreshToken,
      profile: synced,
    );
  }

  Future<void> signOut() async {
    await _storage.deleteAll();
  }

  Future<void> deleteAccount() async {
    final existing = await restoreSession();
    if (existing != null &&
        existing.accessToken != 'mock_access' &&
        existing.profile.id != 'demo-user' &&
        !AppConfig.useMockApi) {
      await _authService.deleteMe();
    }
    await _clearLocalAppData();
  }

  /// Alias for sign-out flows (e.g. global 401 handler).
  Future<void> logout() => signOut();

  Future<void> _clearLocalAppData() async {
    await _storage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<UserProfile> _persistTokens({
    required String access,
    required String refresh,
    required UserProfile profile,
  }) async {
    final stored = UserDisplayName.withNativeSynced(profile);
    try {
      await Future<void>(() async {
        await _storage.write(key: _kAccess, value: access);
        await _storage.write(key: _kRefresh, value: refresh.isEmpty ? access : refresh);
        await _storage.write(key: _kProfile, value: jsonEncode(_profileToJson(stored)));
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
    return stored;
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
}
