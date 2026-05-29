import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../models/otp_route_args.dart';
import '../../theme/app_colors.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.args});

  final OtpRouteArgs args;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focus = List.generate(6, (_) => FocusNode());
  bool _verifying = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefillTestOtpIfNeeded());
  }

  void _prefillTestOtpIfNeeded() {
    if (!mounted) return;
    final ch = widget.args.channel?.toLowerCase();
    if (ch != 'test') return;
    final msg = widget.args.serverMessage ?? '';
    final m = RegExp(r'(\d{6})').firstMatch(msg);
    if (m == null) return;
    final digits = m.group(1)!;
    for (var i = 0; i < 6; i++) {
      _controllers[i].text = digits[i];
    }
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _verify();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focus) {
      f.dispose();
    }
    super.dispose();
  }

  bool get _complete => _controllers.every((c) => c.text.length == 1);

  void _goNext(bool onboardingComplete) {
    final target = onboardingComplete ? '/home' : '/onboarding/language';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.go(target);
    });
  }

  Future<void> _verify() async {
    if (!_complete || _verifying) return;
    final code = _controllers.map((c) => c.text).join();
    setState(() {
      _error = null;
      _verifying = true;
    });
    try {
      final session = await ref.read(authRepositoryProvider).verifyOtp(
            phoneDigits: widget.args.phoneDigits,
            requestId: widget.args.requestId,
            code: code,
          );
      ref.read(sessionHolderProvider.notifier).setSession(session);
      if (!mounted) return;
      _goNext(session.profile.onboardingComplete);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = _messageFromError(e));
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      _controllers[index].text = value.substring(value.length - 1);
    }
    if (value.isNotEmpty && index < 5) {
      _focus[index + 1].requestFocus();
    }
    if (_complete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _verify();
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final phoneFmt =
        widget.args.phoneDigits.length >= 10
            ? '${widget.args.phoneDigits.substring(0, 5)}…${widget.args.phoneDigits.substring(8)}'
            : widget.args.phoneDigits;

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.otpEnterCode, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              l10n.otpSentTo(phoneFmt),
              style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 14),
            ),
            if (widget.args.serverMessage != null && widget.args.serverMessage!.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevatedDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.35)),
                  ),
                  child: Text(
                    widget.args.serverMessage!.trim(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimaryDark,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < 6; i++)
                  SizedBox(
                    width: 44,
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _focus[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 22,
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: AppColors.surfaceDark,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) => _onDigitChanged(i, v),
                    ),
                  ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(_error!, style: const TextStyle(color: Color(0xFFFF8A8A), fontSize: 13)),
            ],
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevatedDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderOnDarkStrong),
              ),
              child: Text(
                'Enter the 6-digit code sent to your phone.',
                style: const TextStyle(fontSize: 13, color: AppColors.textPrimaryDark),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: (_verifying || !_complete) ? null : _verify,
                child: Text(_verifying ? 'Verifying…' : l10n.otpVerify),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _messageFromError(Object error) {
  final text = error.toString();
  if (text.contains('INVALID_OTP')) {
    return 'Incorrect code. Please try again.';
  }
  if (text.contains('INVALID_PHONE')) {
    return 'Enter a valid 10-digit mobile number.';
  }
  if (text.startsWith('Exception: ')) {
    return text.substring('Exception: '.length);
  }
  return 'Verification failed. Please try again.';
}
