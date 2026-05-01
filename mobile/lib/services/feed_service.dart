import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/katha_card.dart';

@immutable
class FeedService {
  const FeedService(this._dio);

  final Dio _dio;

  Future<List<KathaCard>> fetchFeed({
    int page = 1,
    int limit = 24,
    String? section,
    String lang = 'en',
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/feed',
      queryParameters: {
        'page': page,
        'limit': limit,
        'lang': lang,
        ...?section != null ? {'section': section} : null,
      },
    );
    final data = response.data ?? const {};
    final raw = data['cards'] as List<dynamic>? ?? const [];
    return raw.map((e) => KathaCard.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<List<KathaCard>> fetchMorningFeed({String lang = 'en'}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/feed/morning',
      queryParameters: {'lang': lang},
    );
    final data = response.data ?? const {};
    final raw = data['cards'] as List<dynamic>? ?? const [];
    return raw.map((e) => KathaCard.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<List<KathaCard>> fetchExploreFeed({String? category, String lang = 'en'}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/feed/explore',
      queryParameters: {
        'lang': lang,
        ...?category != null ? {'category': category} : null,
      },
    );
    final data = response.data ?? const {};
    final raw = data['cards'] as List<dynamic>? ?? const [];
    return raw.map((e) => KathaCard.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<List<KathaCard>> fetchFestivalFeed({String lang = 'en'}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/feed/festival',
      queryParameters: {'lang': lang},
    );
    final data = response.data ?? const {};
    final raw = data['cards'] as List<dynamic>? ?? const [];
    return raw.map((e) => KathaCard.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<List<KathaCard>> searchCards({
    required String query,
    int page = 1,
    String? category,
    String lang = 'en',
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/cards/search',
      queryParameters: {
        'q': query,
        'page': page,
        'lang': lang,
        ...?category != null ? {'category': category} : null,
      },
    );
    final data = response.data ?? const {};
    final raw = data['cards'] as List<dynamic>? ?? const [];
    return raw.map((e) => KathaCard.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<Map<String, dynamic>> getTodaysPicks() async {
    final response = await _dio.get<Map<String, dynamic>>('/feed/today-picks');
    return response.data ?? <String, dynamic>{};
  }
}
