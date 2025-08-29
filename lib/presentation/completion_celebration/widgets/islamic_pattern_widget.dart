import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class IslamicPatternWidget extends StatefulWidget {
  const IslamicPatternWidget({super.key});

  @override
  State<IslamicPatternWidget> createState() => _IslamicPatternWidgetState();
}

class _IslamicPatternWidgetState extends State<IslamicPatternWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 2 * 3.14159,
          child: Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 60.w,
              height: 60.w,
              child: CustomPaint(
                painter: IslamicPatternPainter(
                  primaryColor: AppTheme.lightTheme.colorScheme.primary,
                  accentColor: AppTheme.accentLight,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class IslamicPatternPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;

  IslamicPatternPainter({
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Create gradient paint
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.3),
          accentColor.withValues(alpha: 0.1),
          primaryColor.withValues(alpha: 0.05),
        ],
        stops: [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    // Draw geometric pattern
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final startPoint = Offset(
        center.dx + (radius * 0.3) * cos(angle),
        center.dy + (radius * 0.3) * sin(angle),
      );
      final endPoint = Offset(
        center.dx + (radius * 0.9) * cos(angle),
        center.dy + (radius * 0.9) * sin(angle),
      );

      canvas.drawLine(startPoint, endPoint, paint..strokeWidth = 2);
    }

    // Draw concentric circles
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(
        center,
        radius * (0.2 + i * 0.2),
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

double cos(double radians) => math.cos(radians);
double sin(double radians) => math.sin(radians);

// Import math for trigonometric functions
