import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressStatsWidget extends StatefulWidget {
  final Map<String, dynamic> reminderData;

  const ProgressStatsWidget({
    super.key,
    required this.reminderData,
  });

  @override
  State<ProgressStatsWidget> createState() => _ProgressStatsWidgetState();
}

class _ProgressStatsWidgetState extends State<ProgressStatsWidget>
    with TickerProviderStateMixin {
  late AnimationController _counterController;
  late Animation<int> _todayAnimation;
  late Animation<int> _streakAnimation;
  late Animation<int> _totalAnimation;

  @override
  void initState() {
    super.initState();

    _counterController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    final todayCount =
        (widget.reminderData['todayCompletions'] as int? ?? 0) + 1;
    final streakCount = widget.reminderData['currentStreak'] as int? ?? 1;
    final totalCount =
        (widget.reminderData['totalCompletions'] as int? ?? 0) + 1;

    _todayAnimation = IntTween(
      begin: todayCount - 1,
      end: todayCount,
    ).animate(CurvedAnimation(
      parent: _counterController,
      curve: Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    _streakAnimation = IntTween(
      begin: streakCount - 1,
      end: streakCount,
    ).animate(CurvedAnimation(
      parent: _counterController,
      curve: Interval(0.2, 0.6, curve: Curves.easeOut),
    ));

    _totalAnimation = IntTween(
      begin: totalCount - 1,
      end: totalCount,
    ).animate(CurvedAnimation(
      parent: _counterController,
      curve: Interval(0.4, 1.0, curve: Curves.easeOut),
    ));

    _counterController.forward();
  }

  @override
  void dispose() {
    _counterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _counterController,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 6.w),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightTheme.colorScheme.surface,
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                'Today',
                _todayAnimation.value.toString(),
                CustomIconWidget(
                  iconName: 'today',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
              ),
              _buildDivider(),
              _buildStatItem(
                'Streak',
                _streakAnimation.value.toString(),
                CustomIconWidget(
                  iconName: 'local_fire_department',
                  color: AppTheme.warningLight,
                  size: 5.w,
                ),
              ),
              _buildDivider(),
              _buildStatItem(
                'Total',
                _totalAnimation.value.toString(),
                CustomIconWidget(
                  iconName: 'star',
                  color: AppTheme.accentLight,
                  size: 5.w,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, Widget icon) {
    return Expanded(
      child: Column(
        children: [
          icon,
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 8.h,
      width: 1,
      color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
      margin: EdgeInsets.symmetric(horizontal: 2.w),
    );
  }
}
