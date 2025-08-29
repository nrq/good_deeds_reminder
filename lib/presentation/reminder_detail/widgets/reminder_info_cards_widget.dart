import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReminderInfoCardsWidget extends StatelessWidget {
  final Map<String, dynamic> reminder;

  const ReminderInfoCardsWidget({
    super.key,
    required this.reminder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Frequency',
                _getFrequencyText(
                    reminder["frequency"] as Map<String, dynamic>),
                'schedule',
                AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildInfoCard(
                'Next Due',
                _getNextDueText(reminder["nextDue"] as String),
                'alarm',
                AppTheme.accentLight,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Audio File',
                reminder["audioFile"] != null
                    ? (reminder["audioFile"] as Map<String, dynamic>)["name"]
                        as String
                    : 'No audio assigned',
                'audiotrack',
                AppTheme.audioBlue,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildInfoCard(
                'Created',
                _formatDate(reminder["createdAt"] as String),
                'calendar_today',
                AppTheme.lightTheme.colorScheme.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      String title, String value, String iconName, Color color) {
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
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _getFrequencyText(Map<String, dynamic> frequency) {
    final type = frequency["type"] as String;
    final interval = frequency["interval"] as int;

    switch (type) {
      case 'daily':
        return interval == 1 ? 'Daily' : 'Every $interval days';
      case 'weekly':
        return interval == 1 ? 'Weekly' : 'Every $interval weeks';
      case 'hourly':
        return interval == 1 ? 'Hourly' : 'Every $interval hours';
      case 'minutely':
        return interval == 1 ? 'Every minute' : 'Every $interval minutes';
      default:
        return 'Custom';
    }
  }

  String _getNextDueText(String nextDue) {
    final dueDate = DateTime.parse(nextDue);
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays} days';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes';
    } else {
      return 'Due now';
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
