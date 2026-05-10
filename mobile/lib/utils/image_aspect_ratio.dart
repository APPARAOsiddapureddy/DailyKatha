import 'dart:typed_data';
import 'dart:ui' as ui;

/// Returns decoded bitmap width ÷ height (clamped). Defaults to 1 on failure.
Future<double> decodeImageAspectRatio(Uint8List bytes) async {
  try {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final w = frame.image.width;
    final h = frame.image.height;
    frame.image.dispose();
    if (h <= 0 || w <= 0) return 1.0;
    return (w / h).clamp(0.18, 6.0);
  } catch (_) {
    return 1.0;
  }
}
