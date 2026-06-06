import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';

import '../config/flavor_config.dart';
import '../core/app_config.dart';

typedef TokenResolver = String? Function();
typedef LangResolver = String? Function();
typedef UnauthorizedHandler = Future<void> Function(String path);

/// HTTP client for Daily Katha REST API. [baseUri] must include `/v1` when using production backend.
@immutable
class ApiClient {
  ApiClient({
    required Uri? baseUri,
    required TokenResolver tokenResolver,
    LangResolver? langResolver,
    UnauthorizedHandler? onUnauthorized,
  })  : _tokenResolver = tokenResolver,
        _langResolver = langResolver,
        _onUnauthorized = onUnauthorized,
        _dio = Dio(
          BaseOptions(
            // Never default to localhost — prod/staging builds must hit Render if Uri wiring slips.
            baseUrl: baseUri?.toString() ?? FlavorConfig.apiBase,
            connectTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _tokenResolver();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          final lang = _langResolver?.call();
          if (lang != null && lang.isNotEmpty) {
            options.headers['Accept-Language'] = lang;
          }
          handler.next(options);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            final path = e.requestOptions.path;
            if (!path.startsWith('/auth/') && _onUnauthorized != null) {
              try {
                await _onUnauthorized(path);
              } catch (err, st) {
                debugPrint('onUnauthorized failed: $err\n$st');
              }
            }
          }
          handler.next(e);
        },
      ),
    );

    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: debugPrint,
        retries: 2,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
        ],
        retryEvaluator: (err, attempt) {
          if (err.requestOptions.method != 'GET') return false;
          final t = err.type;
          if (t == DioExceptionType.connectionTimeout ||
              t == DioExceptionType.receiveTimeout ||
              t == DioExceptionType.connectionError) {
            return true;
          }
          final code = err.response?.statusCode;
          return code == 503;
        },
      ),
    );
  }

  final Dio _dio;
  final TokenResolver _tokenResolver;
  final LangResolver? _langResolver;
  final UnauthorizedHandler? _onUnauthorized;

  Dio get dio => _dio;

  static ApiClient stub({
    required TokenResolver tokenResolver,
    LangResolver? langResolver,
    UnauthorizedHandler? onUnauthorized,
  }) {
    return ApiClient(
      baseUri: AppConfig.apiBaseUri,
      tokenResolver: tokenResolver,
      langResolver: langResolver,
      onUnauthorized: onUnauthorized,
    );
  }
}
