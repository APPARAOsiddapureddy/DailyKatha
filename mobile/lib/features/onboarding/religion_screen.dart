import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/local/mock_catalog.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/religion_localizer.dart';
import '../../models/onboarding_args.dart';
import '../../theme/app_colors.dart';

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
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        title: Text(l10n.onboardingStep2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.onboardingReligionTitle, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              l10n.onboardingReligionSubtitle,
              style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.textSecondaryDark),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: MockCatalog.religions.length,
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final r = MockCatalog.religions[index];
                  final selected = _selected == r.id;
                  final native = ReligionLocalizer.nativeLabel(r.id, lang);
                  return InkWell(
                    onTap: () => setState(() => _selected = r.id),
                    borderRadius: BorderRadius.circular(18),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      height: 90,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.accentGoldSubtleBg : AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: selected ? AppColors.accentGold : AppColors.borderOnDark,
                          width: selected ? 2 : 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                r.englishLabel,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimaryDark,
                                ),
                              ),
                              if (lang != 'en') ...[
                                const SizedBox(width: 8),
                                Text(
                                  '· $native',
                                  style: const TextStyle(
                                    color: AppColors.textTertiaryDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            r.note,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondaryDark,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
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
                    child: Text(l10n.onboardingContinue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
