import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ParticleEffectWidget extends StatefulWidget {
  const ParticleEffectWidget({super.key});

  @override
  State<ParticleEffectWidget> createState() => _ParticleEffectWidgetState();
}

class _ParticleEffectWidgetState extends State<ParticleEffectWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _initializeParticles();
    _animationController.repeat();
  }

  void _initializeParticles() {
    _particles = List.generate(20, (index) {
      return Particle(
        x: 50.w,
        y: 50.h,
        vx: (math.Random().nextDouble() - 0.5) * 4,
        vy: (math.Random().nextDouble() - 0.5) * 4,
        size: math.Random().nextDouble() * 4 + 2,
        color: index % 2 == 0
            ? AppTheme.lightTheme.colorScheme.primary
            : AppTheme.accentLight,
        life: 1.0,
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        _updateParticles();
        return CustomPaint(
          size: Size(100.w, 100.h),
          painter: ParticlePainter(_particles),
        );
      },
    );
  }

  void _updateParticles() {
    for (var particle in _particles) {
      particle.x += particle.vx;
      particle.y += particle.vy;
      particle.life -= 0.02;

      if (particle.life <= 0) {
        // Reset particle
        particle.x = 50.w;
        particle.y = 50.h;
        particle.vx = (math.Random().nextDouble() - 0.5) * 4;
        particle.vy = (math.Random().nextDouble() - 0.5) * 4;
        particle.life = 1.0;
      }
    }
  }
}

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  Color color;
  double life;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.life,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.life * 0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size * particle.life,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
