import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Double dashed rounded frames from `card.jsx` (viewBox 360×560, outer + inner rects).
class LuxeDashedFramePainter extends CustomPainter {
  LuxeDashedFramePainter({required this.frameColor});

  final Color frameColor;

  static const double _vbW = 360;
  static const double _vbH = 560;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / _vbW;
    final sy = size.height / _vbH;
    final r = math.min(sx, sy);
    final outer = RRect.fromRectAndRadius(
      Rect.fromLTWH(10 * sx, 10 * sy, 340 * sx, 560 * sy),
      Radius.circular(18 * r),
    );
    final inner = RRect.fromRectAndRadius(
      Rect.fromLTWH(18 * sx, 18 * sy, 324 * sx, 544 * sy),
      Radius.circular(14 * r),
    );
    _paintDashedRRect(
      canvas,
      outer,
      Paint()
        ..color = frameColor.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
      3 * r,
      4 * r,
    );
    _paintDashedRRect(
      canvas,
      inner,
      Paint()
        ..color = frameColor.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
      3 * r,
      4 * r,
    );
  }

  void _paintDashedRRect(
    Canvas canvas,
    RRect rr,
    Paint paint,
    double dash,
    double gap,
  ) {
    final path = Path()..addRRect(rr);
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      var draw = true;
      while (d < metric.length) {
        final len = draw ? dash : gap;
        final next = (d + len).clamp(0.0, metric.length);
        if (draw) {
          canvas.drawPath(metric.extractPath(d, next), paint);
        }
        d = next;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant LuxeDashedFramePainter oldDelegate) =>
      oldDelegate.frameColor != frameColor;
}

/// `PaisleyCorner` from `card.jsx` — 26×26 local coords, stroke art + dot.
class LuxePaisleyCornerPainter extends CustomPainter {
  LuxePaisleyCornerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    final pSoft = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(0, 14)
        ..lineTo(0, 0)
        ..lineTo(14, 0),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(2, 18)
        ..quadraticBezierTo(8, 8, 18, 2),
      pSoft,
    );
    canvas.drawCircle(const Offset(3, 3), 1.2, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant LuxePaisleyCornerPainter oldDelegate) =>
      oldDelegate.color != color;
}
