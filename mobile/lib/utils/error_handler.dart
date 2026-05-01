import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

@immutable
class AppError {
  const AppError({
    required this.code,
    required this.userMessage,
    this.isRetryable = false,
  });

  final String code;
  final String userMessage;
  final bool isRetryable;
}

/// Maps [DioException] and generic errors to user-facing copy.
abstract final class ErrorHandler {
  static AppError fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const AppError(
          code: 'TIMEOUT',
          userMessage: 'Connection timed out. Please try again.',
          isRetryable: true,
        );
      case DioExceptionType.connectionError:
        return const AppError(
          code: 'NO_INTERNET',
          userMessage: 'No internet connection. Please check your network.',
          isRetryable: true,
        );
      default:
        break;
    }

    final status = e.response?.statusCode;
    final body = e.response?.data;
    String? backendCode;
    if (body is Map) {
      final err = body['error'];
      if (err is Map) backendCode = err['code']?.toString();
    }

    return switch (status) {
      400 => AppError(
          code: backendCode ?? 'BAD_REQUEST',
          userMessage: _codeMessage(backendCode) ?? 'Invalid request.',
        ),
      401 => const AppError(code: 'UNAUTHORIZED', userMessage: 'Session expired. Please sign in again.'),
      403 => const AppError(code: 'FORBIDDEN', userMessage: 'You do not have access to this.'),
      404 => const AppError(code: 'NOT_FOUND', userMessage: 'Not found.'),
      429 => const AppError(
          code: 'RATE_LIMITED',
          userMessage: 'Too many requests. Please wait a moment.',
          isRetryable: true,
        ),
      503 => const AppError(
          code: 'SERVICE_DOWN',
          userMessage: 'Service temporarily unavailable. Please try later.',
          isRetryable: true,
        ),
      _ => const AppError(code: 'UNKNOWN', userMessage: 'Something went wrong. Please try again.', isRetryable: true),
    };
  }

  static String? _codeMessage(String? code) {
    return switch (code) {
      'INVALID_OTP' => 'Incorrect OTP. Please try again.',
      'INVALID_PHONE' => 'Please enter a valid phone number.',
      'RATE_LIMITED' || 'AUTH_RATE_LIMITED' => 'Too many attempts. Wait a minute.',
      'DAILY_LIMIT_REACHED' => 'Daily limit reached. Try again tomorrow.',
      _ => null,
    };
  }

  static String userMessage(BuildContext context, Object error) {
    final l10n = AppLocalizations.of(context);
    if (error is DioException) {
      return fromDioException(error).userMessage;
    }
    return l10n.errorGeneric;
  }
}
