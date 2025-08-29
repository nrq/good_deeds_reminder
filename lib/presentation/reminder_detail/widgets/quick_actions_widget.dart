import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final Map<String, dynamic> reminder;
  final VoidCallback onDuplicate;
  final VoidCallback onShare;
  final VoidCallback onResetProgress;

  const QuickActionsWidget({
    super.key,
    required this.reminder,
    required this.onDuplicate,
    required this.onShare,
    required this.onResetProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'flash_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Quick Actions',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'Duplicate',
                  'Create a copy of this reminder',
                  'content_copy',
                  AppTheme.lightTheme.colorScheme.primary,
                  onDuplicate,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQuickActionCard(
                  'Share',
                  'Share reminder details',
                  'share',
                  AppTheme.audioBlue,
                  onShare,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildQuickActionCard(
            'Reset Progress',
            'Clear all completion history and start fresh',
            'refresh',
            AppTheme.warningLight,
            () => _showResetConfirmation(context),
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    String description,
    String iconName,
    Color color,
    VoidCallback onTap, {
    bool isFullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: isFullWidth
            ? Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                    ),
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: color,
                      size: 5.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          description,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'chevron_right',
                    color: color.withValues(alpha: 0.7),
                    size: 5.w,
                  ),
                ],
              )
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                    ),
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: color,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
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
              color: AppTheme.warningLight,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Reset Progress',
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
              'Are you sure you want to reset all progress for "${reminder["title"]}"?',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.warningLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                border: Border.all(
                  color: AppTheme.warningLight.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info',
                        color: AppTheme.warningLight,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'This will reset:',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.warningLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Padding(
                    padding: EdgeInsets.only(left: 7.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• Completion count to 0',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.warningLight,
                          ),
                        ),
                        Text(
                          '• Current streak to 0',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.warningLight,
                          ),
                        ),
                        Text(
                          '• All completion history',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.warningLight,
                          ),
                        ),
                      ],
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
              onResetProgress();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningLight,
            ),
            child: Text(
              'Reset',
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
