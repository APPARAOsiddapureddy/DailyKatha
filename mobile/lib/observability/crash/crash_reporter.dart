import 'package:flutter/foundation.dart';

/// Minimal crash reporting contract. Plug in Crashlytics/Sentry later.
abstract class CrashReporter {
  Future<void> recordError(
    Object error,
    StackTrace stack, {
    String? reason,
    bool fatal = false,
    Map<String, Object?> context = const {},
  });
}

class NoopCrashReporter implements CrashReporter {
  const NoopCrashReporter();

  @override
  Future<void> recordError(
    Object error,
    StackTrace stack, {
    String? reason,
    bool fatal = false,
    Map<String, Object?> context = const {},
  }) async {
    // Keep console logs in debug so dev builds still show something.
    if (kDebugMode) {
      // ignore: avoid_print
      print('CrashReporter(noop): $reason $error\n$stack');
    }
  }
}

