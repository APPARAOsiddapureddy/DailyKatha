import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver2_fixed/image_gallery_saver2_fixed.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/katha_card.dart';
import '../models/status_card_photo_layer.dart';
import '../widgets/status_card.dart';
import 'share_service.dart';

/// Renders [StatusCard] off-screen, exports PNG at [logicalExportWidth] × pixelRatio.
/// WhatsApp Status recompresses to JPEG — use high pixel ratio + full (non-compact) layout so
/// text and art survive their pipeline. User photos stay at pick resolution.
class CardShareExport {
  CardShareExport._();

  /// Logical design size (9:16 — same as WhatsApp-style status).
  static const double logicalExportWidth = 360;
  static const double logicalExportHeight = 640;

  /// Width ÷ height of [logicalExportWidth]:[logicalExportHeight] (always 9:16).
  static double get logicalAspectRatio =>
      logicalExportWidth / logicalExportHeight;

  /// Minimum raster scale for PNG export (fallback when [context] has no View).
  static const double exportPixelRatioMin = 4.5;

  /// Upper cap — very large bitmaps can OOM on low-end devices.
  static const double exportPixelRatioMax = 6.0;

  /// Prefer device-aware ratio so exports match sharpness expectations on high-DPI phones.
  static double exportPixelRatioFor(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return (dpr * 2.4).clamp(exportPixelRatioMin, exportPixelRatioMax);
  }

  static Future<Uint8List> renderKathaCardPngBytes({
    required BuildContext context,
    required KathaCard card,
    required String contentLanguage,
    List<StatusCardPhotoLayer>? photoLayers,
    Uint8List? insertedPhotoBytes,
    Offset insertedPhotoOffset = Offset.zero,
    double insertedPhotoScale = 1.0,
    double insertedPhotoRotation = 0.0,
    double insertedPhotoOpacity = 1.0,
    String caption = '',
    Color? captionColor,
  }) async {
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) {
      throw StateError('Overlay not available');
    }

    final pixelRatio = exportPixelRatioFor(context);

    final key = GlobalKey();
    late OverlayEntry entry;
    // Far off-screen, fully opaque: never use near-zero Opacity (it poisons raster quality).
    entry = OverlayEntry(
      builder: (ctx) => Positioned(
        left: -24000,
        top: 0,
        child: IgnorePointer(
          child: RepaintBoundary(
            key: key,
            child: SizedBox(
              width: logicalExportWidth,
              height: logicalExportHeight,
              child: StatusCard(
                card: card,
                contentLanguage: contentLanguage,
                width: logicalExportWidth,
                height: logicalExportHeight,
                // Match on-device preview quality; compact shrinks type for thumbnails only.
                compact: false,
                photoLayers: photoLayers,
                insertedPhotoBytes: photoLayers != null
                    ? null
                    : insertedPhotoBytes,
                insertedPhotoOffset: insertedPhotoOffset,
                insertedPhotoScale: insertedPhotoScale,
                insertedPhotoRotation: insertedPhotoRotation,
                insertedPhotoOpacity: insertedPhotoOpacity,
                caption: caption,
                captionColor: captionColor,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    try {
      await WidgetsBinding.instance.endOfFrame;
      // Let Google Fonts + layout settle before rasterizing (reduces fuzzy fallback text).
      await Future<void>.delayed(const Duration(milliseconds: 120));
      await WidgetsBinding.instance.endOfFrame;

      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null || !boundary.hasSize) {
        throw StateError('RepaintBoundary not ready');
      }

      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (byteData == null) throw StateError('PNG encode failed');
      return byteData.buffer.asUint8List();
    } finally {
      entry.remove();
    }
  }

  static Future<String> _writeTempPng(
    Uint8List bytes, {
    required String nameStem,
  }) async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/$nameStem.png';
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    return path;
  }

  static Future<void> sharePngBytes({
    required Uint8List bytes,
    String text = 'Daily Katha',
    String nameStem = 'daily_katha_share',
  }) async {
    final path = await _writeTempPng(bytes, nameStem: nameStem);
    await Share.shareXFiles([
      XFile(path, mimeType: 'image/png', name: 'Daily_Katha.png'),
    ], text: text);
  }

  /// Saves PNG bytes to the user's gallery/photos. Returns whether the save succeeded.
  static Future<bool> savePngBytesToGallery({
    required Uint8List bytes,
    String nameStem = 'daily_katha',
  }) async {
    if (kIsWeb) return false;
    final result = await ImageGallerySaver.saveImage(
      bytes,
      quality: 100,
      name: nameStem,
    );
    if (result is Map) {
      final ok = result['isSuccess'] == true || result['success'] == true;
      return ok;
    }
    return false;
  }

  static Future<void> shareKathaCardAsImage({
    required BuildContext context,
    required KathaCard card,
    required String contentLanguage,
    required ShareService shareService,
    List<StatusCardPhotoLayer>? photoLayers,
    Uint8List? insertedPhotoBytes,
    Offset insertedPhotoOffset = Offset.zero,
    double insertedPhotoScale = 1.0,
    double insertedPhotoRotation = 0.0,
    double insertedPhotoOpacity = 1.0,
    String caption = '',
    Color? captionColor,
  }) async {
    if (kIsWeb) {
      await shareService.shareCardText(
        primaryLine: card.quoteFor(contentLanguage),
        secondaryLine: card.quoteFor('en'),
        attribution: card.authorFor(contentLanguage),
      );
      return;
    }

    try {
      final bytes = await renderKathaCardPngBytes(
        context: context,
        card: card,
        contentLanguage: contentLanguage,
        photoLayers: photoLayers,
        insertedPhotoBytes: insertedPhotoBytes,
        insertedPhotoOffset: insertedPhotoOffset,
        insertedPhotoScale: insertedPhotoScale,
        insertedPhotoRotation: insertedPhotoRotation,
        insertedPhotoOpacity: insertedPhotoOpacity,
        caption: caption,
        captionColor: captionColor,
      );
      await sharePngBytes(
        bytes: bytes,
        nameStem: 'daily_katha_share_${card.id}',
      );
    } catch (_) {
      await shareService.shareCardText(
        primaryLine: card.quoteFor(contentLanguage),
        secondaryLine: card.quoteFor('en'),
        attribution: card.authorFor(contentLanguage),
      );
    }
  }
}
