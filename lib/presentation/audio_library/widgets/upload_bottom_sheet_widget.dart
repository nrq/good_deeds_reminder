import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UploadBottomSheetWidget extends StatelessWidget {
  final VoidCallback onRecordNew;
  final VoidCallback onChooseFromFiles;
  final VoidCallback onBrowseCollection;

  const UploadBottomSheetWidget({
    super.key,
    required this.onRecordNew,
    required this.onChooseFromFiles,
    required this.onBrowseCollection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.colorScheme.surface,
            AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.extraLargeRadius)),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          SizedBox(height: 3.h),
          _buildHeader(),
          SizedBox(height: 4.h),
          _buildUploadOptions(context),
          SizedBox(height: 3.h),
          _buildSupportedFormats(),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 12.w,
      height: 0.5.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightTheme.colorScheme.primary,
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
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
              iconName: 'cloud_upload',
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Upload Audio File',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Choose how you\'d like to add your audio file',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUploadOptions(BuildContext context) {
    return Column(
      children: [
        _buildUploadOption(
          context: context,
          iconName: 'mic',
          title: 'Record New',
          subtitle: 'Record audio directly in the app',
          onTap: onRecordNew,
          gradient: [
            AppTheme.lightTheme.colorScheme.tertiary,
            AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.8),
          ],
        ),
        SizedBox(height: 2.h),
        _buildUploadOption(
          context: context,
          iconName: 'folder_open',
          title: 'Choose from Files',
          subtitle: 'Select MP3 or M4A files from device',
          onTap: onChooseFromFiles,
          gradient: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        SizedBox(height: 2.h),
        _buildUploadOption(
          context: context,
          iconName: 'library_music',
          title: 'Browse Islamic Collection',
          subtitle: 'Explore curated Islamic audio library',
          onTap: onBrowseCollection,
          gradient: [
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.8),
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.6),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadOption({
    required BuildContext context,
    required String iconName,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required List<Color> gradient,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              gradient[0].withValues(alpha: 0.1),
              gradient[1].withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
          border: Border.all(
            color: gradient[0].withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportedFormats() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info_outline',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Supported Formats',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'MP3, M4A • Max size: 50MB • Duration: Up to 10 minutes',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
