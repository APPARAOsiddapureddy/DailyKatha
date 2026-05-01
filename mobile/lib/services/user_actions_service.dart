import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/katha_card.dart';

@immutable
class UserActionsService {
  const UserActionsService(this._dio);

  final Dio _dio;

  Future<void> like(String cardId) async {
    await _dio.post<void>('/cards/$cardId/interact', data: {'action': 'liked'});
  }

  /// Backend has no unlike; record a neutral view so the client can move on.
  Future<void> unlike(String cardId) async {
    await _dio.post<void>('/cards/$cardId/interact', data: {'action': 'viewed'});
  }

  Future<void> save(String cardId) async {
    await _dio.post<void>('/cards/$cardId/interact', data: {'action': 'saved'});
  }

  Future<void> unsave(String cardId) async {
    await _dio.post<void>('/cards/$cardId/interact', data: {'action': 'viewed'});
  }

  Future<void> share({required String cardId, required String channel}) async {
    await _dio.post<void>('/cards/$cardId/interact', data: {'action': 'shared'});
  }

  Future<void> view(String cardId) async {
    await _dio.post<void>('/cards/$cardId/interact', data: {'action': 'viewed'});
  }

  Future<void> skip(String cardId) async {
    await _dio.post<void>('/cards/$cardId/interact', data: {'action': 'skipped'});
  }

  Future<List<KathaCard>> fetchLikedCards({int page = 1, int limit = 20}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/users/me/liked',
      queryParameters: {'page': page, 'limit': limit},
    );
    final raw = (response.data?['cards'] as List<dynamic>?) ?? const [];
    return raw.map((e) => KathaCard.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<List<KathaCard>> fetchSavedCards({int page = 1, int limit = 20}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/users/me/saved',
      queryParameters: {'page': page, 'limit': limit},
    );
    final raw = (response.data?['cards'] as List<dynamic>?) ?? const [];
    return raw.map((e) => KathaCard.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }
}
