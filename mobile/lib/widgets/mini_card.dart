import 'dart:ui';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/genre_localizer.dart';
import '../models/katha_card.dart';
import '../theme/app_colors.dart';
import '../theme/card_gradients.dart';

/// Rail preview — blurred cards stay tappable (no lock icon).
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
            imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: child,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: const Color(0x2E1A1410),
            ),
          ),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xEBFFFFFF),
              borderRadius: BorderRadius.circular(999),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2E000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.touch_app_outlined, size: 16, color: AppColors.protoBrand),
                SizedBox(width: 6),
                Text(
                  'Tap to open',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.protoInk,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
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
    final genreLabel = GenreLocalizer.getName(card.category, contentLanguage);
    final footer = AppLocalizations.of(context).footerDailyKatha;
    final pal = CardGradients.paletteFor(card.mood);

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
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
