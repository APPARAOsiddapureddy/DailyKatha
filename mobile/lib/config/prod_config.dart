/// Production constants — keep aligned with [FlavorConfig] / `--dart-define`.
library;

/// API root including `/v1` when not overriding `API_BASE` via dart-define.
const String kProdApiBaseUrl = 'https://dailykatha-backend.onrender.com/v1';

const String kProdEnvironmentName = 'production';

/// Production Play/App Store builds should keep QA autofill/server shortcuts off unless you intend staging behavior.
const bool kProdEnableQaShortcuts = bool.fromEnvironment(
  'ENABLE_QA_SHORTCUTS',
  defaultValue: false,
);
