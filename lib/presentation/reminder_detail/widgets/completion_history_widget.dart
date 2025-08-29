import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CompletionHistoryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> completionHistory;

  const CompletionHistoryWidget({
    super.key,
    required this.completionHistory,
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
                iconName: 'history',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Completion History',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          completionHistory.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: completionHistory
                      .take(5)
                      .map((completion) => _buildHistoryItem(completion))
                      .toList(),
                ),
          if (completionHistory.length > 5) ...[
            SizedBox(height: 2.h),
            Center(
              child: TextButton(
                onPressed: () => _showFullHistory(context),
                child: Text('View All History'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'timeline',
            color: AppTheme.textDisabledLight,
            size: 12.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No completions yet',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Complete this reminder to start building your history',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textDisabledLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> completion) {
    final completedAt = DateTime.parse(completion["completedAt"] as String);
    final isToday = _isToday(completedAt);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Container(
            width: 1.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: isToday
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 4.w),
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: isToday
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.smallRadius),
              border: Border.all(
                color: isToday
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3)
                    : AppTheme.dividerLight,
              ),
            ),
            child: CustomIconWidget(
              iconName: 'check_circle',
              color: isToday
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.successLight,
              size: 5.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatCompletionDate(completedAt),
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isToday
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.textPrimaryLight,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _formatCompletionTime(completedAt),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
                if (completion["note"] != null) ...[
                  SizedBox(height: 1.h),
                  Text(
                    completion["note"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _formatCompletionDate(DateTime date) {
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

  String _formatCompletionTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$displayHour:$minute $period';
  }

  void _showFullHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppTheme.extraLargeRadius)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Text(
                    'Complete History',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.textSecondaryLight,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: completionHistory.length,
                itemBuilder: (context, index) =>
                    _buildHistoryItem(completionHistory[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
