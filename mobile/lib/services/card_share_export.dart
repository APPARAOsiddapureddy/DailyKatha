import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/katha_card.dart';
import '../widgets/status_card.dart';
import 'share_service.dart';

/// Renders [StatusCard] off-screen, exports PNG (~1080×1920), opens share sheet.
/// WhatsApp / Instagram pick up the image for Status / Story.
class CardShareExport {
  CardShareExport._();

  /// Logical design size (9:16). Pixel width = [logicalExportWidth] * [pixelRatio].
  static const double logicalExportWidth = 360;
  static const double logicalExportHeight = 640;

  static Future<Uint8List> renderKathaCardPngBytes({
    required BuildContext context,
    required KathaCard card,
    required String contentLanguage,
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

    final key = GlobalKey();
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => Positioned.fill(
        child: IgnorePointer(
          child: ColoredBox(
            color: Colors.transparent,
            child: Opacity(
              opacity: 0.02,
              child: Center(
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
                      compact: true,
                      insertedPhotoBytes: insertedPhotoBytes,
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
          ),
        ),
      ),
    );

    overlay.insert(entry);
    try {
      await WidgetsBinding.instance.endOfFrame;
      await Future<void>.delayed(const Duration(milliseconds: 80));

      final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null || !boundary.hasSize) {
        throw StateError('RepaintBoundary not ready');
      }

      const pixelRatio = 1080.0 / logicalExportWidth;
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (byteData == null) throw StateError('PNG encode failed');
      return byteData.buffer.asUint8List();
    } finally {
      entry.remove();
    }
  }

  static Future<String> _writeTempPng(Uint8List bytes, {required String nameStem}) async {
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
    await Share.shareXFiles([XFile(path, mimeType: 'image/png', name: 'Daily_Katha.png')], text: text);
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
        insertedPhotoBytes: insertedPhotoBytes,
        insertedPhotoOffset: insertedPhotoOffset,
        insertedPhotoScale: insertedPhotoScale,
        insertedPhotoRotation: insertedPhotoRotation,
        insertedPhotoOpacity: insertedPhotoOpacity,
        caption: caption,
        captionColor: captionColor,
      );
      await sharePngBytes(bytes: bytes, nameStem: 'daily_katha_share_${card.id}');
    } catch (_) {
      await shareService.shareCardText(
        primaryLine: card.quoteFor(contentLanguage),
        secondaryLine: card.quoteFor('en'),
        attribution: card.authorFor(contentLanguage),
      );
    }
  }
}
