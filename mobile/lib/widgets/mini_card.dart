import 'dart:ui';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/genre_localizer.dart';
import '../models/katha_card.dart';
import '../theme/app_colors.dart';
import '../theme/card_gradients.dart';

/// Horizontal rail preview — dark editorial surface in dark mode, gradient in light.
class MiniCard extends StatelessWidget {
  const MiniCard({
    super.key,
    required this.card,
    required this.contentLanguage,
    required this.onTap,
    this.width = 140,
    this.blurred = false,
  });

  final KathaCard card;
  final String contentLanguage;
  final VoidCallback onTap;
  final double width;
  final bool blurred;

  Widget _maybeBlur({required Widget child}) {
    if (!blurred) return child;
    return Stack(
      children: [
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: child,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.08),
                  Colors.black.withValues(alpha: 0.18),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Center(
              child: Icon(Icons.lock_outline, color: Colors.white70, size: 22),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hero = card.quoteFor(contentLanguage);
    final echo = card.secondaryQuoteFor(contentLanguage);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final genreLabel = GenreLocalizer.getName(card.category, contentLanguage);
    final footer = AppLocalizations.of(context).footerDailyKatha;

    if (dark) {
      return GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.accentGoldBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(21),
            child: SizedBox(
              width: width,
              height: width * 1.5,
              child: _maybeBlur(
                child: Container(
                  color: AppColors.surfaceDark,
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '✦ $genreLabel ✦',
                        style: const TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 9,
                          letterSpacing: 2.2,
                          color: AppColors.accentGold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hero,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          height: 1.32,
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 36,
                        height: 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: AppColors.accentGold.withValues(alpha: 0.45),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        echo,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          height: 1.38,
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        footer.toUpperCase(),
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 7,
                          letterSpacing: 1.8,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accentGold.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final pal = CardGradients.paletteFor(card.mood);
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: width,
            height: width * 1.5,
            child: _maybeBlur(
              child: Container(
                decoration: BoxDecoration(gradient: pal.gradient),
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '✦ $genreLabel ✦',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 9,
                        letterSpacing: 2.2,
                        color: pal.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      hero,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.32,
                        color: pal.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 36,
                      height: 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                        gradient: LinearGradient(
                          colors: [
                            pal.accent.withValues(alpha: 0.2),
                            pal.accent.withValues(alpha: 0.65),
                            pal.accent.withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      echo,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        height: 1.38,
                        color: pal.ink.withValues(alpha: 0.82),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      footer.toUpperCase(),
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 7,
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.w800,
                        color: pal.accent.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
