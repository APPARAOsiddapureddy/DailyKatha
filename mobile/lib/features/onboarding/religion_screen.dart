import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/local/mock_catalog.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/religion_localizer.dart';
import '../../models/onboarding_args.dart';
import '../../theme/app_colors.dart';

const _religionGlyph = <String, String>{
  'hindu': 'ॐ',
  'muslim': '☪',
  'christian': '✝',
  'sikh': '☬',
  'spiritual': '✦',
  'none': '·',
};

class ReligionScreen extends StatelessWidget {
  const ReligionScreen({super.key, required this.uiLanguage});

  final String uiLanguage;

  @override
  Widget build(BuildContext context) {
    return _ReligionBody(uiLanguage: uiLanguage);
  }
}

class _ReligionBody extends StatefulWidget {
  const _ReligionBody({required this.uiLanguage});

  final String uiLanguage;

  @override
  State<_ReligionBody> createState() => _ReligionBodyState();
}

class _ReligionBodyState extends State<_ReligionBody> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = widget.uiLanguage;
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.protoCream,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.protoInk.withValues(alpha: 0.06),
                  ),
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  color: AppColors.protoInk,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.onboardingStep2, style: tt.labelLarge),
                const SizedBox(height: 10),
                Text(l10n.onboardingReligionTitle, style: tt.headlineMedium),
                const SizedBox(height: 10),
                Text(
                  l10n.onboardingReligionSubtitle,
                  style: tt.bodyLarge?.copyWith(color: AppColors.protoInk3, height: 1.45),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              itemCount: MockCatalog.religions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final r = MockCatalog.religions[index];
                final on = _selected == r.id;
                final native = ReligionLocalizer.nativeLabel(r.id, lang);
                final glyph = _religionGlyph[r.id] ?? '✦';
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => setState(() => _selected = r.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.protoSurface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          width: on ? 2.5 : 1,
                          color: on ? AppColors.protoBrand : AppColors.protoBorder,
                        ),
                        boxShadow: on
                            ? [
                                BoxShadow(
                                  color: AppColors.protoBrand.withValues(alpha: 0.12),
                                  blurRadius: 18,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: on ? AppColors.protoBrand : AppColors.protoSurfaceAlt,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              glyph,
                              style: TextStyle(
                                fontSize: 20,
                                color: on ? Colors.white : AppColors.protoInk2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang == 'en' ? r.englishLabel : '$native · ${r.englishLabel}',
                                  style: tt.titleMedium?.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  r.note,
                                  style: tt.bodyMedium?.copyWith(fontSize: 12, height: 1.35),
                                ),
                              ],
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: on ? 0 : 2,
                                color: on ? Colors.transparent : AppColors.protoBorder,
                              ),
                              color: on ? AppColors.protoBrand : Colors.transparent,
                            ),
                            child: on
                                ? const Icon(Icons.check, size: 12, color: Colors.white)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        side: BorderSide(color: AppColors.protoBorder.withValues(alpha: 0.9)),
                      ),
                      onPressed: () => context.push(
                        '/onboarding/interests',
                        extra: OnboardingArgs(contentLanguage: widget.uiLanguage),
                      ),
                      child: Text(l10n.onboardingSkip),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _selected == null
                          ? null
                          : () => context.push(
                                '/onboarding/interests',
                                extra: OnboardingArgs(
                                  contentLanguage: widget.uiLanguage,
                                  religionId: _selected,
                                ),
                              ),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(l10n.onboardingContinue.replaceAll(' →', '')),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
