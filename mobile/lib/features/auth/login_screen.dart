import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../theme/app_colors.dart';
import '../../widgets/brand_mark.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _startTruecaller() async {
    setState(() => _error = null);
    setState(() => _loading = true);
    try {
      final login = await ref.read(truecallerAuthServiceProvider).startLogin();
      final session = await ref.read(authRepositoryProvider).signInWithTruecaller(
            authorizationCode: login.authorizationCode,
            codeVerifier: login.codeVerifier,
            state: login.state,
          );
      ref.read(sessionHolderProvider.notifier).setSession(session);
      if (!mounted) return;
      if (session.profile.onboardingComplete) {
        context.go('/home');
      } else {
        context.go('/onboarding/language');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = _messageFromError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const BrandMark(compact: false, color: AppColors.textPrimaryDark),
              const SizedBox(height: 32),
              Text(
                'Welcome back',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.accentGold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Continue with Truecaller to verify your number and enter Daily Katha.',
                style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 15, height: 1.35),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevatedDark,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderOnDarkStrong),
                ),
                child: const Text(
                  'We will use your Truecaller consent to verify your phone number. '
                  'No manual code entry is needed for this build.',
                  style: TextStyle(color: AppColors.textPrimaryDark, height: 1.4),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: const TextStyle(color: Color(0xFFFF8A8A), fontSize: 13, height: 1.35),
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _loading ? null : _startTruecaller,
                  child: Text(_loading ? 'Connecting…' : 'Continue with Truecaller'),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'By continuing, you agree to our Terms and Privacy Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppColors.textTertiaryDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _messageFromError(Object error) {
  if (error is DioException) {
    final status = error.response?.statusCode;
    if (status == 401) {
      return 'Truecaller sign-in could not be completed. Check the backend setup and try again.';
    }
    return 'Truecaller sign-in failed. Please try again.';
  }
  final text = error.toString();
  if (text.contains('TRUECALLER_NOT_USABLE')) {
    return 'Install and sign in to Truecaller on this device, then try again.';
  }
  if (text.contains('STATE_MISMATCH')) {
    return 'Truecaller verification could not be matched. Please try again.';
  }
  if (text.contains('TRUECALLER_')) {
    return 'Truecaller sign-in failed. Please try again.';
  }
  return 'Truecaller sign-in failed. Please try again.';
}
