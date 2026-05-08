import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'config/flavor_config.dart';

Future<void> main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('══════════════════════════════════');
    debugPrint('FLUTTER ERROR: ${details.exception}');
    debugPrint('LOCATION: ${details.library}');
    debugPrint('STACK:\n${details.stack}');
    debugPrint('══════════════════════════════════');
  };

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
        debugPrint('══════════════════════════════════');
        debugPrint('PLATFORM ERROR: $error');
        debugPrint('STACK:\n$stack');
        debugPrint('══════════════════════════════════');
        return true;
      };

      try {
        await _initializeApp();
        runApp(const ProviderScope(child: DailyKathaApp()));
      } catch (e, stack) {
        debugPrint('══════════════════════════════════');
        debugPrint('INIT ERROR: $e');
        debugPrint('STACK:\n$stack');
        debugPrint('══════════════════════════════════');
        runApp(MaterialApp(home: _CrashScreen(error: e.toString(), stack: stack.toString())));
      }
    },
    (error, stack) {
      debugPrint('══════════════════════════════════');
      debugPrint('ZONE ERROR: $error');
      debugPrint('STACK:\n$stack');
      debugPrint('══════════════════════════════════');
    },
  );
}

Future<void> _initializeApp() async {
  debugPrint('>>> Starting DailyKatha initialization...');

  debugPrint('>>> Step 1: FlavorConfig...');
  debugPrint('>>> Flavor OK — flavor: ${FlavorConfig.flavor} apiBase: ${FlavorConfig.apiBase}');

  debugPrint('>>> Step 2: SharedPreferences...');
  try {
    await SharedPreferences.getInstance();
    debugPrint('>>> SharedPreferences OK');
  } catch (e) {
    debugPrint('>>> SharedPreferences error: $e');
  }

  debugPrint('>>> Step 3: SecureStorage...');
  try {
    const storage = FlutterSecureStorage();
    await storage.read(key: 'dk_access_token');
    debugPrint('>>> SecureStorage OK');
  } catch (e) {
    debugPrint('>>> SecureStorage error: $e');
    // Some devices / OEM ROMs can throw from Android Keystore on first boot or after updates.
    // The app can still run without secure storage; session persistence may not survive restarts.
  }

  debugPrint('>>> Step 4: Providers...');
  debugPrint('>>> Providers OK (initialized in ProviderScope)');

  debugPrint('>>> Initialization complete.');
}

class _CrashScreen extends StatelessWidget {
  const _CrashScreen({required this.error, required this.stack});

  final String error;
  final String stack;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF080808),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.error_outline, color: Color(0xFFC89B3C), size: 48),
                const SizedBox(height: 16),
                const Text(
                  'App failed to start',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    error,
                    style: const TextStyle(
                      color: Color(0xFFFF6B6B),
                      fontSize: 13,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Stack trace:', style: TextStyle(color: Colors.white54, fontSize: 11)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    stack.length > 2000 ? '${stack.substring(0, 2000)}...' : stack,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
