import 'package:flutter/foundation.dart';

@immutable
class OtpSendResponse {
  const OtpSendResponse({
    required this.requestId,
    this.message,
    this.channel,
    this.success,
    this.referenceId,
    this.expiresIn,
  });

  final String requestId;
  /// Server copy: e.g. "Test number — use OTP 560102" or "OTP sent by SMS to …".
  final String? message;
  final String? channel;
  final bool? success;
  final String? referenceId;
  final int? expiresIn;

  factory OtpSendResponse.fromJson(Map<String, dynamic> json) {
    return OtpSendResponse(
      requestId: json['requestId']?.toString() ?? json['request_id']?.toString() ?? 'default',
      message: json['message']?.toString(),
      channel: json['channel']?.toString(),
      success: json['success'] == true || json['ok'] == true,
      referenceId: json['reference_id']?.toString(),
      expiresIn: int.tryParse(json['expires_in']?.toString() ?? ''),
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
