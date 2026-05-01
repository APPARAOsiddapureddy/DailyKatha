import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/status_luxe_palette.dart';

/// Dark forest background + soft grain (HTML reference).
class LuxeCardBackgroundPainter extends CustomPainter {
  LuxeCardBackgroundPainter(this.palette);

  final StatusLuxePalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final clip = RRect.fromRectAndRadius(rect, const Radius.circular(22));
    canvas.save();
    canvas.clipRRect(clip);

    final base = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(size.width * 0.35, size.height),
        [palette.bg0, palette.bg1, palette.bg2],
        const [0, 0.42, 1],
      );
    canvas.drawRect(rect, base);

    final g1 = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width * 0.2, size.height * 0.1),
        size.longestSide * 0.55,
        [palette.radialA, palette.radialA.withValues(alpha: 0)],
        const [0, 1],
      );
    canvas.drawRect(rect, g1);

    final g2 = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width * 0.85, size.height * 0.82),
        size.longestSide * 0.45,
        [palette.radialB, palette.radialB.withValues(alpha: 0)],
        const [0, 1],
      );
    canvas.drawRect(rect, g2);

    final noise = Paint();
    for (var x = 0.0; x < size.width; x += 3) {
      for (var y = 0.0; y < size.height; y += 3) {
        final n = ((x * 12.9898 + y * 78.233).toInt() % 17) / 17.0;
        if (n < 0.35) continue;
        noise.color = Colors.white.withValues(alpha: 0.022 + n * 0.018);
        canvas.drawRect(Rect.fromLTWH(x, y, 1.2, 1.2), noise);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant LuxeCardBackgroundPainter oldDelegate) =>
      oldDelegate.palette != palette;
}

/// Inset gold rim (HTML `.card-border`).
class LuxeInsetBorderPainter extends CustomPainter {
  LuxeInsetBorderPainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(8, 8, size.width - 16, size.height - 16),
      const Radius.circular(16),
    );
    final p = Paint()
      ..color = accent.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(rect, p);
  }

  @override
  bool shouldRepaint(covariant LuxeInsetBorderPainter oldDelegate) => oldDelegate.accent != accent;
}

/// L-bracket + dot corners (HTML SVG).
class LuxeCornerPainter extends CustomPainter {
  LuxeCornerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(2, 2), Offset(size.width * 0.45, 2), p);
    canvas.drawLine(const Offset(2, 2), Offset(2, size.height * 0.45), p);
    canvas.drawCircle(
      const Offset(2, 2),
      2,
      Paint()..color = color.withValues(alpha: 0.45),
    );
    final p2 = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(size.width * 0.2, size.height * 0.2), Offset(size.width * 0.35, size.height * 0.2), p2);
    canvas.drawLine(Offset(size.width * 0.2, size.height * 0.2), Offset(size.width * 0.2, size.height * 0.35), p2);
  }

  @override
  bool shouldRepaint(covariant LuxeCornerPainter oldDelegate) => oldDelegate.color != color;
}

/// Category motif (simplified geometry vs HTML SVG).
class LuxeCategoryIllustrationPainter extends CustomPainter {
  LuxeCategoryIllustrationPainter({required this.category, required this.accent});

  final String category;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    Paint linePaint([double w = 1, double a = 0.35]) => Paint()
      ..color = accent.withValues(alpha: a)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = accent.withValues(alpha: 0.12);

