import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnimatedCheckmarkWidget extends StatefulWidget {
  final VoidCallback? onAnimationComplete;

  const AnimatedCheckmarkWidget({
    super.key,
    this.onAnimationComplete,
  });

  @override
  State<AnimatedCheckmarkWidget> createState() =>
      _AnimatedCheckmarkWidgetState();
}

class _AnimatedCheckmarkWidgetState extends State<AnimatedCheckmarkWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    // Trigger haptic feedback
    HapticFeedback.mediumImpact();

    // Start scale animation
    await _scaleController.forward();

    // Start rotation animation
    await _rotationController.forward();

    // Notify completion
    widget.onAnimationComplete?.call();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 0.5,
            child: Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary,
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'check',
                  color: Colors.white,
                  size: 8.w,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
