import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_checkmark_widget.dart';
import './widgets/islamic_pattern_widget.dart';
import './widgets/motivational_message_widget.dart';
import './widgets/particle_effect_widget.dart';
import './widgets/progress_stats_widget.dart';
import './widgets/social_sharing_widget.dart';

class CompletionCelebration extends StatefulWidget {
  const CompletionCelebration({super.key});

  @override
  State<CompletionCelebration> createState() => _CompletionCelebrationState();
}

class _CompletionCelebrationState extends State<CompletionCelebration>
    with TickerProviderStateMixin {
  late AnimationController _overlayController;
  late AnimationController _contentController;
  late Animation<double> _overlayAnimation;
  late Animation<double> _contentAnimation;
  Timer? _autoDismissTimer;

  // Mock reminder data - in real app this would come from arguments
  final Map<String, dynamic> reminderData = {
    "id": 1,
    "title": "Call Mom",
    "category": "Family",
    "completedAt": DateTime.now(),
    "todayCompletions": 3,
    "currentStreak": 7,
    "totalCompletions": 42,
    "audioFile": "family_reminder.mp3",
    "frequency": "daily",
    "nextReminder": DateTime.now().add(Duration(days: 1)),
  };

  @override
  void initState() {
    super.initState();

    _overlayController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _overlayAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeInOut,
    ));

    _contentAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.elasticOut,
    ));

    _startCelebration();
    _setupAutoDismiss();
  }

  void _startCelebration() async {
    await _overlayController.forward();
    await _contentController.forward();
  }

  void _setupAutoDismiss() {
    _autoDismissTimer = Timer(Duration(seconds: 5), () {
      if (mounted) {
        _dismissCelebration();
      }
    });
  }

  void _dismissCelebration() async {
    _autoDismissTimer?.cancel();
    await _contentController.reverse();
    await _overlayController.reverse();
    if (mounted) {
      // Navigate to reminder management instead of popping to avoid black screen
      Navigator.pushReplacementNamed(context, AppRoutes.reminderManagement);
    }
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _overlayController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _dismissCelebration();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedBuilder(
          animation: _overlayAnimation,
          builder: (context, child) {
            return Stack(
              children: [
                // Blur background
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: _overlayAnimation.value * 10,
                    sigmaY: _overlayAnimation.value * 10,
                  ),
                  child: Container(
                    color: Colors.black
                        .withValues(alpha: _overlayAnimation.value * 0.5),
                  ),
                ),

                // Particle effects
                if (_overlayAnimation.value > 0.5)
                  Positioned.fill(
                    child: ParticleEffectWidget(),
                  ),

                // Main content
                AnimatedBuilder(
                  animation: _contentAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _contentAnimation.value,
                      child: Opacity(
                        opacity: _contentAnimation.value,
                        child: _buildCelebrationContent(),
                      ),
                    );
                  },
                ),

                // Close button
                Positioned(
                  top: 8.h,
                  right: 4.w,
                  child: GestureDetector(
                    onTap: _dismissCelebration,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: Colors.white,
                        size: 5.w,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCelebrationContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),

              // Islamic pattern background
              Stack(
                alignment: Alignment.center,
                children: [
                  IslamicPatternWidget(),
                  AnimatedCheckmarkWidget(
                    onAnimationComplete: () {
                      // Trigger additional haptic feedback
                      HapticFeedback.heavyImpact();
                    },
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              // Reminder title and completion time
              Container(
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  children: [
                    Text(
                      'Completed!',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      reminderData['title'] as String,
                      textAlign: TextAlign.center,
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Completed at ${_formatTime(reminderData['completedAt'] as DateTime)}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // Progress statistics
              ProgressStatsWidget(reminderData: reminderData),

              SizedBox(height: 3.h),

              // Motivational message
              MotivationalMessageWidget(
                currentStreak: reminderData['currentStreak'] as int,
              ),

              SizedBox(height: 4.h),

              // Social sharing options
              SocialSharingWidget(reminderData: reminderData),

              SizedBox(height: 4.h),

              // Action buttons
              _buildActionButtons(),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          // Primary continue button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _dismissCelebration,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
                ),
                elevation: 4,
                shadowColor: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: 'arrow_forward',
                    color: Colors.white,
                    size: 5.w,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Secondary action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.reminderManagement);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side:
                        BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.mediumRadius),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'trending_up',
                        color: Colors.white,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'View Progress',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.createReminder);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side:
                        BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.mediumRadius),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'flag',
                        color: Colors.white,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Set Goal',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$displayHour:$minute $period';
  }
}