    void cinema() {
      final r = size.height * 0.22;
      for (final cx in [size.width * 0.28, size.width * 0.72]) {
        canvas.drawCircle(Offset(cx, c.dy), r, linePaint(1.1, 0.32));
        canvas.drawCircle(Offset(cx, c.dy), r * 0.65, linePaint(0.85, 0.28));
        for (var i = 0; i < 6; i++) {
          final t = i * math.pi / 3;
          final x1 = cx + r * 0.85 * math.cos(t);
          final y1 = c.dy + r * 0.85 * math.sin(t);
          final x2 = cx + r * 0.45 * math.cos(t);
          final y2 = c.dy + r * 0.45 * math.sin(t);
          canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint(0.9, 0.32));
        }
      }
      final mid = Path()
        ..moveTo(size.width * 0.42, c.dy - r * 0.35)
        ..quadraticBezierTo(c.dx, c.dy - r * 0.55, size.width * 0.58, c.dy - r * 0.35)
        ..lineTo(size.width * 0.58, c.dy + r * 0.35)
        ..quadraticBezierTo(c.dx, c.dy + r * 0.55, size.width * 0.42, c.dy + r * 0.35)
        ..close();
      canvas.drawPath(mid, fill);
    }

    void diya() {
      final w = size.width * 0.35;
      canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + 28), width: w, height: 18), fill);
      final flame = Path()
        ..moveTo(c.dx, c.dy - 32)
        ..quadraticBezierTo(c.dx - 10, c.dy - 8, c.dx, c.dy + 8)
        ..quadraticBezierTo(c.dx + 10, c.dy - 8, c.dx, c.dy - 32)
        ..close();
      canvas.drawPath(flame, Paint()..color = accent.withValues(alpha: 0.5));
      canvas.drawCircle(Offset(c.dx, c.dy - 28), 6, Paint()..color = Colors.white.withValues(alpha: 0.32));
    }

    void heart() {
      final pth = Path()
        ..moveTo(c.dx, c.dy + 22)
        ..cubicTo(c.dx - 48, c.dy - 18, c.dx - 42, c.dy - 42, c.dx, c.dy - 18)
        ..cubicTo(c.dx + 42, c.dy - 42, c.dx + 48, c.dy - 18, c.dx, c.dy + 22)
        ..close();
      canvas.drawPath(pth, fill);
      canvas.drawPath(pth, linePaint(1.15, 0.38));
    }

    void mountain() {
      final pth = Path()
        ..moveTo(0, size.height)
        ..lineTo(size.width * 0.35, c.dy - 20)
        ..lineTo(c.dx, c.dy + 8)
        ..lineTo(size.width * 0.68, c.dy - 32)
        ..lineTo(size.width, size.height)
        ..close();
      canvas.drawPath(pth, fill);
      canvas.drawPath(pth, linePaint(1, 0.3));
    }

    void sun() {
      canvas.drawCircle(c, 28, fill);
      canvas.drawCircle(c, 16, Paint()..color = accent.withValues(alpha: 0.32));
      for (var i = 0; i < 12; i++) {
        final t = i * math.pi / 6;
        canvas.drawLine(
          c + Offset(math.cos(t) * 34, math.sin(t) * 34),
          c + Offset(math.cos(t) * 48, math.sin(t) * 48),
          linePaint(i.isEven ? 1.05 : 0.75, 0.38),
        );
      }
    }

    void book() {
      final r = RRect.fromRectXY(Rect.fromCenter(center: c, width: size.width * 0.55, height: 52), 6, 6);
      canvas.drawRRect(r, fill);
      canvas.drawLine(Offset(c.dx, c.dy - 26), Offset(c.dx, c.dy + 26), linePaint(1, 0.32));
      for (var i = 0; i < 4; i++) {
        final y = c.dy - 14 + i * 9.0;
        canvas.drawLine(Offset(c.dx - 48, y), Offset(c.dx - 8, y), linePaint(0.75, 0.28));
        canvas.drawLine(Offset(c.dx + 8, y), Offset(c.dx + 48, y), linePaint(0.75, 0.28));
      }
    }

    void star() {
      final path = Path();
      for (var i = 0; i < 5; i++) {
        final t = -math.pi / 2 + i * 2 * math.pi / 5;
        final t2 = t + math.pi / 5;
        final ox = c.dx + math.cos(t) * 36;
        final oy = c.dy + math.sin(t) * 36;
        final ix = c.dx + math.cos(t2) * 14;
        final iy = c.dy + math.sin(t2) * 14;
        if (i == 0) {
          path.moveTo(ox, oy);
        } else {
          path.lineTo(ox, oy);
        }
        path.lineTo(ix, iy);
      }
      path.close();
      canvas.drawPath(path, fill);
      canvas.drawPath(path, linePaint(1.05, 0.36));
    }

    switch (category) {
      case 'cinema':
      case 'heroes':
        cinema();
        break;
      case 'bhakti':
      case 'festival':
        diya();
        break;
      case 'love':
      case 'friendship':
        heart();
        break;
      case 'motivation':
        mountain();
        break;
      case 'goodmorning':
      case 'goodnight':
        sun();
        break;
      case 'poetry':
        book();
        break;
      default:
        star();
    }
  }

  @override
  bool shouldRepaint(covariant LuxeCategoryIllustrationPainter oldDelegate) =>
      oldDelegate.category != category || oldDelegate.accent != accent;
}

/// Small star for footer (HTML diamond / sparkle).
class LuxeFooterStarPainter extends CustomPainter {
  LuxeFooterStarPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final path = Path()
      ..moveTo(c.dx, 1)
      ..lineTo(c.dx + 4, c.dy + 2)
      ..lineTo(c.dx, size.height - 1)
      ..lineTo(c.dx - 4, c.dy + 2)
      ..close();
    canvas.drawPath(path, Paint()..color = color.withValues(alpha: 0.45));
  }

  @override
  bool shouldRepaint(covariant LuxeFooterStarPainter oldDelegate) => oldDelegate.color != color;
}
