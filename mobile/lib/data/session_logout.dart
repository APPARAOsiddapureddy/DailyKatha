import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Paths where a 401 should not force a global logout (handled locally / fallback).
bool isRecoverableUnauthorizedPath(String path) {
  return path.startsWith('/feed') ||
      path.startsWith('/cards') ||
      path.startsWith('/admin');
}

/// Debounced global logout so a burst of 401s (IndexedStack tabs) cannot clear
/// session and trigger GoRouter redirects mid-frame.
class SessionLogoutCoordinator {
  Timer? _timer;
  bool _running = false;

  void scheduleLogout(
    Future<void> Function() performLogout, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    _timer?.cancel();
    _timer = Timer(delay, () => _run(performLogout));
  }

  Future<void> _run(Future<void> Function() performLogout) async {
    if (_running) return;
    _running = true;
    try {
      final completer = Completer<void>();
      SchedulerBinding.instance.addPostFrameCallback((_) => completer.complete());
      await completer.future;
      await performLogout();
    } catch (e, st) {
      debugPrint('SessionLogoutCoordinator: $e\n$st');
    } finally {
      _running = false;
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}

final sessionLogoutCoordinatorProvider = Provider<SessionLogoutCoordinator>((ref) {
  final coordinator = SessionLogoutCoordinator();
  ref.onDispose(coordinator.dispose);
  return coordinator;
});
