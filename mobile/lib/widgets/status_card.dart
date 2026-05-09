import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../l10n/app_localizations.dart';
import '../l10n/festival_localizer.dart';
import '../models/katha_card.dart';
import '../theme/status_luxe_palette.dart';
import 'luxe_card_visuals.dart';

/// Dark editorial share card (HTML luxe reference): forest gradient, category pill,
/// serif hero, Playfair echo, category illustration, refined footer.
class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.card,
    required this.contentLanguage,
    this.insertedPhotoBytes,
    this.insertedPhotoOffset = Offset.zero,
    this.insertedPhotoScale = 1.0,
    this.insertedPhotoRotation = 0.0,
    this.insertedPhotoOpacity = 1.0,
    this.caption = '',
    this.captionColor,
    this.onPhotoTap,
    this.height = 460,
    this.width,
    this.compact = false,
    this.deckPosition,
    this.deckTotal,
  });

  final KathaCard card;
  final String contentLanguage;
  final Uint8List? insertedPhotoBytes;
  final Offset insertedPhotoOffset;
  final double insertedPhotoScale;
  final double insertedPhotoRotation;
  final double insertedPhotoOpacity;
  final String caption;
  final Color? captionColor;
  final VoidCallback? onPhotoTap;
  final double height;
  final double? width;
  final bool compact;

  /// Optional “03 / 240” counter (feed position).
  final int? deckPosition;
  final int? deckTotal;

  static const _cream = StatusLuxePalette.heroCream;
  static const _creamEcho = Color(0x8CF5E6C0);

  TextStyle _heroStyle(double fontSize) {
    final shadows = [
      Shadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 2)),
    ];
    switch (contentLanguage) {
      case 'te':
        return GoogleFonts.notoSerifTelugu(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1.52,
          color: _cream,
          shadows: shadows,
          decoration: TextDecoration.none,
        );
      case 'hi':
        return GoogleFonts.notoSerifDevanagari(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1.48,
          color: _cream,
          shadows: shadows,
          decoration: TextDecoration.none,
        );
      case 'ta':
        return GoogleFonts.notoSerifTamil(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1.48,
          color: _cream,
          shadows: shadows,
          decoration: TextDecoration.none,
        );
      case 'kn':
        return GoogleFonts.notoSerifKannada(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1.48,
          color: _cream,
          shadows: shadows,
          decoration: TextDecoration.none,
        );
      case 'ml':
        return GoogleFonts.notoSerifMalayalam(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1.48,
          color: _cream,
          shadows: shadows,
          decoration: TextDecoration.none,
        );
      case 'en':
        return GoogleFonts.playfairDisplay(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1.45,
          color: _cream,
          shadows: shadows,
          decoration: TextDecoration.none,
        );
      default:
        return GoogleFonts.notoSerifTelugu(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1.48,
          color: _cream,
          shadows: shadows,
          decoration: TextDecoration.none,
        );
    }
  }

  TextStyle _echoStyle(String echoLang, double fontSize) {
    switch (echoLang) {
      case 'te':
        return GoogleFonts.notoSerifTelugu(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          height: 1.72,
          color: _creamEcho,
          letterSpacing: 0.02,
          decoration: TextDecoration.none,
        );
      case 'hi':
        return GoogleFonts.notoSerifDevanagari(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          height: 1.72,
          color: _creamEcho,
          letterSpacing: 0.02,
          decoration: TextDecoration.none,
        );
      case 'ta':
        return GoogleFonts.notoSerifTamil(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          height: 1.72,
          color: _creamEcho,
          letterSpacing: 0.02,
          decoration: TextDecoration.none,
        );
      case 'kn':
        return GoogleFonts.notoSerifKannada(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          height: 1.72,
          color: _creamEcho,
          letterSpacing: 0.02,
          decoration: TextDecoration.none,
        );
      case 'ml':
        return GoogleFonts.notoSerifMalayalam(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          height: 1.72,
          color: _creamEcho,
          letterSpacing: 0.02,
          decoration: TextDecoration.none,
        );
      default:
        return GoogleFonts.playfairDisplay(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          height: 1.72,
          color: _creamEcho,
          letterSpacing: 0.02,
          decoration: TextDecoration.none,
        );
    }
  }

  TextStyle _metaStyle(double fontSize, FontWeight w, Color color, double letterSpacing) {
    return GoogleFonts.dmSans(
      fontSize: fontSize,
      fontWeight: w,
      color: color,
      letterSpacing: letterSpacing,
      decoration: TextDecoration.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    final luxe = StatusLuxePalette.forCategory(card.category);
    final hero = card.quoteFor(contentLanguage);
    final echoLang = contentLanguage == 'en' ? 'te' : 'en';
    final echo = card.secondaryQuoteFor(contentLanguage);
    final author = card.authorFor(contentLanguage);
    final pillText = card.isFestival && (card.festivalTag?.isNotEmpty ?? false)
        ? FestivalLocalizer.displayFromTag(card.festivalTag, contentLanguage)
        : StatusLuxePalette.pillLabel(card.category, contentLanguage);
    final pillDisplay = pillText.runes.every((r) => r < 128) ? pillText.toUpperCase() : pillText;
    final deckStr = (deckPosition != null && deckTotal != null && deckTotal! > 0)
        ? '${deckPosition!.toString().padLeft(2, '0')} / $deckTotal'
        : null;

    final hp = compact ? 21.0 : 20.0;
    final ep = compact ? 12.5 : 14.0;
    // (kept for legacy illustration slot; no longer used)
    // final illH = compact ? 110.0 : 130.0;

    Widget body(double w) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: LuxeCardBackgroundPainter(luxe)),
            CustomPaint(painter: LuxeInsetBorderPainter(accent: luxe.accent)),
            Positioned(
              top: 13,
              left: 13,
              width: 26,
              height: 26,
              child: CustomPaint(painter: LuxeCornerPainter(color: luxe.accent)),
            ),
            Positioned(
              top: 13,
              right: 13,
              width: 26,
              height: 26,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.diagonal3Values(-1, 1, 1),
                child: CustomPaint(painter: LuxeCornerPainter(color: luxe.accent)),
              ),
            ),
            Positioned(
              bottom: 13,
              left: 13,
              width: 26,
              height: 26,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.diagonal3Values(1, -1, 1),
                child: CustomPaint(painter: LuxeCornerPainter(color: luxe.accent)),
              ),
            ),
            Positioned(
              bottom: 13,
              right: 13,
              width: 26,
              height: 26,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.diagonal3Values(-1, -1, 1),
                child: CustomPaint(painter: LuxeCornerPainter(color: luxe.accent)),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(compact ? 20 : 22, compact ? 24 : 22, compact ? 20 : 22, compact ? 20 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(7, 4, 10, 4),
                          decoration: BoxDecoration(
                            color: luxe.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: luxe.accent.withValues(alpha: 0.35)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: luxe.accent,
                                  boxShadow: [
                                    BoxShadow(color: luxe.accent.withValues(alpha: 0.55), blurRadius: 5),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  pillDisplay,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: _metaStyle(
                                    compact ? 8.5 : 9,
                                    FontWeight.w500,
                                    luxe.accent,
                                    0.9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (deckStr != null) ...[
                        const SizedBox(width: 10),
                        Text(
                          deckStr,
                          style: _metaStyle(
                            compact ? 10 : 11,
                            FontWeight.w300,
                            luxe.accent.withValues(alpha: 0.4),
                            1.2,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: compact ? 22 : 28),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                luxe.accent.withValues(alpha: 0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Transform.rotate(
                          angle: 0.785398,
                          child: Container(
                            width: 6,
                            height: 6,
                            color: luxe.accent.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                luxe.accent.withValues(alpha: 0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: compact ? 20 : 24),
                  Text(hero, textAlign: TextAlign.center, style: _heroStyle(hp)),
                  SizedBox(height: compact ? 18 : 22),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 32,
                      height: 1,
                      color: luxe.accent.withValues(alpha: 0.5),
                    ),
                  ),
                  SizedBox(height: compact ? 16 : 20),
                  Text(echo, textAlign: TextAlign.center, style: _echoStyle(echoLang, ep)),
                  SizedBox(height: compact ? 14 : 18),
                  Text(
                    author,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontSize: compact ? 10.5 : 11.5,
                      fontWeight: FontWeight.w300,
                      color: luxe.accent.withValues(alpha: 0.62),
                      letterSpacing: 1.1,
                      height: 1.35,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: compact ? 14 : 18),
                  Expanded(
                    child: Center(
                      child: _PhotoSlot(
                        width: w * 0.86,
                        height: compact ? 140 : 170,
                        accent: luxe.accent,
                        bytes: insertedPhotoBytes,
                        offset: insertedPhotoOffset,
                        scale: insertedPhotoScale,
                        rotation: insertedPhotoRotation,
                        opacity: insertedPhotoOpacity,
                        caption: caption,
                        captionColor: captionColor ?? _cream,
                        compact: compact,
                        onTap: onPhotoTap,
                      ),
                    ),
                  ),
                  Container(height: 1, color: luxe.accent.withValues(alpha: 0.1)),
                  SizedBox(height: compact ? 14 : 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CustomPaint(painter: LuxeFooterStarPainter(color: luxe.accent)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          Text(
                            AppLocalizations.of(context).footerDailyKatha.toUpperCase(),
                            style: _metaStyle(10, FontWeight.w500, luxe.accent.withValues(alpha: 0.72), 2.0),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppLocalizations.of(context).brandTagline.toUpperCase(),
                            style: _metaStyle(9, FontWeight.w300, luxe.accent.withValues(alpha: 0.38), 1.5),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CustomPaint(painter: LuxeFooterStarPainter(color: luxe.accent)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget shell(double w) {
      return SizedBox(
        width: w,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 28,
                offset: const Offset(0, 16),
                spreadRadius: -5,
              ),
            ],
          ),
          child: body(w),
        ),
      );
    }

    if (width != null) {
      return shell(width!.clamp(200.0, 1080.0));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth.clamp(260.0, 420.0);
        return shell(w);
      },
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  const _PhotoSlot({
    required this.width,
    required this.height,
    required this.accent,
    required this.bytes,
    required this.offset,
    required this.scale,
    required this.rotation,
    required this.opacity,
    required this.caption,
    required this.captionColor,
    required this.compact,
    required this.onTap,
  });

  final double width;
  final double height;
  final Color accent;
  final Uint8List? bytes;
  final Offset offset;
  final double scale;
  final double rotation;
  final double opacity;
  final String caption;
  final Color captionColor;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final border = Border.all(color: accent.withValues(alpha: 0.35));
    final box = BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      border: border,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.32),
          blurRadius: 24,
          offset: const Offset(0, 14),
          spreadRadius: -10,
        ),
      ],
    );

    final clickable = onTap != null;

    // UX: in normal viewing mode (home/feed) we don't want a visible empty photo box.
    // Only show the framed slot when (a) a photo exists, or (b) the slot is tappable (editor).
    final child = bytes == null
        ? (clickable
            ? Container(
                alignment: Alignment.center,
                decoration: box.copyWith(color: Colors.black.withValues(alpha: 0.18)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined, color: accent.withValues(alpha: 0.8), size: 28),
                    const SizedBox(height: 8),
                    Text(
                      'Add photo',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: accent.withValues(alpha: 0.9),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink())
        : Container(
            decoration: box,
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..translateByDouble(offset.dx, offset.dy, 0, 1)
                    ..rotateZ(rotation)
                    ..scaleByDouble(scale, scale, 1, 1),
                  child: Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: Image.memory(
                      key: ValueKey(bytes.hashCode),
                      bytes!,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true,
                      errorBuilder: (ctx, err, st) {
                        return Container(
                          color: Colors.black.withValues(alpha: 0.18),
                          alignment: Alignment.center,
                          child: Icon(Icons.broken_image_outlined, color: accent.withValues(alpha: 0.8)),
                        );
                      },
                    ),
                  ),
                ),
                if (caption.trim().isNotEmpty)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: accent.withValues(alpha: 0.25)),
                      ),
                      child: Text(
                        caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.dmSans(
                          fontSize: compact ? 10 : 11,
                          fontWeight: FontWeight.w600,
                          color: captionColor,
                          letterSpacing: 0.3,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );

    return SizedBox(
      width: width,
      height: height,
      child: clickable
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(18),
                child: child,
              ),
            )
          : (bytes == null ? const SizedBox.shrink() : child),
    );
  }
}
