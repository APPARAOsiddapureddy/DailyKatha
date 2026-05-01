import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

/// Text fallback when image export is unavailable (e.g. web).
/// Primary share path: [CardShareExport] → PNG → `Share.shareXFiles`.
@immutable
class ShareService {
  const ShareService();

  Future<void> shareCardText({
    required String primaryLine,
    required String secondaryLine,
    required String attribution,
  }) async {
    final buffer = StringBuffer()
      ..writeln(primaryLine)
      ..writeln()
      ..writeln(secondaryLine)
      ..writeln()
      ..writeln(attribution)
      ..writeln()
      ..writeln('— Daily Katha');
    await Share.share(
      buffer.toString(),
      subject: 'Daily Katha',
    );
  }

  /// Best-effort hint when OS cannot set wallpaper directly from Flutter.
  String wallpaperHint() {
    if (Platform.isIOS) {
      return 'Save the image to Photos, then set as wallpaper from Settings.';
    }
    return 'Save the image to Gallery, then use your launcher’s wallpaper picker.';
  }
}
