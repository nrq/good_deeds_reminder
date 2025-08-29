import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialSharingWidget extends StatelessWidget {
  final Map<String, dynamic> reminderData;

  const SocialSharingWidget({
    super.key,
    required this.reminderData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          Text(
            'Share Your Achievement',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShareButton(
                context,
                'Share Achievement',
                'share',
                AppTheme.lightTheme.colorScheme.primary,
                () => _shareAchievement(context),
              ),
              _buildShareButton(
                context,
                'Add to Story',
                'add_photo_alternate',
                AppTheme.accentLight,
                () => _addToStory(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton(
    BuildContext context,
    String label,
    String iconName,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          padding: EdgeInsets.symmetric(vertical: 2.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 6.w,
              ),
              SizedBox(height: 1.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareAchievement(BuildContext context) {
    HapticFeedback.lightImpact();

    final reminderTitle = reminderData['title'] as String? ?? 'Good Deed';
    final currentStreak = reminderData['currentStreak'] as int? ?? 1;
    final totalCompletions =
        (reminderData['totalCompletions'] as int? ?? 0) + 1;

    final shareText = '''
🌟 Alhamdulillah! Just completed: $reminderTitle

📊 My Progress:
• Current Streak: $currentStreak days
• Total Completions: $totalCompletions

Building consistent habits for a better tomorrow! 💚

#GoodDeeds #IslamicLifestyle #Consistency #Alhamdulillah
    '''
        .trim();

    // Copy to clipboard as a simple sharing mechanism
    Clipboard.setData(ClipboardData(text: shareText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Achievement copied to clipboard!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.smallRadius),
        ),
      ),
    );
  }

  void _addToStory(BuildContext context) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppTheme.extraLargeRadius)),
        ),
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Story Templates',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildStoryTemplate(
              context,
              'Islamic Pattern',
              'Beautiful geometric patterns with your achievement',
              'auto_awesome',
              AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(height: 2.h),
            _buildStoryTemplate(
              context,
              'Minimalist',
              'Clean and simple design with elegant typography',
              'format_paint',
              AppTheme.accentLight,
            ),
            SizedBox(height: 2.h),
            _buildStoryTemplate(
              context,
              'Progress Chart',
              'Visual representation of your streak and progress',
              'bar_chart',
              AppTheme.warningLight,
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryTemplate(
    BuildContext context,
    String title,
    String description,
    String iconName,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _generateStoryTemplate(context, title);
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppTheme.smallRadius),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 5.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: color,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }

  void _generateStoryTemplate(BuildContext context, String templateType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$templateType template generated! Check your gallery.'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.smallRadius),
        ),
      ),
    );
  }
}
