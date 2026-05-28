import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

@immutable
class TruecallerAuthResult {
  const TruecallerAuthResult({
    required this.authorizationCode,
    required this.codeVerifier,
    required this.state,
    required this.scopesGranted,
  });

  final String authorizationCode;
  final String codeVerifier;
  final String state;
  final List<String> scopesGranted;

  factory TruecallerAuthResult.fromMap(Map<dynamic, dynamic> map) {
    return TruecallerAuthResult(
      authorizationCode: map['authorizationCode']?.toString() ?? '',
      codeVerifier: map['codeVerifier']?.toString() ?? '',
      state: map['state']?.toString() ?? '',
      scopesGranted: (map['scopesGranted'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(growable: false),
    );
  }
}

class TruecallerAuthService {
  TruecallerAuthService() : _channel = const MethodChannel('dailykatha/truecaller');

  final MethodChannel _channel;

  Future<TruecallerAuthResult> startLogin() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      throw UnsupportedError('Truecaller login is only available on Android');
    }
    final response = await _channel.invokeMapMethod<dynamic, dynamic>('startLogin');
    if (response == null) {
      throw PlatformException(code: 'TRUECALLER_EMPTY', message: 'Truecaller returned no response');
    }
    return TruecallerAuthResult.fromMap(response);
  }
}
