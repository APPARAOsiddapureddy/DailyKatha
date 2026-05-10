import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/status_luxe_palette.dart';

/// `CenterGlyph` from `card.jsx` — 80×32 viewBox, centered motif + rules + diamonds.
class LuxeCenterGlyph extends StatelessWidget {
  const LuxeCenterGlyph({
    super.key,
    required this.kind,
    required this.color,
    this.height = 32,
  });

  final LuxeCenterGlyphKind kind;
  final Color color;
  final double height;

  static const double _aspect = 80 / 32;

  @override
  Widget build(BuildContext context) {
    final w = height * _aspect;
    return SizedBox(
      width: w,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: _CenterGlyphPainter(kind: kind, color: color),
          ),
          if (kind == LuxeCenterGlyphKind.om)
            CustomPaint(painter: _OmPainter(color: color)),
        ],
      ),
    );
  }
}

/// Devanagari ॐ overlaid (matches JSX `<text>`).
class _OmPainter extends CustomPainter {
  _OmPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final tp = TextPainter(
      text: TextSpan(
        text: 'ॐ',
        style: TextStyle(
          color: color,
          fontSize: 16 * size.height / 32,
          fontFamily: 'serif',
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(
        size.width / 2 - tp.width / 2,
        size.height / 2 - tp.height / 2 + 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _OmPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _CenterGlyphPainter extends CustomPainter {
  _CenterGlyphPainter({required this.kind, required this.color});

  final LuxeCenterGlyphKind kind;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const viewW = 80.0;
    const viewH = 32.0;
    final sx = size.width / viewW;
    final sy = size.height / viewH;
    canvas.save();
    canvas.scale(sx, sy);

    final strokeLow = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final dotFill = Paint()..color = color;

    canvas.drawLine(const Offset(0, 16), const Offset(26, 16), strokeLow);
    canvas.drawCircle(const Offset(30, 16), 1.2, dotFill);

    canvas.save();
    canvas.translate(40, 16);
    _drawMotif(canvas);
    canvas.restore();

    canvas.drawCircle(const Offset(50, 16), 1.2, dotFill);
    canvas.drawLine(const Offset(54, 16), const Offset(80, 16), strokeLow);

    canvas.restore();
  }

  void _drawMotif(Canvas canvas) {
    final stroke = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = color;

    switch (kind) {
      case LuxeCenterGlyphKind.om:
        return;
      case LuxeCenterGlyphKind.lotus:
        final p = Path()
          ..moveTo(0, -8)
          ..relativeQuadraticBezierTo(-7, 6, -7, 8)
          ..relativeQuadraticBezierTo(3, 1, 7, -2)
          ..relativeQuadraticBezierTo(4, 3, 7, 2)
          ..relativeQuadraticBezierTo(0, -2, -7, -8)
          ..close();
        canvas.drawPath(p, fill);
      case LuxeCenterGlyphKind.sun:
        canvas.drawCircle(Offset.zero, 4, fill);
        for (var i = 0; i < 8; i++) {
          final t = i / 8 * math.pi * 2;
          canvas.drawLine(
            Offset(math.cos(t) * 6, math.sin(t) * 6),
            Offset(math.cos(t) * 9, math.sin(t) * 9),
            stroke,
          );
        }
      case LuxeCenterGlyphKind.heart:
        final p = Path()
          ..moveTo(0, 4)
          ..cubicTo(-4, -5, -10, -3, -10, 2)
          ..cubicTo(-10, 7, 0, 9, 0, 9)
          ..cubicTo(0, 9, 10, 7, 10, 2)
          ..cubicTo(10, -3, 4, -5, 0, 4)
          ..close();
        canvas.drawPath(p, fill);
      case LuxeCenterGlyphKind.peak:
        final p = Path()
          ..moveTo(-9, 5)
          ..lineTo(-3, -5)
          ..lineTo(1, 1)
          ..lineTo(5, -7)
          ..lineTo(10, 5)
          ..close();
        canvas.drawPath(p, fill);
      case LuxeCenterGlyphKind.diya:
        canvas.drawOval(
          Rect.fromCenter(center: const Offset(0, 2), width: 16, height: 4),
          fill,
        );
        final flame = Path()
          ..moveTo(-2, 0)
          ..relativeQuadraticBezierTo(2, -6, 4, 0)
          ..close();
        canvas.drawPath(flame, fill);
      case LuxeCenterGlyphKind.home:
        canvas.drawPath(
          Path()
            ..moveTo(-7, 5)
            ..lineTo(0, -5)
            ..lineTo(7, 5)
            ..moveTo(-5, 5)
            ..lineTo(-5, 8)
            ..lineTo(5, 8)
            ..lineTo(5, 5),
          stroke,
        );
      case LuxeCenterGlyphKind.reel:
        canvas.drawCircle(Offset.zero, 6, stroke);
        canvas.drawCircle(Offset.zero, 1.5, fill);
      case LuxeCenterGlyphKind.sword:
        canvas.drawLine(const Offset(0, -7), const Offset(0, 7), stroke);
        canvas.drawLine(const Offset(-3, -3), const Offset(3, -3), stroke);
      case LuxeCenterGlyphKind.quill:
        final p = Path()
          ..moveTo(-7, 5)
          ..quadraticBezierTo(0, -3, 7, -5)
          ..lineTo(5, -2)
          ..quadraticBezierTo(-2, 0, -5, 6)
          ..close();
        canvas.drawPath(p, fill);
      case LuxeCenterGlyphKind.leaf:
        final p = Path()
          ..moveTo(-7, 0)
          ..quadraticBezierTo(0, -7, 7, 0)
          ..quadraticBezierTo(0, 7, -7, 0)
          ..close();
        canvas.drawPath(p, fill);
      case LuxeCenterGlyphKind.candle:
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: 2, height: 10),
          fill,
        );
        final flame = Path()
          ..moveTo(0, -10)
          ..relativeQuadraticBezierTo(-2, 3, 0, 4)
          ..relativeQuadraticBezierTo(2, -2, 0, -4)
          ..close();
        canvas.drawPath(flame, fill);
    }
  }

  @override
  bool shouldRepaint(covariant _CenterGlyphPainter oldDelegate) =>
      oldDelegate.kind != kind || oldDelegate.color != color;
}
