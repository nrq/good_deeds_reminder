import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StorageIndicatorWidget extends StatelessWidget {
  final double usedStorage;
  final double totalStorage;
  final int fileCount;

  const StorageIndicatorWidget({
    super.key,
    required this.usedStorage,
    required this.totalStorage,
    required this.fileCount,
  });

  @override
  Widget build(BuildContext context) {
    final usagePercentage = (usedStorage / totalStorage).clamp(0.0, 1.0);
    final remainingStorage = totalStorage - usedStorage;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.surface,
            AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 2.h),
          _buildProgressBar(usagePercentage),
          SizedBox(height: 1.5.h),
          _buildStorageDetails(remainingStorage),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightTheme.colorScheme.tertiary,
                AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.8),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'storage',
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Audio Storage',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$fileCount ${fileCount == 1 ? 'file' : 'files'} stored',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        _buildStorageIcon(),
      ],
    );
  }

  Widget _buildStorageIcon() {
    final usagePercentage = (usedStorage / totalStorage).clamp(0.0, 1.0);
    Color iconColor;
    String iconName;

    if (usagePercentage < 0.5) {
      iconColor = AppTheme.lightTheme.colorScheme.primary;
      iconName = 'check_circle_outline';
    } else if (usagePercentage < 0.8) {
      iconColor = AppTheme.warningLight;
      iconName = 'warning_amber_rounded';
    } else {
      iconColor = AppTheme.errorLight;
      iconName = 'error_outline';
    }

    return CustomIconWidget(
      iconName: iconName,
      color: iconColor,
      size: 20,
    );
  }

  Widget _buildProgressBar(double percentage) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_formatStorage(usedStorage)} used',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '${_formatStorage(totalStorage)} total',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          height: 1.h,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: (percentage * 100).w,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: _getProgressColors(percentage),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStorageDetails(double remainingStorage) {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(
            iconName: 'folder',
            label: 'Available',
            value: _formatStorage(remainingStorage),
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: _buildDetailItem(
            iconName: 'music_note',
            label: 'Audio Files',
            value: fileCount.toString(),
            color: AppTheme.lightTheme.colorScheme.tertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required String iconName,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 16,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
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

  List<Color> _getProgressColors(double percentage) {
    if (percentage < 0.5) {
      return [
        AppTheme.lightTheme.colorScheme.primary,
        AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
      ];
    } else if (percentage < 0.8) {
      return [
        AppTheme.warningLight,
        AppTheme.warningLight.withValues(alpha: 0.8),
      ];
    } else {
      return [
        AppTheme.errorLight,
        AppTheme.errorLight.withValues(alpha: 0.8),
      ];
    }
  }

  String _formatStorage(double bytes) {
    if (bytes < 1024) {
      return '${bytes.toStringAsFixed(0)} B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}
