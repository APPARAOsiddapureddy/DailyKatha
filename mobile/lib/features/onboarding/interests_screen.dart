import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/local/mock_catalog.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/genre_localizer.dart';
import '../../models/onboarding_args.dart';
import '../../theme/app_colors.dart';

class InterestsScreen extends ConsumerStatefulWidget {
  const InterestsScreen({super.key, required this.args});

  final OnboardingArgs args;

  @override
  ConsumerState<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends ConsumerState<InterestsScreen> {
  final Set<String> _selected = {'goodmorning', 'bhakti'};

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else if (_selected.length < 3) {
        _selected.add(id);
      }
    });
  }

  Future<void> _finish() async {
    final session = await ref.read(authRepositoryProvider).completeOnboardingOnServer(
          contentLanguage: widget.args.contentLanguage,
          religionId: widget.args.religionId,
          interestIds: _selected.toList(),
        );
    ref.read(sessionHolderProvider.notifier).setSession(session);
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = widget.args.contentLanguage;
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        title: Text(l10n.onboardingStep3),
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
            Text(l10n.onboardingInterestsTitle, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              l10n.onboardingInterestsSubtitle,
              style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.textSecondaryDark),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _selected.length == 3 ? AppColors.accentGoldSubtleBg : AppColors.surfaceElevatedDark,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: _selected.length == 3 ? AppColors.accentGold : AppColors.borderOnDark,
                ),
              ),
              child: Text(
                l10n.onboardingInterestCount(_selected.length),
                style: TextStyle(
                  color: _selected.length == 3 ? AppColors.accentGold : AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                itemCount: MockCatalog.interests.length,
                itemBuilder: (context, index) {
                  final item = MockCatalog.interests[index];
                  final selected = _selected.contains(item.id);
                  final disabled = !selected && _selected.length >= 3;
                  final primary = GenreLocalizer.getName(item.id, lang);
                  return Opacity(
                    opacity: disabled ? 0.38 : 1,
                    child: InkWell(
                      onTap: disabled ? null : () => _toggle(item.id),
                      borderRadius: BorderRadius.circular(18),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(10),
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
                            Text(item.emoji, style: const TextStyle(fontSize: 24)),
                            const Spacer(),
                            Text(
                              primary,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppColors.textPrimaryDark,
                              ),
                            ),
                            if (lang != 'en')
                              Text(
                                item.englishLabel,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textTertiaryDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _selected.isEmpty ? null : _finish,
                child: Text(l10n.onboardingFinishCta),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
