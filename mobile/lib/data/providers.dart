import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/app_config.dart';
import '../core/content_language.dart';
import '../models/katha_card.dart';
import '../models/user_profile.dart';
import '../services/admin_service.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/feed_service.dart';
import '../services/notification_service.dart';
import '../services/share_service.dart';
import '../services/user_actions_service.dart';
import 'auth_repository.dart';
import 'feed_repository.dart';
import 'local/bundled_catalog_loader.dart';
import 'local/mock_catalog.dart';
import 'local/user_created_cards_store.dart';
import 'session_holder.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final sessionHolderProvider = NotifierProvider<SessionHolder, UserSession?>(SessionHolder.new);

/// Restores persisted session once per app start.
final bootstrapProvider = FutureProvider<UserSession?>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  final session = await repo.restoreSession();
  if (session != null) {
    ref.read(sessionHolderProvider.notifier).setSession(session);
  } else {
    ref.read(sessionHolderProvider.notifier).clear();
  }
  return session;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUri: AppConfig.apiBaseUri,
    tokenResolver: () => ref.read(sessionHolderProvider)?.accessToken,
    langResolver: () => effectiveContentLanguage(ref.watch(sessionHolderProvider)),
    onUnauthorized: () async {
      await ref.read(secureStorageProvider).deleteAll();
      ref.read(sessionHolderProvider.notifier).clear();
    },
  );
});

final dioProvider = Provider<Dio>((ref) => ref.watch(apiClientProvider).dio);

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(dioProvider));
});

final feedServiceProvider = Provider<FeedService>((ref) {
  return FeedService(ref.watch(dioProvider));
});

final adminServiceProvider = Provider<AdminService>((ref) {
  return AdminService(ref.watch(dioProvider));
});

final userActionsServiceProvider = Provider<UserActionsService>((ref) {
  return UserActionsService(ref.watch(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    storage: ref.watch(secureStorageProvider),
    authService: ref.watch(authServiceProvider),
  );
});

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepository(ref.watch(feedServiceProvider));
});

final userCreatedCardsProvider = FutureProvider<List<KathaCard>>((ref) async {
  return UserCreatedCardsStore.load();
});

final shareServiceProvider = Provider<ShareService>((ref) => const ShareService());

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return const NotificationService();
});

final catalogProvider = FutureProvider<List<KathaCard>>((ref) async {
  final session = ref.watch(sessionHolderProvider);
  final lang = effectiveContentLanguage(session);
  final created = await ref.watch(userCreatedCardsProvider.future);
  // Demo/testing session should not call backend.
  if (session?.accessToken == 'mock_access') {
    final bundled = await BundledCatalogLoader.loadForContentLanguage(lang);
    final base = bundled.isNotEmpty ? bundled : MockCatalog.cards;
    return [...created, ...base];
  }
  final remote = await ref.watch(feedRepositoryProvider).loadCards(contentLanguage: lang);
  return [...created, ...remote];
});

/// Local optimistic likes for mock mode / offline parity.
class LikedIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  void toggle(String id) {
    final next = Set<String>.from(state);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    state = next;
  }

  bool contains(String id) => state.contains(id);
}

final likedIdsProvider = NotifierProvider<LikedIdsNotifier, Set<String>>(LikedIdsNotifier.new);
