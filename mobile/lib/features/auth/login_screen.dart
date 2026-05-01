import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  bool _focused = false;
  bool _loading = false;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  bool get _valid {
    final digits = _phone.text.replaceAll(RegExp(r'\D'), '');
    // TESTING MODE: accept any 10 digits.
    return digits.length == 10;
  }

  String get _digits => _phone.text.replaceAll(RegExp(r'\D'), '');

  Future<void> _send() async {
    if (!_valid || _loading) return;
    setState(() => _loading = true);
    try {
      // TESTING MODE: do NOT call any API here.
      final args = OtpRouteArgs(phoneDigits: _digits, requestId: _digits);
      if (!mounted) return;
      context.push('/otp', extra: args);
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandMark(compact: true),
              const SizedBox(height: 36),
              Text(
                l10n.loginWelcome,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                l10n.loginSubtitle,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondaryDark,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              Divider(color: AppColors.borderOnDark),
              const SizedBox(height: 28),
              Text(
                l10n.loginMobileLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppColors.textTertiaryDark,
                ),
              ),
              const SizedBox(height: 10),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevatedDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _focused ? AppColors.accentGold : AppColors.borderOnDarkStrong,
                    width: _focused ? 2 : 1.5,
                  ),
                  boxShadow: _focused
                      ? [BoxShadow(color: AppColors.accentGold.withValues(alpha: 0.2), blurRadius: 0, spreadRadius: 3)]
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
                        border: Border(
                          right: BorderSide(color: AppColors.borderOnDark),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Text('🇮🇳', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 8),
                          Text(
                            '+91',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.textPrimaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '00000 00000',
                          hintStyle: TextStyle(color: AppColors.textTertiaryDark),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          color: AppColors.textPrimaryDark,
                        ),
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        onChanged: (_) => setState(() {}),
                        onTap: () => setState(() => _focused = true),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.shield_outlined, size: 16, color: AppColors.accentGold.withValues(alpha: 0.85)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'We\'ll send a 6-digit OTP. Your number stays private.',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: (_valid && !_loading) ? _send : null,
                  child: Text(_loading ? 'Sending…' : '${l10n.loginSendOtp} →'),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  l10n.loginTerms,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiaryDark, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
