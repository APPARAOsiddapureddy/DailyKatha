import 'dart:math' show min;
import 'dart:typed_data';
import 'dart:ui' show ImageFilter, Size;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../l10n/app_localizations.dart';
import '../l10n/festival_localizer.dart';
import '../models/katha_card.dart';
import '../models/status_card_photo_layer.dart';
import '../theme/status_luxe_palette.dart';
import '../theme/status_type_tokens.dart';
import 'luxe_card_visuals.dart';
import 'luxe_center_glyph.dart';
import 'luxe_theme_background.dart';

/// Fits the cropped image's aspect ratio inside the card without forcing a square box.
Size _photoDisplaySize(double cardW, double cardH, double imageAspectRatio) {
  final ar = imageAspectRatio.clamp(0.18, 6.0);
  final maxW = (cardW * 0.52).clamp(96.0, 240.0);
  final maxH = (cardH * 0.38).clamp(96.0, 280.0);
  var fw = maxW;
  var fh = fw / ar;
  if (fh > maxH) {
    fh = maxH;
    fw = fh * ar;
  }
  if (fw > maxW) {
    fw = maxW;
    fh = fw / ar;
  }
  return Size(fw, fh);
}

/// Radial scrim behind the quote stack — soft / strong / paper match design tokens; [none] skips paint.
BoxDecoration? _textScrimDecoration(LuxeScrimKind kind) {
  switch (kind) {
    case LuxeScrimKind.none:
      return null;
    case LuxeScrimKind.soft:
      return BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: RadialGradient(
          center: const Alignment(0, -0.08),
          radius: 0.72,
          colors: [
            const Color.fromRGBO(0, 0, 0, 0.32),
            const Color.fromRGBO(0, 0, 0, 0.12),
            const Color.fromRGBO(0, 0, 0, 0),
          ],
          stops: const [0.0, 0.52, 1.0],
        ),
      );
    case LuxeScrimKind.strong:
      return BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: RadialGradient(
          center: const Alignment(0, -0.06),
          radius: 0.74,
          colors: [
            const Color.fromRGBO(0, 0, 0, 0.55),
            const Color.fromRGBO(0, 0, 0, 0.32),
            const Color.fromRGBO(0, 0, 0, 0),
          ],
          stops: const [0.0, 0.48, 1.0],
        ),
      );
    case LuxeScrimKind.paper:
      return BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: RadialGradient(
          center: const Alignment(0, -0.08),
          radius: 0.70,
          colors: [
            const Color.fromRGBO(255, 250, 235, 0.55),
            const Color.fromRGBO(255, 250, 235, 0.18),
            const Color.fromRGBO(255, 250, 235, 0),
          ],
          stops: const [0.0, 0.46, 1.0],
        ),
      );
  }
}

