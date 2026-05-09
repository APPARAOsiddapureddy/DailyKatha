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
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.protoCream,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.onboardingStep1, style: tt.labelLarge),
                  const SizedBox(height: 10),
                  Text(
                    l10n.onboardingLanguageQuestion,
                    style: tt.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.onboardingLanguageSubtitle,
                    style: tt.bodyLarge?.copyWith(color: AppColors.protoInk3, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              itemCount: MockCatalog.languages.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final l = MockCatalog.languages[index];
                final on = _selected == l.id;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => setState(() => _selected = l.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: on ? AppColors.protoBrand : AppColors.protoSurfaceAlt,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              l.nativeName.characters.take(2).toString(),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontSize: l.id == 'en' ? 15 : 20,
                                fontWeight: FontWeight.w600,
                                color: on ? Colors.white : AppColors.protoInk2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.nativeName,
                                  style: tt.titleLarge?.copyWith(fontSize: 22),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${l.englishName} · ${l.speakersLabel}',
                                  style: tt.bodyMedium?.copyWith(fontSize: 13, color: AppColors.protoInk3),
                                ),
                              ],
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: on ? 0 : 2,
                                color: on ? Colors.transparent : AppColors.protoBorder,
                              ),
                              color: on ? AppColors.protoBrand : Colors.transparent,
                            ),
                            child: on
                                ? const Icon(Icons.check, size: 14, color: Colors.white)
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
              child: FilledButton(
                onPressed: () => context.push('/onboarding/religion', extra: _selected),
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
          ),
        ],
      ),
    );
  }
}
