import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Full-bleed illustrated backgrounds — ported from `themes.jsx` (`Bg` components).
class LuxeThemeBackgroundPainter extends CustomPainter {
  LuxeThemeBackgroundPainter(this.category);

  final String category;

  static String _themeId(String raw) {
    switch (raw) {
      case 'calm':
        return 'goodnight';
      default:
        return raw;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final id = _themeId(category);
    final sx = size.width / 360;
    final sy = size.height / 560;
    final rect = Offset.zero & size;
    final clip = RRect.fromRectAndRadius(rect, const Radius.circular(24));
    canvas.save();
    canvas.clipRRect(clip);

    if (id == 'goodmorning') {
      _goodMorning(canvas, sx, sy);
    } else if (id == 'goodnight') {
      _goodNight(canvas, sx, sy);
    } else if (id == 'love') {
      _love(canvas, sx, sy);
    } else if (id == 'bhakti') {
      _bhakti(canvas, sx, sy);
    } else if (id == 'motivation') {
      _motivation(canvas, sx, sy);
    } else if (id == 'festival') {
      _festival(canvas, sx, sy);
    } else if (id == 'family') {
      _family(canvas, sx, sy);
    } else if (id == 'cinema') {
      _cinema(canvas, sx, sy);
    } else if (id == 'heroes') {
      _heroes(canvas, sx, sy);
    } else if (id == 'poetry') {
      _poetry(canvas, sx, sy);
    } else if (id == 'friendship') {
      _friendship(canvas, sx, sy);
    } else if (id == 'birthday') {
      _birthday(canvas, sx, sy);
    } else {
      _cinema(canvas, sx, sy);
    }
    canvas.restore();
  }

  void _goodMorning(Canvas canvas, double sx, double sy) {
    final rect = Rect.fromLTWH(0, 0, 360 * sx, 560 * sy);
    final g = Paint()
      ..shader = ui.Gradient.linear(
        rect.topLeft,
        rect.bottomLeft,
        const [
          Color(0xFFF8D27A),
          Color(0xFFF2A03F),
          Color(0xFFC75618),
          Color(0xFF5A1E08),
        ],
        const [0, 0.45, 0.75, 1],
      );
    canvas.drawRect(rect, g);
    final sunGlow = Paint()
      ..shader = ui.Gradient.radial(
        Offset(180 * sx, 350 * sy),
        160 * math.min(sx, sy),
        [
          const Color(0xF2FFF1B8),
          const Color(0x66FFD06B),
          const Color(0x00FFD06B),
        ],
        const [0, 0.6, 1],
      );
    canvas.drawCircle(
      Offset(180 * sx, 350 * sy),
      160 * math.min(sx, sy),
      sunGlow,
    );
    canvas.drawCircle(
      Offset(180 * sx, 350 * sy),
      42 * math.min(sx, sy),
      Paint()..color = const Color(0xF2FFE9A3),
    );
    for (var i = 0; i < 14; i++) {
      final y = 300 + i * 8;
      canvas.drawRect(
        Rect.fromLTWH(0, y * sy, 360 * sx, 1),
        Paint()
          ..color = const Color(0xFFffe9a3).withValues(alpha: 0.06 + i * 0.005),
      );
    }
    final h1 = Path()
      ..moveTo(0, 430 * sy)
      ..quadraticBezierTo(80 * sx, 380 * sy, 160 * sx, 410 * sy)
      ..quadraticBezierTo(240 * sx, 440 * sy, 360 * sx, 405 * sy)
      ..lineTo(360 * sx, 560 * sy)
      ..lineTo(0, 560 * sy)
      ..close();
    canvas.drawPath(h1, Paint()..color = const Color(0x8C3A1408));
    final h2 = Path()
      ..moveTo(0, 470 * sy)
      ..quadraticBezierTo(100 * sx, 430 * sy, 200 * sx, 450 * sy)
      ..quadraticBezierTo(300 * sx, 470 * sy, 360 * sx, 460 * sy)
      ..lineTo(360 * sx, 560 * sy)
      ..lineTo(0, 560 * sy)
      ..close();
    canvas.drawPath(h2, Paint()..color = const Color(0xBF2A0C04));
    final bird = Paint()
      ..color = const Color(0xFF1F0A02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6 * math.min(sx, sy)
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(70 * sx, 180 * sy)
        ..relativeQuadraticBezierTo(8 * sx, -6 * sy, 16 * sx, 0)
        ..relativeQuadraticBezierTo(8 * sx, -6 * sy, 16 * sx, 0),
      bird,
    );
    canvas.drawPath(
      Path()
        ..moveTo(110 * sx, 200 * sy)
        ..relativeQuadraticBezierTo(6 * sx, -4 * sy, 12 * sx, 0)
        ..relativeQuadraticBezierTo(6 * sx, -4 * sy, 12 * sx, 0),
      Paint()
        ..color = const Color(0xFF1F0A02)
        ..strokeWidth = 1.4 * math.min(sx, sy)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      Path()
        ..moveTo(250 * sx, 170 * sy)
        ..relativeQuadraticBezierTo(7 * sx, -5 * sy, 14 * sx, 0)
        ..relativeQuadraticBezierTo(7 * sx, -5 * sy, 14 * sx, 0),
      Paint()
        ..color = const Color(0xFF1F0A02)
        ..strokeWidth = 1.5 * math.min(sx, sy)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  void _goodNight(Canvas canvas, double sx, double sy) {
    final rect = Rect.fromLTWH(0, 0, 360 * sx, 560 * sy);
    final sky = Paint()
      ..shader = ui.Gradient.linear(
        rect.topLeft,
        rect.bottomLeft,
        const [Color(0xFF1B1248), Color(0xFF2E1B62), Color(0xFF5A2C7A)],
        const [0, 0.5, 1],
      );
    canvas.drawRect(rect, sky);
    final glow = Paint()
      ..shader = ui.Gradient.radial(
        Offset(360 * 0.82 * sx, 560 * 0.15 * sy),
        140 * math.min(sx, sy),
        [const Color(0x8CE5C8FF), Colors.transparent],
        const [0, 1],
      );
    canvas.drawRect(rect, glow);
    final stars = [
      [40.0, 90],
      [80, 140],
      [140, 70],
      [220, 110],
      [300, 80],
      [260, 180],
      [320, 200],
      [60, 200],
      [180, 40],
    ];
    for (var i = 0; i < stars.length; i++) {
      final r = i.isEven ? 1.5 : 1.0;
      canvas.drawCircle(
        Offset(stars[i][0] * sx, stars[i][1] * sy),
        r * math.min(sx, sy),
        Paint()..color = Colors.white.withValues(alpha: 0.75),
      );
    }
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(60 * sx, 320 * sy),
        width: 240 * sx,
        height: 44 * sy,
      ),
      Paint()..color = const Color(0x597A4FB0),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(300 * sx, 310 * sy),
        width: 220 * sx,
        height: 40 * sy,
      ),
      Paint()..color = const Color(0x597A4FB0),
    );
    final mt = Path()
      ..moveTo(0, 430 * sy)
      ..lineTo(80 * sx, 360 * sy)
      ..lineTo(150 * sx, 420 * sy)
      ..lineTo(230 * sx, 350 * sy)
      ..lineTo(310 * sx, 420 * sy)
      ..lineTo(360 * sx, 390 * sy)
      ..lineTo(360 * sx, 560 * sy)
      ..lineTo(0, 560 * sy)
      ..close();
    canvas.drawPath(mt, Paint()..color = const Color(0xE615093A));
    canvas.drawRect(
      Rect.fromLTWH(0, 475 * sy, 360 * sx, 85 * sy),
      Paint()..color = const Color(0xFF0B0626),
    );
    final ripple = Paint()
      ..color = const Color(0x80B89BFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(
      Path()
        ..moveTo(120 * sx, 490 * sy)
        ..quadraticBezierTo(180 * sx, 520 * sy, 240 * sx, 490 * sy),
      ripple,
    );
    canvas.drawPath(
      Path()
        ..moveTo(90 * sx, 510 * sy)
        ..quadraticBezierTo(180 * sx, 540 * sy, 270 * sx, 510 * sy),
      Paint()
        ..color = const Color(0x66B89BFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  void _love(Canvas canvas, double sx, double sy) {
    final rect = Rect.fromLTWH(0, 0, 360 * sx, 560 * sy);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.linear(
          rect.topLeft,
          rect.bottomLeft,
          const [Color(0xFFFFD0CB), Color(0xFFE07B8F), Color(0xFF5C0E2A)],
          const [0, 0.4, 1],
        ),
    );
    const petals = <List<double>>[
      [40, 80, 12, 18],
      [110, 140, 8, 20],
      [260, 90, 14, 16],
      [300, 200, 10, 30],
      [80, 260, 9, 15],
      [200, 40, 11, 25],
      [160, 180, 7, 12],
      [330, 300, 12, 18],
    ];
    for (final p in petals) {
      final x = p[0] * sx;
      final y = p[1] * sy;
      final r = p[2] * math.min(sx, sy);
      final path = Path()
        ..moveTo(x, y)
        ..relativeQuadraticBezierTo(r, -r / 1.5, r * 2, 0)
        ..relativeQuadraticBezierTo(-r, r * 1.4, -r * 2, 0)
        ..close();
      canvas.drawPath(path, Paint()..color = const Color(0x8CFFB8C9));
    }
    canvas.drawPath(
      Path()
        ..moveTo(40 * sx, 560 * sy)
        ..lineTo(40 * sx, 400 * sy)
        ..quadraticBezierTo(180 * sx, 280 * sy, 320 * sx, 400 * sy)
        ..lineTo(320 * sx, 560 * sy)
        ..close(),
      Paint()
        ..color = const Color(0x403A0820)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      Path()
        ..moveTo(40 * sx, 560 * sy)
        ..lineTo(40 * sx, 400 * sy)
        ..quadraticBezierTo(180 * sx, 280 * sy, 320 * sx, 400 * sy)
        ..lineTo(320 * sx, 560 * sy)
        ..close(),
      Paint()
        ..color = const Color(0x668E1B3E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.6,
    );
    canvas.drawCircle(
      Offset(180 * sx, 500 * sy),
      120 * math.min(sx, sy),
      Paint()..color = const Color(0x26FFCDD7),
    );
    final heart = Path()
      ..moveTo(180 * sx, 470 * sy)
      ..relativeCubicTo(
        -12 * sx,
        -16 * sy,
        -38 * sx,
        -10 * sy,
        -38 * sx,
        12 * sy,
      )
      ..relativeCubicTo(0, 22 * sy, 38 * sx, 40 * sy, 38 * sx, 40 * sy)
      ..relativeCubicTo(0, 0, 38 * sx, -18 * sy, 38 * sx, -40 * sy)
      ..relativeCubicTo(0, -22 * sy, -26 * sx, -28 * sy, -38 * sx, -12 * sy)
      ..close();
    canvas.drawPath(heart, Paint()..color = const Color(0x595C0E2A));
    canvas.drawPath(
      heart,
      Paint()
        ..color = const Color(0xB3FFCDD7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.7,
    );
  }

  void _bhakti(Canvas canvas, double sx, double sy) {
    final rect = Rect.fromLTWH(0, 0, 360 * sx, 560 * sy);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.linear(
          rect.topLeft,
          rect.bottomLeft,
          const [Color(0xFFF4C45A), Color(0xFFC8541A), Color(0xFF3A0A06)],
          const [0, 0.4, 1],
        ),
    );
    for (var i = 0; i < 18; i++) {
      final t = i / 18 * math.pi * 2;
      canvas.drawLine(
        Offset(180 * sx, 350 * sy),
        Offset(
          180 * sx + math.cos(t) * 400 * sx,
          350 * sy + math.sin(t) * 400 * sy,
        ),
        Paint()
          ..color = const Color(0x2EFFE3A8)
          ..strokeWidth = 1,
      );
    }
    final templeRoof = Path()
      ..moveTo(120 * sx, 460 * sy)
      ..lineTo(120 * sx, 380 * sy)
      ..lineTo(140 * sx, 380 * sy)
      ..lineTo(140 * sx, 360 * sy)
      ..lineTo(160 * sx, 360 * sy)
      ..lineTo(160 * sx, 340 * sy)
      ..lineTo(170 * sx, 320 * sy)
      ..lineTo(180 * sx, 305 * sy)
      ..lineTo(190 * sx, 320 * sy)
      ..lineTo(200 * sx, 340 * sy)
      ..lineTo(200 * sx, 360 * sy)
      ..lineTo(220 * sx, 360 * sy)
      ..lineTo(220 * sx, 380 * sy)
      ..lineTo(240 * sx, 380 * sy)
      ..lineTo(240 * sx, 460 * sy)
      ..close();
    canvas.drawPath(templeRoof, Paint()..color = const Color(0xD91A0604));
    canvas.drawRect(
      Rect.fromLTWH(100 * sx, 460 * sy, 160 * sx, 100 * sy),
      Paint()..color = const Color(0xD91A0604),
    );
    final flame = Paint()
      ..shader = ui.Gradient.radial(
        Offset(180 * sx, 520 * sy),
        40 * math.min(sx, sy),
        [const Color(0xE6FFF1A8), const Color(0xB3FFB23A), Colors.transparent],
        const [0, 0.5, 1],
      );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(180 * sx, 520 * sy),
        width: 80 * sx,
        height: 40 * sy,
      ),
      flame,
    );
    canvas.drawPath(
      Path()
        ..moveTo(170 * sx, 510 * sy)
        ..relativeQuadraticBezierTo(10 * sx, -18 * sy, 20 * sx, 0)
        ..close(),
      Paint()..color = const Color(0xFFFFD061),
    );
  }

  void _motivation(Canvas canvas, double sx, double sy) {
    final rect = Rect.fromLTWH(0, 0, 360 * sx, 560 * sy);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.linear(
          rect.topLeft,
          rect.bottomLeft,
          const [Color(0xFF0F4A52), Color(0xFF1F8AA0), Color(0xFFF2C76E)],
          const [0, 0.5, 1],
        ),
    );
    canvas.drawCircle(
      Offset(180 * sx, 430 * sy),
      52 * math.min(sx, sy),
      Paint()..color = const Color(0xE6FFE1A0),
    );
    canvas.drawCircle(
      Offset(180 * sx, 430 * sy),
      80 * math.min(sx, sy),
      Paint()..color = const Color(0x40FFE1A0),
    );
    final m = Path()
      ..moveTo(0, 460 * sy)
      ..lineTo(80 * sx, 340 * sy)
      ..lineTo(140 * sx, 410 * sy)
      ..lineTo(210 * sx, 280 * sy)
      ..lineTo(290 * sx, 400 * sy)
      ..lineTo(360 * sx, 350 * sy)
      ..lineTo(360 * sx, 560 * sy)
      ..lineTo(0, 560 * sy)
      ..close();
    canvas.drawPath(m, Paint()..color = const Color(0xFF062931));
    final m2 = Path()
      ..moveTo(0, 500 * sy)
      ..lineTo(60 * sx, 440 * sy)
      ..lineTo(130 * sx, 480 * sy)
      ..lineTo(200 * sx, 420 * sy)
      ..lineTo(280 * sx, 470 * sy)
      ..lineTo(360 * sx, 440 * sy)
      ..lineTo(360 * sx, 560 * sy)
      ..lineTo(0, 560 * sy)
      ..close();
    canvas.drawPath(m2, Paint()..color = const Color(0xF2031518));
    final bird = Paint()
      ..color = const Color(0xFFFFE9A3)
      ..strokeWidth = 1.6 * math.min(sx, sy)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(260 * sx, 200 * sy)
        ..relativeQuadraticBezierTo(6 * sx, -6 * sy, 12 * sx, 0)
        ..relativeQuadraticBezierTo(6 * sx, -6 * sy, 12 * sx, 0),
      bird,
    );
    canvas.drawPath(
      Path()
        ..moveTo(280 * sx, 240 * sy)
        ..relativeQuadraticBezierTo(5 * sx, -4 * sy, 10 * sx, 0)
        ..relativeQuadraticBezierTo(5 * sx, -4 * sy, 10 * sx, 0),
      Paint()
        ..color = const Color(0xFFFFE9A3)
        ..strokeWidth = 1.4 * math.min(sx, sy)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  void _festival(Canvas canvas, double sx, double sy) {
    final rect = Rect.fromLTWH(0, 0, 360 * sx, 560 * sy);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.linear(
          rect.topLeft,
          rect.bottomLeft,
          const [Color(0xFF7A1410), Color(0xFFB94E11), Color(0xFFE8761E)],
          const [0, 0.5, 1],
        ),
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, 50 * sy)
        ..quadraticBezierTo(20 * sx, 30 * sy, 40 * sx, 50 * sy)
        ..quadraticBezierTo(60 * sx, 30 * sy, 80 * sx, 50 * sy)
        ..quadraticBezierTo(100 * sx, 30 * sy, 120 * sx, 50 * sy)
        ..quadraticBezierTo(140 * sx, 30 * sy, 160 * sx, 50 * sy)
        ..quadraticBezierTo(180 * sx, 30 * sy, 200 * sx, 50 * sy)
        ..quadraticBezierTo(220 * sx, 30 * sy, 240 * sx, 50 * sy)
        ..quadraticBezierTo(260 * sx, 30 * sy, 280 * sx, 50 * sy)
        ..quadraticBezierTo(300 * sx, 30 * sy, 320 * sx, 50 * sy)
        ..quadraticBezierTo(340 * sx, 30 * sy, 360 * sx, 50 * sy),
      Paint()
        ..color = const Color(0xFFF5D06B)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke,
    );
    for (var i = 0; i < 18; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset((i * 20 + 10) * sx, 60 * sy),
          width: 12 * sx,
          height: 28 * sy,
        ),
        Paint()..color = const Color(0xE60F6E5E),
      );
    }
    const cx = 180.0;
    const cy = 350.0;
    for (var i = 0; i < 12; i++) {
      final t = i / 12 * math.pi * 2;
      canvas.drawCircle(
        Offset((cx + math.cos(t) * 80) * sx, (cy + math.sin(t) * 80) * sy),
        14 * math.min(sx, sy),
        Paint()..color = const Color(0xE6F4A547),
      );
    }
    for (var i = 0; i < 12; i++) {
      final t = i / 12 * math.pi * 2;
      canvas.drawCircle(
        Offset((cx + math.cos(t) * 55) * sx, (cy + math.sin(t) * 55) * sy),
        10 * math.min(sx, sy),
        Paint()..color = const Color(0xFFE8761E),
      );
    }
    canvas.drawCircle(
      Offset(cx * sx, cy * sy),
      30 * math.min(sx, sy),
      Paint()..color = const Color(0xFFF5D06B),
    );
    canvas.drawCircle(
      Offset(cx * sx, cy * sy),
      14 * math.min(sx, sy),
      Paint()..color = const Color(0xFF7A1410),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(60 * sx, 510 * sy),
        width: 44 * sx,
        height: 12 * sy,
      ),
      Paint()..color = const Color(0xFF1A0604),
    );
    canvas.drawPath(
      Path()
        ..moveTo(50 * sx, 500 * sy)
        ..relativeQuadraticBezierTo(10 * sx, -18 * sy, 20 * sx, 0)
        ..close(),
      Paint()..color = const Color(0xFFFFD061),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(300 * sx, 510 * sy),
        width: 44 * sx,
        height: 12 * sy,
      ),
      Paint()..color = const Color(0xFF1A0604),
    );
    canvas.drawPath(
      Path()
        ..moveTo(290 * sx, 500 * sy)
        ..relativeQuadraticBezierTo(10 * sx, -18 * sy, 20 * sx, 0)
        ..close(),
      Paint()..color = const Color(0xFFFFD061),
    );
  }

  void _family(Canvas canvas, double sx, double sy) {
    final rect = Rect.fromLTWH(0, 0, 360 * sx, 560 * sy);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.linear(
          rect.topLeft,
          rect.bottomLeft,
          const [Color(0xFFF5E1B8), Color(0xFFE8AE7A), Color(0xFF7A3A1A)],
          const [0, 0.5, 1],
        ),
    );
    canvas.drawCircle(
      Offset(180 * sx, 200 * sy),
      140 * math.min(sx, sy),
      Paint()..color = const Color(0x59FFE9A3),
    );
    for (var r = 0; r < 5; r++) {
      for (var c = 0; c < 7; c++) {
        canvas.drawCircle(
          Offset((70 + c * 40) * sx, (420 + r * 22) * sy),
          1.4 * math.min(sx, sy),
          Paint()..color = const Color(0x593A1408),
        );
      }
    }
    canvas.save();
    canvas.translate(120 * sx, 320 * sy);
    canvas.drawPath(
      Path()
        ..moveTo(0, 80 * sy)
        ..lineTo(60 * sx, 20 * sy)
        ..lineTo(120 * sx, 80 * sy)
        ..close(),
      Paint()..color = const Color(0xFF3A1408),
    );
    canvas.drawRect(
      Rect.fromLTWH(10 * sx, 80 * sy, 100 * sx, 80 * sy),
      Paint()..color = const Color(0xFF3A1408),
    );
    canvas.drawRect(
      Rect.fromLTWH(48 * sx, 110 * sy, 24 * sx, 50 * sy),
      Paint()..color = const Color(0xFFF5D06B),
    );
    canvas.drawCircle(
      Offset(60 * sx, 30 * sy),
      3 * math.min(sx, sy),
      Paint()..color = const Color(0xFFF5D06B),
    );
    canvas.restore();
    canvas.drawRect(
      Rect.fromLTWH(42 * sx, 380 * sy, 6 * sx, 60 * sy),
      Paint()..color = const Color(0xFF3A1408),
    );
    canvas.drawCircle(
      Offset(45 * sx, 376 * sy),
      22 * math.min(sx, sy),
      Paint()..color = const Color(0xD90F6E5E),
    );
    canvas.drawRect(
      Rect.fromLTWH(312 * sx, 380 * sy, 6 * sx, 60 * sy),
      Paint()..color = const Color(0xFF3A1408),
    );
    canvas.drawCircle(
      Offset(315 * sx, 376 * sy),
      22 * math.min(sx, sy),
      Paint()..color = const Color(0xD90F6E5E),
    );
  }

  void _cinema(Canvas canvas, double sx, double sy) {
    final rect = Rect.fromLTWH(0, 0, 360 * sx, 560 * sy);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.linear(
          rect.topLeft,
          rect.bottomRight,
          const [Color(0xFF0D0905), Color(0xFF3A2A0E), Color(0xFF0D0905)],
          const [0, 0.5, 1],
        ),
    );
    final spot = Paint()
      ..shader = ui.Gradient.radial(
        Offset(180 * sx, 320 * sy),
        220 * math.min(sx, sy),
        [const Color(0x59F5D06B), Colors.transparent],
        const [0, 1],
      );
    canvas.drawRect(rect, spot);
    for (final y in [440.0, 490.0]) {
      canvas.drawRect(
        Rect.fromLTWH(0, y * sy, 360 * sx, 40 * sy),
        Paint()..color = const Color(0xFF1A0F04),
      );
      for (var i = 0; i < 12; i++) {
        canvas.drawRect(
          Rect.fromLTWH((i * 30 + 6) * sx, (y + 10) * sy, 18 * sx, 20 * sy),
          Paint()..color = const Color(0x40F5D06B),
        );
      }
    }
    canvas.save();
    canvas.translate(180 * sx, 330 * sy);
    canvas.drawCircle(
      Offset.zero,
      60 * math.min(sx, sy),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0x80D4A12A),
    );
    canvas.drawCircle(
      Offset.zero,
      48 * math.min(sx, sy),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0x80D4A12A),
    );
    canvas.drawCircle(
      Offset.zero,
      8 * math.min(sx, sy),
      Paint()..color = const Color(0xFFD4A12A),
    );
    for (var i = 0; i < 6; i++) {
      final t = i / 6 * math.pi * 2;
      canvas.drawCircle(
        Offset(math.cos(t) * 36 * sx, math.sin(t) * 36 * sy),
        9 * math.min(sx, sy),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = const Color(0xFFD4A12A),
      );
    }
    canvas.restore();
  }

  void _heroes(Canvas canvas, double sx, double sy) {
    final rect = Rect.fromLTWH(0, 0, 360 * sx, 560 * sy);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.linear(
          rect.topLeft,
          rect.bottomLeft,
          const [Color(0xFF3A0606), Color(0xFF7A1410), Color(0xFFE8761E)],
          const [0, 0.5, 1],
        ),
    );
    for (var i = 0; i < 14; i++) {
      final path = Path()
        ..moveTo(180 * sx, 420 * sy)
        ..lineTo((180 - 180 + i * 30) * sx, 0)
        ..lineTo((180 - 160 + i * 30) * sx, 0)
        ..close();
      canvas.drawPath(path, Paint()..color = const Color(0x1AF4A547));
    }
    canvas.drawRect(
      Rect.fromLTWH(0, 420 * sy, 360 * sx, 140 * sy),
      Paint()..color = const Color(0xFF1A0604),
    );
    canvas.save();
    canvas.translate(180 * sx, 380 * sy);
    canvas.drawPath(
      Path()
        ..moveTo(-50 * sx, 40 * sy)
        ..quadraticBezierTo(-50 * sx, -10 * sy, -30 * sx, -40 * sy)
        ..quadraticBezierTo(0, -70 * sy, 30 * sx, -40 * sy)
        ..quadraticBezierTo(50 * sx, -10 * sy, 50 * sx, 40 * sy)
        ..close(),
      Paint()..color = const Color(0xFF0A0202),
    );
    canvas.drawCircle(
      Offset(0, -50 * sy),
      14 * math.min(sx, sy),
      Paint()..color = const Color(0xFF0A0202),
    );
    canvas.drawPath(
      Path()
        ..moveTo(-60 * sx, 40 * sy)
        ..lineTo(60 * sx, 40 * sy)
        ..lineTo(80 * sx, 80 * sy)
        ..lineTo(-80 * sx, 80 * sy)
        ..close(),
      Paint()..color = const Color(0xE60A0202),
    );
    canvas.restore();
    canvas.drawLine(
      Offset(180 * sx, 50 * sy),
      Offset(180 * sx, 120 * sy),
      Paint()
        ..color = const Color(0xB3F5D06B)
        ..strokeWidth = 2,
    );
    canvas.drawLine(
      Offset(160 * sx, 58 * sy),
      Offset(200 * sx, 58 * sy),
      Paint()
        ..color = const Color(0xB3F5D06B)
        ..strokeWidth = 2,
    );
  }

  void _poetry(Canvas canvas, double sx, double sy) {
    final rect = Rect.fromLTWH(0, 0, 360 * sx, 560 * sy);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.linear(
          rect.topLeft,
          rect.bottomRight,
          const [Color(0xFFE8DDB8), Color(0xFF9BB39A), Color(0xFF2E4A3F)],
          const [0, 0.5, 1],
        ),
    );
    for (var i = 0; i < 60; i++) {
      final a = (i * 47.11) % 1.0;
      final b = (i * 91.17) % 1.0;
      canvas.drawCircle(
        Offset(a * 360 * sx, b * 560 * sy),
        0.6 * math.min(sx, sy),
        Paint()..color = const Color(0x382E4A3F),
      );
    }
    for (var i = 0; i < 3; i++) {
      final y = [460.0, 490, 520][i];
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(180 * sx, y * sy),
          width: (280 - i * 60) * sx,
          height: (12 - i * 2) * sy,
        ),
        Paint()
          ..color = const Color(0x802E4A3F)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );
    }
    canvas.save();
    canvas.translate(80 * sx, 480 * sy);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 44 * sx, height: 8 * sy),
      Paint()..color = const Color(0x802E4A3F),
    );
    canvas.drawPath(
      Path()
        ..moveTo(-12 * sx, -2 * sy)
        ..relativeQuadraticBezierTo(12 * sx, -16 * sy, 24 * sx, 0)
        ..close(),
      Paint()..color = const Color(0xFFFBE4DA),
    );
    canvas.drawPath(
      Path()
        ..moveTo(-16 * sx, -1 * sy)
        ..relativeQuadraticBezierTo(16 * sx, -10 * sy, 32 * sx, 0),
      Paint()..color = const Color(0xB3E8AE7A),
    );
    canvas.restore();
    canvas.save();
    canvas.translate(280 * sx, 510 * sy);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 40 * sx, height: 8 * sy),
      Paint()..color = const Color(0x802E4A3F),
    );
    canvas.drawPath(
      Path()
        ..moveTo(-10 * sx, -2 * sy)
        ..relativeQuadraticBezierTo(10 * sx, -14 * sy, 20 * sx, 0)
        ..close(),
      Paint()..color = const Color(0xFFFBE4DA),
    );
    canvas.restore();
    canvas.drawPath(
      Path()
        ..moveTo(40 * sx, 90 * sy)
        ..quadraticBezierTo(80 * sx, 60 * sy, 130 * sx, 50 * sy)
        ..lineTo(130 * sx, 56 * sy)
        ..quadraticBezierTo(80 * sx, 70 * sy, 50 * sx, 110 * sy)
        ..close(),
      Paint()..color = const Color(0xA62E4A3F),
    );
  }

  void _friendship(Canvas canvas, double sx, double sy) {
    final rect = Rect.fromLTWH(0, 0, 360 * sx, 560 * sy);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.linear(
          rect.topLeft,
          rect.bottomLeft,
          const [Color(0xFFF2C76E), Color(0xFFE8761E), Color(0xFF0F6E5E)],
          const [0, 0.5, 1],
        ),
    );
    canvas.drawCircle(
      Offset(180 * sx, 280 * sy),
      60 * math.min(sx, sy),
      Paint()..color = const Color(0xB3FFE9A3),
    );
    for (final ox in [110.0, 250.0]) {
      canvas.save();
      canvas.translate(ox * sx, 350 * sy);
      canvas.drawRect(
        Rect.fromLTWH(-3 * sx, 0, 6 * sx, 100 * sy),
        Paint()..color = const Color(0xFF1A0604),
      );
      canvas.drawCircle(
        Offset.zero,
        38 * math.min(sx, sy),
        Paint()..color = const Color(0xFF063828),
      );
      canvas.restore();
    }
    canvas.drawPath(
      Path()
        ..moveTo(148 * sx, 348 * sy)
        ..quadraticBezierTo(180 * sx, 392 * sy, 212 * sx, 348 * sy),
      Paint()
        ..color = const Color(0xFF1A0604)
        ..strokeWidth = 1.4
        ..style = PaintingStyle.stroke,
    );
    canvas.drawLine(
      Offset(172 * sx, 378 * sy),
      Offset(172 * sx, 392 * sy),
      Paint()
        ..color = const Color(0xFF1A0604)
        ..strokeWidth = 1,
    );
    canvas.drawLine(
      Offset(188 * sx, 378 * sy),
      Offset(188 * sx, 392 * sy),
      Paint()
        ..color = const Color(0xFF1A0604)
        ..strokeWidth = 1,
    );
    canvas.drawRect(
      Rect.fromLTWH(166 * sx, 390 * sy, 28 * sx, 3 * sy),
      Paint()..color = const Color(0xFF1A0604),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 450 * sy, 360 * sx, 110 * sy),
      Paint()..color = const Color(0xFF031F18),
    );
    canvas.drawPath(
      Path()
        ..moveTo(70 * sx, 130 * sy)
        ..relativeQuadraticBezierTo(6 * sx, -5 * sy, 12 * sx, 0)
        ..relativeQuadraticBezierTo(6 * sx, -5 * sy, 12 * sx, 0),
      Paint()
        ..color = const Color(0xFF1A0604)
        ..strokeWidth = 1.6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      Path()
        ..moveTo(88 * sx, 138 * sy)
        ..relativeQuadraticBezierTo(5 * sx, -4 * sy, 10 * sx, 0)
        ..relativeQuadraticBezierTo(5 * sx, -4 * sy, 10 * sx, 0),
      Paint()
        ..color = const Color(0xFF1A0604)
        ..strokeWidth = 1.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  void _birthday(Canvas canvas, double sx, double sy) {
    final rect = Rect.fromLTWH(0, 0, 360 * sx, 560 * sy);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.linear(
          rect.topLeft,
          rect.bottomLeft,
          const [Color(0xFFF8C8DA), Color(0xFFE07B8F), Color(0xFF5A1E40)],
          const [0, 0.5, 1],
        ),
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, 60 * sy)
        ..quadraticBezierTo(90 * sx, 100 * sy, 180 * sx, 70 * sy)
        ..quadraticBezierTo(270 * sx, 40 * sy, 360 * sx, 80 * sy),
      Paint()
        ..color = const Color(0xFFF5D06B)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
    for (var i = 0; i < 10; i++) {
      final t = i / 9;
      final x = t * 360;
      final y = 60 + math.sin(t * math.pi) * 30;
      canvas.drawCircle(
        Offset(x * sx, y * sy),
        6 * math.min(sx, sy),
        Paint()
          ..color = i.isEven
              ? const Color(0xFFF4A547)
              : const Color(0xFFF5D06B),
      );
    }
    final confetti = [
      [40.0, 200.0, 15.0, 0xFFF5D06B],
      [80, 140, 30, 0xFFFFE9A3],
      [140, 260, -20, 0xFF0F6E5E],
      [260, 180, 40, 0xFFF4A547],
      [310, 140, -10, 0xFFFFE9A3],
      [300, 300, 25, 0xFFF5D06B],
      [60, 360, 15, 0xFF0F6E5E],
      [200, 140, -30, 0xFFFFCDD7],
      [220, 360, 40, 0xFFF4A547],
      [120, 420, -15, 0xFFFFE9A3],
    ];
    for (final p in confetti) {
      canvas.save();
      canvas.translate((p[0] as double) * sx, (p[1] as double) * sy);
      canvas.rotate((p[2] as double) * math.pi / 180);
      canvas.drawRect(
        Rect.fromLTWH(0, 0, 10 * sx, 3 * sy),
        Paint()..color = Color(p[3] as int),
      );
      canvas.restore();
    }
    canvas.save();
    canvas.translate(180 * sx, 440 * sy);
    canvas.drawRRect(
      RRect.fromRectXY(Rect.fromLTWH(-50 * sx, 0, 100 * sx, 50 * sy), 2, 2),
      Paint()
        ..color = const Color(0xFFFFCDD7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.drawRect(
      Rect.fromLTWH(-50 * sx, 0, 100 * sx, 50 * sy),
      Paint()..color = const Color(0xFFFFCDD7),
    );
    canvas.drawRect(
      Rect.fromLTWH(-50 * sx, 20 * sy, 100 * sx, 6 * sy),
      Paint()..color = const Color(0xFFF5D06B),
    );
    canvas.drawRect(
      Rect.fromLTWH(-2 * sx, -30 * sy, 4 * sx, 30 * sy),
      Paint()..color = const Color(0xFFFFE9A3),
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, -45 * sy)
        ..relativeQuadraticBezierTo(-6 * sx, 8 * sy, 0, 14 * sy)
        ..relativeQuadraticBezierTo(6 * sx, -6 * sy, 0, -14 * sy),
      Paint()..color = const Color(0xFFF4A547),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant LuxeThemeBackgroundPainter oldDelegate) =>
      oldDelegate.category != category;
}
