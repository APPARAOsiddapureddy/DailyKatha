import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../models/otp_route_args.dart';
import '../../theme/app_colors.dart';
import '../../utils/safe_nav.dart';
import '../../widgets/brand_mark.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phone = TextEditingController();
  bool _sendingOtp = false;
  bool _startingTruecaller = false;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  String get _digits => _phone.text.replaceAll(RegExp(r'\D'), '');

  Future<void> _sendOtp() async {
    final d = _digits;
    setState(() => _error = null);
    if (d.length != 10) {
      setState(() => _error = 'Enter a valid 10-digit mobile number.');
      return;
    }
    setState(() => _sendingOtp = true);
    try {
      final res = await ref.read(authRepositoryProvider).sendOtp(d);
      if (!mounted) return;
      final args = OtpRouteArgs(
        phoneDigits: d,
        requestId: res.requestId,
        serverMessage: res.message,
        channel: res.channel,
      );
      context.push('/otp', extra: args);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = _messageFromError(e));
    } finally {
      if (mounted) setState(() => _sendingOtp = false);
    }
  }

  Future<void> _startTruecaller() async {
    setState(() => _error = null);
    setState(() => _startingTruecaller = true);
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
        safeGo(context, '/home');
      } else {
        safeGo(context, '/onboarding/language');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = _messageFromError(e));
    } finally {
      if (mounted) setState(() => _startingTruecaller = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
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
            const Text(
              'Use your phone number or Truecaller to enter Daily Katha.',
              style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 15, height: 1.35),
            ),
            const SizedBox(height: 28),
            Text(
              'Mobile number',
              style: TextStyle(
                color: AppColors.textSecondaryDark,
                fontSize: 12,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 20),
              decoration: InputDecoration(
                hintText: '9876543210',
                hintStyle: TextStyle(color: AppColors.textTertiaryDark),
                filled: true,
                fillColor: AppColors.surfaceDark,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.borderOnDark),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.accentGold, width: 1.5),
                ),
                prefixText: '+91 ',
                prefixStyle: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 20),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: const TextStyle(color: Color(0xFFFF8A8A), fontSize: 13, height: 1.35),
              ),
            ],
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _sendingOtp ? null : _sendOtp,
                child: Text(_sendingOtp ? 'Sending…' : 'Continue with OTP'),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevatedDark,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderOnDarkStrong),
              ),
              child: const Text(
                'If you prefer, continue with Truecaller instead of entering a code.',
                style: TextStyle(color: AppColors.textPrimaryDark, height: 1.4),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _startingTruecaller ? null : _startTruecaller,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.textPrimaryDark, width: 1.2),
                  foregroundColor: AppColors.textPrimaryDark,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(_startingTruecaller ? 'Connecting…' : 'Continue with Truecaller'),
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
    );
  }
}

String _messageFromError(Object error) {
  if (error is DioException) {
    final status = error.response?.statusCode;
    if (status == 401) {
      return 'Sign-in failed. Please try again.';
    }
    final data = error.response?.data;
    if (data is Map && data['error'] is Map) {
      final message = (data['error'] as Map)['message']?.toString();
      if (message != null && message.isNotEmpty) return message;
    }
    return 'Sign-in failed. Please try again.';
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
  return 'Sign-in failed. Please try again.';
}
