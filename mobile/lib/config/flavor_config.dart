enum AppFlavor { development, staging, production }

/// Default Render API (includes `/v1`). Single source of truth — also referenced from scripts/docs.
const String kDailyKathaProductionApiBase = 'https://dailykatha-backend.onrender.com/v1';

/// Build-time flavor (`--dart-define=FLAVOR=staging`).
abstract final class FlavorConfig {
  static const String _raw = String.fromEnvironment('FLAVOR', defaultValue: 'production');

  static AppFlavor get flavor => switch (_raw) {
        'development' || 'dev' => AppFlavor.development,
        'staging' => AppFlavor.staging,
        _ => AppFlavor.production,
      };

  static String get appLabel => switch (flavor) {
        AppFlavor.development => 'Daily Katha (Dev)',
        AppFlavor.staging => 'Daily Katha (Staging)',
        AppFlavor.production => 'Daily Katha',
      };

  /// API root including `/v1` when `API_BASE` is not set via dart-define.
  ///
  /// Override with `--dart-define=API_BASE=https://YOUR-SERVICE.onrender.com/v1` if the host changes.
  static String get apiBase => switch (flavor) {
        AppFlavor.development => 'http://localhost:3000/v1',
        AppFlavor.staging => kDailyKathaProductionApiBase,
        AppFlavor.production => kDailyKathaProductionApiBase,
      };

  static bool get isProduction => flavor == AppFlavor.production;
}
