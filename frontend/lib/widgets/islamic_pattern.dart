import 'dart:math';

import 'package:flutter/material.dart';

/// Ornamen geometris Islami (bintang 8 sudut konsentris) — digambar dengan
/// CustomPainter, tanpa aset eksternal. Pakai warna semi-transparan supaya
/// jadi tekstur halus di latar banner/login.
class IslamicStarOrnament extends StatelessWidget {
  final double size;
  final Color color;

  const IslamicStarOrnament({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.square(size),
        painter: _StarPainter(color),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  final Color color;
  _StarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    // Tiga bintang 8 sudut konsentris, selang-seling rotasi 22.5°.
    for (var ring = 0; ring < 3; ring++) {
      final outer = size.width / 2 * (1 - ring * 0.3);
      final inner = outer * 0.62;
      final rotation = ring.isOdd ? pi / 8 : 0.0;
      canvas.drawPath(_starPath(center, outer, inner, rotation), paint);
    }
    canvas.drawCircle(center, size.width * 0.06, paint);
  }

  Path _starPath(Offset c, double outer, double inner, double rotation) {
    final path = Path();
    const points = 8;
    for (var i = 0; i < points * 2; i++) {
      final r = i.isEven ? outer : inner;
      final angle = rotation - pi / 2 + i * pi / points;
      final p = Offset(c.dx + r * cos(angle), c.dy + r * sin(angle));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) => oldDelegate.color != color;
}
