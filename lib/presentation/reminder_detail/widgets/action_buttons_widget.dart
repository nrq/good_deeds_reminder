import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final Map<String, dynamic> reminder;
  final VoidCallback onCompleteNow;
  final VoidCallback onEdit;
  final VoidCallback onPauseResume;
  final VoidCallback onDelete;

  const ActionButtonsWidget({
    super.key,
    required this.reminder,
    required this.onCompleteNow,
    required this.onEdit,
    required this.onPauseResume,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isPaused = reminder["isPaused"] as bool? ?? false;

    return Column(
      children: [
        // Primary action button
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton.icon(
            onPressed: onCompleteNow,
            icon: CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 6.w,
            ),
            label: Text(
              'Complete Now',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
              ),
            ),
          ),
        ),
        SizedBox(height: 3.h),

        // Secondary action buttons
        Row(
          children: [
            Expanded(
              child: _buildSecondaryButton(
                'Edit',
                'edit',
                AppTheme.lightTheme.colorScheme.primary,
                onEdit,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildSecondaryButton(
                isPaused ? 'Resume' : 'Pause',
                isPaused ? 'play_arrow' : 'pause',
                isPaused ? AppTheme.successLight : AppTheme.warningLight,
                onPauseResume,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildSecondaryButton(
                'Delete',
                'delete',
                AppTheme.errorLight,
                () => _showDeleteConfirmation(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondaryButton(
    String label,
    String iconName,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      height: 5.h,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 5.w,
        ),
        label: Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.errorLight,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Delete Reminder',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete "${reminder["title"]}"?',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.errorLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                border: Border.all(
                  color: AppTheme.errorLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.errorLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'This action cannot be undone. All completion history will be lost.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.errorLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text(
              'Delete',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