/// Share card matching `card.jsx` + `themes.jsx`: illustrated [LuxeThemeBackgroundPainter],
/// dashed frames, paisley corners, [LuxeCenterGlyph], Telugu/English typography tokens.
class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.card,
    required this.contentLanguage,
    this.photoLayers,
    this.insertedPhotoBytes,
    this.insertedPhotoOffset = Offset.zero,
    this.insertedPhotoScale = 1.0,
    this.insertedPhotoRotation = 0.0,
    this.insertedPhotoOpacity = 1.0,
    this.caption = '',
    this.captionColor,
    this.interactivePhotoLayerIndex,
    this.onPhotoLayerScaleStart,
    this.onPhotoLayerScaleUpdate,
    this.height = 460,
    this.width,
    this.compact = false,
    this.deckPosition,
    this.deckTotal,
  });

  final KathaCard card;
  final String contentLanguage;

  /// Preferred: up to three cropped photos placed freely on the card.
  final List<StatusCardPhotoLayer>? photoLayers;

  /// Legacy single-photo API — maps to one layer when [photoLayers] is null.
  final Uint8List? insertedPhotoBytes;
  final Offset insertedPhotoOffset;
  final double insertedPhotoScale;
  final double insertedPhotoRotation;
  final double insertedPhotoOpacity;
  final String caption;
  final Color? captionColor;

  /// When set, only this layer receives pinch/pan gestures (editor).
  final int? interactivePhotoLayerIndex;
  final void Function(int index, ScaleStartDetails details)?
  onPhotoLayerScaleStart;
  final void Function(int index, ScaleUpdateDetails details)?
  onPhotoLayerScaleUpdate;

  final double height;
  final double? width;
  final bool compact;

  /// Optional “03 / 240” counter (feed position).
  final int? deckPosition;
  final int? deckTotal;

  static Widget _footerDiamond(Color accent, double side) {
    return Transform.rotate(
      angle: 0.785398,
      child: Container(width: side, height: side, color: accent),
    );
  }

  List<StatusCardPhotoLayer> _resolvedLayers(double cardW) {
    if (photoLayers != null && photoLayers!.isNotEmpty) {
      return photoLayers!;
    }
    if (insertedPhotoBytes != null) {
      return [
        StatusCardPhotoLayer(
          bytes: insertedPhotoBytes!,
          imageAspectRatio: 1.0,
          offset: insertedPhotoOffset + Offset(0, height * 0.22),
          scale: insertedPhotoScale,
          rotation: insertedPhotoRotation,
          opacity: insertedPhotoOpacity,
          caption: caption,
          captionColor: captionColor,
        ),
      ];
    }
    return [];
  }

  TextStyle _heroStyle(double fontSize, StatusTypeTokens type) {
    final shadows = type.heroShadows;
    final w = type.heroWeight;
    final ink = type.heroColor;
    switch (contentLanguage) {
      case 'te':
        return GoogleFonts.notoSerifTelugu(
          fontSize: fontSize,
          fontWeight: w,
          height: 1.32,
          color: ink,
          letterSpacing: 0.2,
          shadows: shadows,
          decoration: TextDecoration.none,
        );
      case 'hi':
        return GoogleFonts.notoSerifDevanagari(
          fontSize: fontSize,
          fontWeight: w,
          height: 1.32,
          color: ink,
          shadows: shadows,
          decoration: TextDecoration.none,
        );
      case 'ta':
        return GoogleFonts.notoSerifTamil(
          fontSize: fontSize,
          fontWeight: w,
          height: 1.32,
          color: ink,
          shadows: shadows,
          decoration: TextDecoration.none,
        );
      case 'kn':
        return GoogleFonts.notoSerifKannada(
          fontSize: fontSize,
          fontWeight: w,
          height: 1.32,
          color: ink,
          shadows: shadows,
          decoration: TextDecoration.none,
        );
      case 'ml':
        return GoogleFonts.notoSerifMalayalam(
          fontSize: fontSize,
          fontWeight: w,
          height: 1.32,
          color: ink,
          shadows: shadows,
          decoration: TextDecoration.none,
        );
      case 'en':
        return GoogleFonts.lora(
          fontSize: fontSize,
          fontWeight: w,
          height: 1.32,
          color: ink,
          shadows: shadows,
          decoration: TextDecoration.none,
        );
      default:
        return GoogleFonts.notoSerifTelugu(
          fontSize: fontSize,
          fontWeight: w,
          height: 1.32,
          color: ink,
          letterSpacing: 0.2,
          shadows: shadows,
          decoration: TextDecoration.none,
        );
    }
  }

  TextStyle _echoStyle(double fontSize, StatusTypeTokens type) {
    return GoogleFonts.lora(
      fontSize: fontSize,
      fontWeight: type.subWeight,
      fontStyle: FontStyle.italic,
      height: 1.45,
      color: type.subColor,
      shadows: type.subShadows,
      decoration: TextDecoration.none,
    );
  }

  TextStyle _pillStyle(double fontSize, Color ink) {
    return GoogleFonts.notoSerifTelugu(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: ink,
      decoration: TextDecoration.none,
    );
  }

  TextStyle _metaStyle(
    double fontSize,
    FontWeight w,
    Color color,
    double letterSpacing,
  ) {
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
    final type = StatusTypeTokens.forCategory(card.category);
    final scrimDec = _textScrimDecoration(type.scrimKind);
    final heroPx = type.heroSize * (compact ? 24 / 27 : 1.0);
    final echoPx = compact ? 13.0 : 14.0;
    final hero = card.quoteFor(contentLanguage);
    final echo = card.secondaryQuoteFor(contentLanguage);
    final author = card.authorFor(contentLanguage);
    final pillText = card.isFestival && (card.festivalTag?.isNotEmpty ?? false)
        ? FestivalLocalizer.displayFromTag(card.festivalTag, contentLanguage)
        : StatusLuxePalette.pillLabel(card.category, contentLanguage);
    final pillDisplay = pillText.runes.every((r) => r < 128)
        ? pillText.toUpperCase()
        : pillText;
    final deckStr =
        (deckPosition != null && deckTotal != null && deckTotal! > 0)
        ? '${deckPosition!.toString().padLeft(2, '0')} / $deckTotal'
        : null;

    Widget body(double w) {
      final echoMaxW = min(250.0, w * 0.92);
      final inset = w * 22 / 360;
      final insetY = height * 22 / 560;
      final layers = _resolvedLayers(w);

      return ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: LuxeThemeBackgroundPainter(card.category)),
            CustomPaint(
              painter: LuxeDashedFramePainter(frameColor: luxe.frame),
            ),
            Positioned(
              left: inset,
              top: insetY,
              width: 26,
              height: 26,
              child: CustomPaint(
                painter: LuxePaisleyCornerPainter(color: luxe.frame),
              ),
            ),
            Positioned(
              right: inset,
              top: insetY,
              width: 26,
              height: 26,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.diagonal3Values(-1, 1, 1),
                child: CustomPaint(
                  painter: LuxePaisleyCornerPainter(color: luxe.frame),
                ),
              ),
            ),
            Positioned(
              left: inset,
              bottom: insetY,
              width: 26,
              height: 26,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.diagonal3Values(1, -1, 1),
                child: CustomPaint(
                  painter: LuxePaisleyCornerPainter(color: luxe.frame),
                ),
              ),
            ),
            Positioned(
              right: inset,
              bottom: insetY,
              width: 26,
              height: 26,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.diagonal3Values(-1, -1, 1),
                child: CustomPaint(
                  painter: LuxePaisleyCornerPainter(color: luxe.frame),
                ),
              ),
            ),
            if (layers.isNotEmpty)
              Positioned.fill(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    for (var i = 0; i < layers.length; i++)
                      _FreePhoto(
                        layer: layers[i],
                        displaySize: _photoDisplaySize(
                          w,
                          height,
                          layers[i].imageAspectRatio,
                        ),
                        accent: luxe.accent,
                        compact: compact,
                        interactive:
                            interactivePhotoLayerIndex == i &&
                            onPhotoLayerScaleStart != null &&
                            onPhotoLayerScaleUpdate != null,
                        ghostPassThrough:
                            interactivePhotoLayerIndex != null &&
                            interactivePhotoLayerIndex != i,
                        onScaleStart: onPhotoLayerScaleStart == null
                            ? null
                            : (d) => onPhotoLayerScaleStart!(i, d),
                        onScaleUpdate: onPhotoLayerScaleUpdate == null
                            ? null
                            : (d) => onPhotoLayerScaleUpdate!(i, d),
                      ),
                  ],
                ),
              ),
            Positioned.fill(
              child: IgnorePointer(
                ignoring: interactivePhotoLayerIndex != null,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    compact ? 20 : 22,
                    compact ? 22 : 22,
                    compact ? 20 : 22,
                    compact ? 16 : 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    9,
                                    5,
                                    12,
                                    5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: luxe.frame.withValues(alpha: 0.33),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: luxe.accent,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          pillDisplay,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: _pillStyle(
                                            compact ? 11 : 12.5,
                                            luxe.chipLabel,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                                luxe.frame.withValues(alpha: 0.4),
                                1.2,
                              ),
                            ),
                          ],
                          const SizedBox(width: 10),
                          Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: luxe.frame.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              luxe.cornerEmoji,
                              style: TextStyle(
                                fontSize: compact ? 14 : 16,
                                color: luxe.accent,
                                height: 1,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                if (scrimDec != null)
                                  Positioned.fill(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 10,
                                      ),
                                      child: DecoratedBox(decoration: scrimDec),
                                    ),
                                  ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    LuxeCenterGlyph(
                                      kind: luxe.centerGlyph,
                                      color: luxe.accent,
                                      height: compact ? 28 : 32,
                                    ),
                                    SizedBox(height: compact ? 14 : 18),
                                    Text(
                                      hero,
                                      textAlign: TextAlign.center,
                                      style: _heroStyle(heroPx, type),
                                    ),
                                    SizedBox(height: compact ? 14 : 18),
                                    FractionallySizedBox(
                                      widthFactor: 0.7,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: luxe.frame.withValues(
                                                alpha: 0.4,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: Transform.rotate(
                                              angle: 0.785398,
                                              child: Container(
                                                width: 4,
                                                height: 4,
                                                color: luxe.accent,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: luxe.frame.withValues(
                                                alpha: 0.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: compact ? 12 : 14),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: echoMaxW,
                                      ),
                                      child: Text(
                                        echo,
                                        textAlign: TextAlign.center,
                                        style: _echoStyle(echoPx, type),
                                      ),
                                    ),
                                    SizedBox(height: compact ? 12 : 14),
                                    Text(
                                      author,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.notoSerifTelugu(
                                        fontSize: compact ? 10.5 : 11.5,
                                        fontWeight: FontWeight.w400,
                                        color: luxe.frame.withValues(
                                          alpha: 0.85,
                                        ),
                                        height: 1.35,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _footerDiamond(luxe.accent, compact ? 4 : 5),
                            const SizedBox(width: 10),
                            Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context).footerDailyKatha,
                                  style: GoogleFonts.notoSerifTelugu(
                                    fontSize: compact ? 10 : 11,
                                    letterSpacing: 1,
                                    color: luxe.frame,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  AppLocalizations.of(context).brandTagline,
                                  style: GoogleFonts.notoSerifTelugu(
                                    fontSize: compact ? 8.5 : 9,
                                    color: luxe.frame.withValues(alpha: 0.85),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            _footerDiamond(luxe.accent, compact ? 4 : 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.05,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.38),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
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
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x731F1410),
                blurRadius: 40,
                offset: Offset(0, 18),
                spreadRadius: -18,
              ),
              BoxShadow(
                color: Color(0x2E1F1410),
                blurRadius: 12,
                offset: Offset(0, 4),
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

class _FreePhoto extends StatelessWidget {
  const _FreePhoto({
    required this.layer,
    required this.displaySize,
    required this.accent,
    required this.compact,
    required this.interactive,
    required this.ghostPassThrough,
    this.onScaleStart,
    this.onScaleUpdate,
  });

  final StatusCardPhotoLayer layer;
  final Size displaySize;
  final Color accent;
  final bool compact;
  final bool interactive;

  /// When true, this layer lets gestures reach other layers (inactive slot in editor).
  final bool ghostPassThrough;
  final void Function(ScaleStartDetails details)? onScaleStart;
  final void Function(ScaleUpdateDetails details)? onScaleUpdate;

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

    final image = Opacity(
      opacity: layer.opacity.clamp(0.0, 1.0),
      child: Image.memory(
        key: ValueKey(layer.bytes.hashCode),
        layer.bytes,
        fit: BoxFit.cover,
        width: displaySize.width,
        height: displaySize.height,
        filterQuality: FilterQuality.high,
        gaplessPlayback: true,
        errorBuilder: (ctx, err, st) {
          return Container(
            color: Colors.black.withValues(alpha: 0.18),
            alignment: Alignment.center,
            child: Icon(
              Icons.broken_image_outlined,
              color: accent.withValues(alpha: 0.8),
            ),
          );
        },
      ),
    );

    final framed = Container(
      width: displaySize.width,
      height: displaySize.height,
      decoration: box,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          image,
          if (layer.caption.trim().isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: accent.withValues(alpha: 0.25)),
                ),
                child: Text(
                  layer.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.dmSans(
                    fontSize: compact ? 10 : 11,
                    fontWeight: FontWeight.w600,
                    color: layer.captionColor ?? accent,
                    letterSpacing: 0.3,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    final transformed = Transform.translate(
      offset: layer.offset,
      child: Transform.rotate(
        alignment: Alignment.center,
        angle: layer.rotation,
        child: Transform.scale(
          alignment: Alignment.center,
          scale: layer.scale,
          child: framed,
        ),
      ),
    );

    final centered = Center(child: transformed);

    if (interactive && onScaleStart != null && onScaleUpdate != null) {
      return Positioned.fill(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onScaleStart: onScaleStart,
          onScaleUpdate: onScaleUpdate,
          child: centered,
        ),
      );
    }

    if (ghostPassThrough) {
      return IgnorePointer(ignoring: true, child: centered);
    }

    return centered;
  }
}
