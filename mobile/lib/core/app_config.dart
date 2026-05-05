import '../config/flavor_config.dart';

/// [API_BASE] dart-define: production URL including `/v1`, or `mock` / `offline` for bundled catalog only.
///
/// OTP / auth — `/v1/auth/send-otp` and `/verify-otp` on the deployed API (SMS via Twilio or MSG91 on the server).
/// Dev flavor (`FLAVOR=development`): unless you override dart-defines, OTP stays **local** (no HTTP).
///
/// [TESTING_SKIP_TO_HOME_AFTER_LOCAL_OTP] — default `false`: after local OTP, go **Language → … → Home**;
/// set `true` to open **Home** directly.
abstract final class AppConfig {
  static const String _envApi = String.fromEnvironment('API_BASE');

  /// With [requireBackendOtp], enables HTTP OTP on **production / staging** flavors (non-mock API).
  static const bool allowLiveBackendOtp = bool.fromEnvironment(
    'ALLOW_LIVE_BACKEND_OTP',
    defaultValue: true,
  );

  static const bool requireBackendOtp = bool.fromEnvironment(
    'REQUIRE_BACKEND_OTP',
    defaultValue: true,
  );

  /// After **local** (non-SMS) OTP success: if `true`, skip onboarding → Home; if `false` (default), Language → … → Home.
  static const bool testingSkipToHomeAfterLocalOtp = bool.fromEnvironment(
    'TESTING_SKIP_TO_HOME_AFTER_LOCAL_OTP',
    defaultValue: false,
  );

  static bool get _liveOtpFlavor =>
      FlavorConfig.flavor == AppFlavor.production || FlavorConfig.flavor == AppFlavor.staging;

  /// Real HTTP OTP when **both** flags are true + production/staging flavor + non-mock API.
  static bool get useLiveOtp =>
      allowLiveBackendOtp && requireBackendOtp && _liveOtpFlavor && !useMockApi;

  static bool get useMockApi {
    final v = _envApi.trim().toLowerCase();
    return v == 'mock' || v == 'offline';
  }

  static String get apiRoot {
    if (useMockApi) return '';
    final t = _envApi.trim();
    if (t.isNotEmpty) return t.endsWith('/v1') || t.contains('/v1/') ? t : '${t.endsWith('/') ? t.substring(0, t.length - 1) : t}/v1';
    return FlavorConfig.apiBase;
  }

  static Uri? get apiBaseUri {
    if (useMockApi) return null;
    final s = apiRoot.endsWith('/') ? apiRoot.substring(0, apiRoot.length - 1) : apiRoot;
    return Uri.parse(s);
  }
}
