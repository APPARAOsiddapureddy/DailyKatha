import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/local/mock_catalog.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/genre_localizer.dart';
import '../../models/onboarding_args.dart';
import '../../theme/app_colors.dart';

/// Category fills aligned with `tokens.js` `DK.cat` for the prototype grid.
Color _interestAccentBg(String id) {
  return switch (id) {
    'bhakti' => const Color(0xFF5B1A1A),
    'love' => const Color(0xFF7A2540),
    'motivation' => const Color(0xFF1B2D44),
    'festival' => const Color(0xFF7E1F0E),
    'goodmorning' => const Color(0xFFC66829),
    'goodnight' => const Color(0xFF1F2848),
    'friendship' => const Color(0xFF2C5F4A),
    'family' => const Color(0xFF5B3220),
    'poetry' => const Color(0xFF3A2548),
    'birthday' => const Color(0xFFA93757),
    'cinema' => const Color(0xFF1B2D44),
    'heroes' => const Color(0xFF2A2566),
    _ => AppColors.protoBrand,
  };
}

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
    final tt = Theme.of(context).textTheme;
    const items = MockCatalog.interests;

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
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.onboardingStep3, style: tt.labelLarge),
                const SizedBox(height: 10),
                Text(l10n.onboardingInterestsTitle, style: tt.headlineMedium),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    style: tt.bodyLarge?.copyWith(color: AppColors.protoInk3, height: 1.45),
                    children: [
                      TextSpan(text: '${l10n.onboardingInterestsSubtitle}  '),
                      TextSpan(
                        text: l10n.onboardingInterestCount(_selected.length),
                        style: const TextStyle(
                          color: AppColors.protoBrand,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 112,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final selected = _selected.contains(item.id);
                final disabled = !selected && _selected.length >= 3;
                final bg = selected ? _interestAccentBg(item.id) : AppColors.protoSurface;
                final label = GenreLocalizer.getName(item.id, lang);
                return Opacity(
                  opacity: disabled ? 0.45 : 1,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: disabled ? null : () => _toggle(item.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected ? Colors.transparent : AppColors.protoBorder,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: _interestAccentBg(item.id).withValues(alpha: 0.28),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ]
                              : null,
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.emoji, style: const TextStyle(fontSize: 26, height: 1)),
                                const Spacer(),
                                Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.2,
                                    color: selected ? Colors.white : AppColors.protoInk,
                                  ),
                                ),
                              ],
                            ),
                            if (selected)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.protoSaffron,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    size: 14,
                                    color: _interestAccentBg(item.id),
                                  ),
                                ),
                              ),
                          ],
                        ),
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
                onPressed: _selected.isEmpty ? null : _finish,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        _selected.isEmpty ? 'Pick at least one' : l10n.onboardingFinishCta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
