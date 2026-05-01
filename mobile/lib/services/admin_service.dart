import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

@immutable
class AdminService {
  const AdminService(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _dio.get<Map<String, dynamic>>('/admin/dashboard');
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> generateCards({
    required List<String> interestIds,
    int cardsRequested = 20,
    String contentLanguage = 'te',
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/admin/generate',
      data: {
        'interestIds': interestIds,
        'cardsRequested': cardsRequested,
        'contentLanguage': contentLanguage,
      },
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> generateTodaysPicks() async {
    final response = await _dio.post<Map<String, dynamic>>('/admin/today-picks/generate');
    return response.data ?? <String, dynamic>{};
  }
}

