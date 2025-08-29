import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TimeSelectionWidget extends StatefulWidget {
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay) onTimeSelected;

  const TimeSelectionWidget({
    super.key,
    this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  State<TimeSelectionWidget> createState() => _TimeSelectionWidgetState();
}

class _TimeSelectionWidgetState extends State<TimeSelectionWidget> {
  final List<Map<String, dynamic>> prayerTimes = [
    {
      'name': 'Fajr',
      'time': TimeOfDay(hour: 5, minute: 30),
      'icon': 'wb_twilight'
    },
    {
      'name': 'Dhuhr',
      'time': TimeOfDay(hour: 12, minute: 30),
      'icon': 'wb_sunny'
    },
    {
      'name': 'Asr',
      'time': TimeOfDay(hour: 15, minute: 45),
      'icon': 'wb_cloudy'
    },
    {
      'name': 'Maghrib',
      'time': TimeOfDay(hour: 18, minute: 15),
      'icon': 'wb_twilight'
    },
    {
      'name': 'Isha',
      'time': TimeOfDay(hour: 20, minute: 0),
      'icon': 'nightlight'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        _buildTimeSelector(),
        SizedBox(height: 3.h),
        _buildPrayerTimesSection(),
      ],
    );
  }

  Widget _buildTimeSelector() {
    return GestureDetector(
      onTap: _selectTime,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.selectedTime != null
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
            width: widget.selectedTime != null ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'access_time',
              color: widget.selectedTime != null
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.selectedTime != null
                        ? 'Selected Time'
                        : 'Select Time',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (widget.selectedTime != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      widget.selectedTime!.format(context),
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'keyboard_arrow_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Select - Prayer Times',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 10.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            itemCount: prayerTimes.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final prayer = prayerTimes[index];
              final isSelected = widget.selectedTime != null &&
                  widget.selectedTime!.hour ==
                      (prayer['time'] as TimeOfDay).hour &&
                  widget.selectedTime!.minute ==
                      (prayer['time'] as TimeOfDay).minute;

              return GestureDetector(
                onTap: () => widget.onTimeSelected(prayer['time'] as TimeOfDay),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: 18.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow
                            .withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: prayer['icon'],
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        prayer['name'],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        (prayer['time'] as TimeOfDay).format(context),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontSize: 10.sp,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              hourMinuteTextColor: AppTheme.lightTheme.colorScheme.onSurface,
              hourMinuteColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              dialHandColor: AppTheme.lightTheme.colorScheme.primary,
              dialBackgroundColor: AppTheme.lightTheme.colorScheme.surface,
              dialTextColor: AppTheme.lightTheme.colorScheme.onSurface,
              entryModeIconColor: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.onTimeSelected(picked);
    }
  }
}
