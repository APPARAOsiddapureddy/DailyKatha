import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'crash_reporter.dart';

final crashReporterProvider = Provider<CrashReporter>((ref) {
  // Default to no-op until Crashlytics/Sentry credentials are added.
  return const NoopCrashReporter();
});

