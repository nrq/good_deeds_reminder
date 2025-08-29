import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onUploadPressed;

  const EmptyStateWidget({
    super.key,
    required this.onUploadPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(),
            SizedBox(height: 4.h),
            _buildTitle(),
            SizedBox(height: 2.h),
            _buildDescription(),
            SizedBox(height: 6.h),
            _buildUploadButton(),
            SizedBox(height: 3.h),
            _buildHelpText(),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.colorScheme.primary,
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.8),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'mic',
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          Positioned(
            top: 8.w,
            right: 8.w,
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightTheme.colorScheme.tertiary,
                    AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.8),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'music_note',
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Upload Your First Audio',
      style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppTheme.lightTheme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription() {
    return Text(
      'Add custom MP3 files to personalize your reminder notifications. Create a meaningful audio library for your spiritual journey.',
      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildUploadButton() {
    return GestureDetector(
      onTap: onUploadPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 8.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'cloud_upload',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Text(
              'Upload Audio File',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpText() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'lightbulb_outline',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Pro Tips',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            '• Use clear, meaningful audio for better reminder effectiveness\n• Keep files under 50MB for optimal performance\n• Consider recording personal duas or motivational messages',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
