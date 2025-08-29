import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MotivationalMessageWidget extends StatefulWidget {
  final int currentStreak;

  const MotivationalMessageWidget({
    super.key,
    required this.currentStreak,
  });

  @override
  State<MotivationalMessageWidget> createState() =>
      _MotivationalMessageWidgetState();
}

class _MotivationalMessageWidgetState extends State<MotivationalMessageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  String _currentMessage = '';

  final List<String> _islamicMessages = [
    "Alhamdulillahi Rabbil Alameen! 🤲",
    "May Allah accept your good deeds! ✨",
    "Barakallahu feeki! Keep going! 🌟",
    "Your consistency is beautiful! 💚",
    "SubhanAllah! Another step closer! 🕌",
    "May this deed be heavy on your scale! ⚖️",
    "Allah loves those who are consistent! 💫",
    "Your effort is seen and appreciated! 👁️",
  ];

  final List<String> _streakMessages = [
    "Amazing! You're building great habits! 🔥",
    "Your dedication is inspiring! 💪",
    "Consistency is the key to success! 🗝️",
    "You're on fire! Keep it up! 🚀",
    "Every day counts! Well done! 📈",
    "Your commitment is admirable! 🏆",
    "Building momentum beautifully! ⚡",
    "Excellence through persistence! 🎯",
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _selectMessage();
    _fadeController.forward();
  }

  void _selectMessage() {
    final random = math.Random();

    // Mix Islamic messages with achievement messages based on streak
    List<String> availableMessages = [..._islamicMessages];

    if (widget.currentStreak >= 3) {
      availableMessages.addAll(_streakMessages);
    }

    _currentMessage =
        availableMessages[random.nextInt(availableMessages.length)];
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.accentLight.withValues(alpha: 0.1),
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
          border: Border.all(
            color: AppTheme.accentLight.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              _currentMessage,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            if (widget.currentStreak >= 7) ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.accentLight.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'local_fire_department',
                      color: AppTheme.warningLight,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${widget.currentStreak} Day Streak!',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
