import 'package:flutter/foundation.dart';

@immutable
class OtpSendResponse {
  const OtpSendResponse({required this.requestId});

  final String requestId;

  factory OtpSendResponse.fromJson(Map<String, dynamic> json) {
    return OtpSendResponse(
      requestId: json['requestId']?.toString() ?? json['request_id']?.toString() ?? 'default',
    );
  }
}

@immutable
class AuthTokensResponse {
  const AuthTokensResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.profile,
  });

  final String accessToken;
  final String refreshToken;
  final Map<String, dynamic> profile;

  factory AuthTokensResponse.fromJson(Map<String, dynamic> json) {
    final token =
        json['token']?.toString() ?? json['accessToken']?.toString() ?? json['access_token']?.toString() ?? '';
    final data = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
    final user = (data['user'] as Map<String, dynamic>?) ?? (json['user'] as Map<String, dynamic>?) ?? const {};
    return AuthTokensResponse(
      accessToken: token,
      refreshToken: token,
      profile: user,
    );
  }
}
