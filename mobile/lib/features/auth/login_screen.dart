import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_config.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../models/otp_route_args.dart';
import '../../theme/app_colors.dart';
import '../../widgets/brand_mark.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phone = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  String get _digits => _phone.text.replaceAll(RegExp(r'\D'), '');

  Future<void> _sendOtp() async {
    final d = _digits;
    setState(() {
      _error = null;
    });
    if (d.length != 10) {
      setState(() => _error = 'Enter a valid 10-digit mobile number');
      return;
    }
    setState(() => _loading = true);
    try {
      final res = await ref.read(authRepositoryProvider).sendOtp(d);
      if (!mounted) return;
      final args = OtpRouteArgs(phoneDigits: d, requestId: res.requestId);
      context.push('/otp', extra: args);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const BrandMark(compact: false),
              const SizedBox(height: 32),
              Text(l10n.loginWelcome, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                l10n.loginSubtitle,
                style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 15),
              ),
              const SizedBox(height: 28),
              Text(
                l10n.loginMobileLabel,
                style: const TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontSize: 12,
                  letterSpacing: 1.2,
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
                Text(_error!, style: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 13)),
              ],
              const Spacer(),
              if (!AppConfig.useLiveOtp)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Dev build: OTP is not sent to the server. Use any 6 digits on the next screen.',
                    style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _loading ? null : _sendOtp,
                  child: Text(_loading ? 'Sending…' : '${l10n.loginSendOtp} →'),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.loginTerms,
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
