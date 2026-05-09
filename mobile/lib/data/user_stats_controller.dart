import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local/user_stats_store.dart';

class UserStatsController extends AsyncNotifier<UserStats> {
  @override
  Future<UserStats> build() async {
    return UserStatsStore.load();
  }

  Future<void> incrementSaved() async {
    final current = state.valueOrNull ?? await UserStatsStore.load();
    final next = current.copyWith(savedCount: current.savedCount + 1);
    state = AsyncData(next);
    await UserStatsStore.set(next);
  }

  Future<void> incrementShared() async {
    final current = state.valueOrNull ?? await UserStatsStore.load();
    final next = current.copyWith(sharedCount: current.sharedCount + 1);
    state = AsyncData(next);
    await UserStatsStore.set(next);
  }
}

final userStatsProvider = AsyncNotifierProvider<UserStatsController, UserStats>(UserStatsController.new);

