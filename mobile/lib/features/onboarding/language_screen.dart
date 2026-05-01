import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/local/mock_catalog.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selected = 'en';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        title: Text(l10n.onboardingStep1),
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
            Text(l10n.onboardingLanguageQuestion, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              l10n.onboardingLanguageSubtitle,
              style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.textSecondaryDark),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: MockCatalog.languages.length,
                itemBuilder: (context, index) {
                  final l = MockCatalog.languages[index];
                  final selected = _selected == l.id;
                  return InkWell(
                    onTap: () => setState(() => _selected = l.id),
                    borderRadius: BorderRadius.circular(18),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.accentGoldSubtleBg : AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: selected ? AppColors.accentGold : AppColors.borderOnDark,
                          width: selected ? 2 : 1.5,
                        ),
                        boxShadow: selected
                            ? [BoxShadow(color: AppColors.accentGold.withValues(alpha: 0.2), blurRadius: 18, offset: const Offset(0, 8))]
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l.emoji, style: const TextStyle(fontSize: 26)),
                          const Spacer(),
                          Text(
                            l.nativeName,
                            style: TextStyle(
                              fontSize: l.id == 'en' ? 18 : 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimaryDark,
                            ),
                          ),
                          Text(
                            '${l.englishName} · ${l.speakersLabel}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textTertiaryDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (selected)
                            const Align(
                              alignment: Alignment.topRight,
                              child: Icon(Icons.check_circle, color: AppColors.accentGold),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.push('/onboarding/religion', extra: _selected),
                child: Text(l10n.onboardingContinue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
