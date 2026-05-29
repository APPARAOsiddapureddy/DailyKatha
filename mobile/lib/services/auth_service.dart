import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/auth_api_models.dart';
import '../models/user_profile.dart';

/// Backend `/v1/auth/*` and `/v1/users/*` (Dio `baseUrl` already includes `/v1`).
@immutable
class AuthService {
  const AuthService(this._dio);

  final Dio _dio;

  Future<OtpSendResponse> sendOtp({required String phoneE164}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/send-otp',
      data: {'phone': phoneE164},
    );
    return OtpSendResponse.fromJson(response.data ?? const {});
  }

  Future<AuthTokensResponse> verifyOtp({
    required String phoneDigits,
    required String requestId,
    required String code,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/verify-otp',
      data: {
        'phone': '+91$phoneDigits',
        'requestId': requestId,
        'code': code,
      },
    );
    return AuthTokensResponse.fromJson(response.data ?? const {});
  }

  Future<UserProfile> getMe() async {
    final response = await _dio.get<Map<String, dynamic>>('/users/me');
    return UserProfile.fromJson(response.data ?? const {});
  }

  Future<UserProfile> getMeWithAccessToken(String accessToken) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/users/me',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return UserProfile.fromJson(response.data ?? const {});
  }

  Future<UserProfile> updateMe(UserProfile profile) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/users/me',
      data: profile.toBackendUpdateBody(),
    );
    return UserProfile.fromJson(response.data ?? const {});
  }

  Future<void> updateInterests(List<String> interestIds) async {
    await _dio.put<void>(
      '/users/me/interests',
      data: {'interests': interestIds},
    );
  }

  Future<void> deleteMe() async {
    await _dio.delete<void>('/users/me');
  }

  Future<AuthTokensResponse> truecallerLogin({
    required String authorizationCode,
    required String codeVerifier,
    required String state,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/truecaller',
      data: {
        'authorizationCode': authorizationCode,
        'codeVerifier': codeVerifier,
        'state': state,
      },
    );
    return AuthTokensResponse.fromJson(response.data ?? const {});
  }
}
