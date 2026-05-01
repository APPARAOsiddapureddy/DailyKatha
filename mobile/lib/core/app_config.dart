import '../config/flavor_config.dart';

/// [API_BASE] dart-define: production URL including `/v1`, or `mock` / `offline` for bundled catalog only.
abstract final class AppConfig {
  static const String _envApi = String.fromEnvironment('API_BASE');

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
