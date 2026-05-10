import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/katha_card.dart';
import '../services/card_share_export.dart';
import '../theme/app_colors.dart';
import 'status_card.dart';

/// Horizontal-rail preview: full logical [StatusCard] (360×640) uniformly scaled to fit —
/// typography scales down with the card (no oversized fonts in thumbnails).
class StatusRailThumbnail extends StatelessWidget {
  const StatusRailThumbnail({
    super.key,
    required this.card,
    required this.contentLanguage,
    required this.onTap,
    this.blurred = false,
    this.height = 218,
  });

  final KathaCard card;
  final String contentLanguage;
  final VoidCallback onTap;
  final bool blurred;
  final double height;

  double get _outerWidth => height * CardShareExport.logicalAspectRatio;

  Widget _cardBody() {
    return FittedBox(
      fit: BoxFit.contain,
      alignment: Alignment.center,
      child: SizedBox(
        width: CardShareExport.logicalExportWidth,
        height: CardShareExport.logicalExportHeight,
        child: StatusCard(
          card: card,
          contentLanguage: contentLanguage,
          compact: false,
          width: CardShareExport.logicalExportWidth,
          height: CardShareExport.logicalExportHeight,
        ),
      ),
    );
  }

  Widget _blurWrap(Widget preview) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: preview,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: const Color(0x591A1410),
            ),
          ),
        ),
        Builder(
          builder: (context) {
            final chip = Theme.of(context).textTheme.bodySmall?.copyWith(
                  decoration: TextDecoration.none,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.protoInk,
                  letterSpacing: 0.2,
                );
            return Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.touch_app_outlined,
                      size: 16,
                      color: AppColors.protoBrand,
                    ),
                    const SizedBox(width: 6),
                    Text('Tap to open', style: chip),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final preview = SizedBox(
      width: _outerWidth,
      height: height,
      child: _cardBody(),
    );
    return SizedBox(
      width: _outerWidth,
      height: height,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: blurred ? _blurWrap(preview) : preview,
        ),
      ),
    );
  }
}
