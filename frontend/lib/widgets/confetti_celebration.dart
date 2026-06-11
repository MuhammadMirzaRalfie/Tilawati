import 'dart:math';

import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Hujan confetti sekali jalan (~3 detik) untuk merayakan skor Mumtaz.
/// Digambar dengan CustomPainter — tanpa aset eksternal, jalan offline.
class ConfettiCelebration extends StatefulWidget {
  const ConfettiCelebration({super.key});

  @override
  State<ConfettiCelebration> createState() => _ConfettiCelebrationState();
}

class _ConfettiCelebrationState extends State<ConfettiCelebration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  static const _palette = [
    AppColors.secondary,
    AppColors.secondaryLight,
    AppColors.primaryLight,
    AppColors.info,
    Color(0xFFE57373),
    Color(0xFFBA68C8),
  ];

  @override
  void initState() {
    super.initState();
    final rng = Random();
    _particles = List.generate(60, (_) => _Particle.random(rng, _palette));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.isCompleted) return const SizedBox.shrink();
          return CustomPaint(
            size: Size.infinite,
            painter: _ConfettiPainter(_particles, _controller.value),
          );
        },
      ),
    );
  }
}

class _Particle {
  final double x; // posisi horizontal awal (0..1)
  final double delay; // mulai jatuh setelah fraksi waktu ini
  final double speed; // pengali kecepatan jatuh
  final double size;
  final double swayAmp; // amplitudo goyang horizontal (fraksi lebar)
  final double swayFreq;
  final double rotSpeed;
  final Color color;
  final bool isCircle;

  _Particle({
    required this.x,
    required this.delay,
    required this.speed,
    required this.size,
    required this.swayAmp,
    required this.swayFreq,
    required this.rotSpeed,
    required this.color,
    required this.isCircle,
  });

  factory _Particle.random(Random rng, List<Color> palette) {
    return _Particle(
      x: rng.nextDouble(),
      delay: rng.nextDouble() * 0.35,
      speed: 0.8 + rng.nextDouble() * 0.7,
      size: 5 + rng.nextDouble() * 7,
      swayAmp: 0.02 + rng.nextDouble() * 0.05,
      swayFreq: 2 + rng.nextDouble() * 3,
      rotSpeed: (rng.nextDouble() - 0.5) * 12,
      color: palette[rng.nextInt(palette.length)],
      isCircle: rng.nextBool(),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double t; // 0..1

  _ConfettiPainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final p in particles) {
      final progress = ((t - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (progress <= 0) continue;

      final y = (-0.05 + progress * 1.15 * p.speed) * size.height;
      if (y > size.height + p.size) continue;
      final x =
          (p.x + sin(progress * p.swayFreq * pi) * p.swayAmp) * size.width;

      // Memudar di 20% terakhir durasi animasi.
      final opacity = t > 0.8 ? ((1 - t) / 0.2).clamp(0.0, 1.0) : 1.0;
      paint.color = p.color.withOpacity(opacity);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * p.rotSpeed);
      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset.zero, width: p.size, height: p.size * 0.6),
            const Radius.circular(1.5),
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => oldDelegate.t != t;
}
