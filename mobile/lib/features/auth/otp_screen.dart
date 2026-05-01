import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/flavor_config.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../models/otp_route_args.dart';
import '../../theme/app_colors.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.args});

  final OtpRouteArgs args;

  String get phoneDigits => args.phoneDigits;
  String get requestId => args.requestId;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  int _resend = 30;
  Timer? _timer;
  bool _verifying = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_resend <= 0) return;
      setState(() => _resend--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  bool get _complete => _controllers.every((c) => c.text.length == 1);

  Future<void> _resendOtp() async {
    if (_resend > 0) return;
    // TESTING MODE: no API calls. Just restart the timer.
    setState(() => _resend = 30);
  }

  Future<void> _verify() async {
    if (!_complete) return;
    if (_verifying) return;
    final code = _controllers.map((c) => c.text).join();
    try {
      setState(() {
        _verifying = true;
      });
      final session = await ref.read(authRepositoryProvider).verifyOtp(
            phoneDigits: widget.phoneDigits,
            requestId: widget.requestId,
            code: code,
          );
      ref.read(sessionHolderProvider.notifier).setSession(session);
      if (!mounted) return;
      // In testing/staging builds, always proceed through onboarding (OTP is a mock gate).
      if (!FlavorConfig.isProduction) {
        context.go('/onboarding/language');
        return;
      }

      if (session.profile.isAdmin) {
        context.go('/admin/dashboard');
      } else if (session.profile.onboardingComplete) {
        context.go('/home');
      } else {
        context.go('/onboarding/language');
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 6-digit OTP.')),
      );
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  void _onChanged(int index, String value) {
    final digit = value.replaceAll(RegExp(r'\D'), '');
    if (digit.isEmpty) {
      _controllers[index].text = '';
    } else {
      _controllers[index].text = digit.substring(digit.length - 1);
    }
    if (_controllers[index].text.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
    if (_complete) {
      unawaited(_verify());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final phoneFmt = widget.phoneDigits.length == 10
        ? '${widget.phoneDigits.substring(0, 5)} ${widget.phoneDigits.substring(5)}'
        : widget.phoneDigits;
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimaryDark),
                label: const Text('Back', style: TextStyle(color: AppColors.accentGold)),
              ),
              Text(l10n.otpEnterCode, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    l10n.otpSentTo(phoneFmt),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(foregroundColor: AppColors.accentGold),
                    child: const Text('Change'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: List.generate(6, (i) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextField(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                        onChanged: (v) => _onChanged(i, v),
                        onSubmitted: (_) => i < 5 ? _focusNodes[i + 1].requestFocus() : _verify(),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text('Didn\'t receive it?', style: TextStyle(color: AppColors.textSecondaryDark)),
                  const SizedBox(width: 8),
                  if (_resend > 0)
                    Text(
                      'Resend in ${_resend}s',
                      style: const TextStyle(color: AppColors.textTertiaryDark, fontWeight: FontWeight.w600),
                    )
                  else
                    TextButton(
                      onPressed: _resendOtp,
                      child: Text(l10n.otpResend),
                    ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevatedDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderOnDarkStrong, style: BorderStyle.solid),
                ),
                child: const Text(
                  'Demo: enter any 6 digits when using offline mock API.',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondaryDark),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: (_complete && !_verifying) ? _verify : null,
                  child: Text(_verifying ? 'Verifying…' : '${l10n.otpVerify} →'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
