import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './reminder_card_widget.dart';

class ReminderSectionWidget extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> reminders;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final Function(Map<String, dynamic>) onReminderTap;
  final Function(Map<String, dynamic>) onReminderToggle;
  final Function(Map<String, dynamic>) onReminderEdit;
  final Function(Map<String, dynamic>) onReminderDuplicate;
  final Function(Map<String, dynamic>) onReminderShare;
  final Function(Map<String, dynamic>) onReminderPause;
  final Function(Map<String, dynamic>) onReminderDelete;
  final Function(Map<String, dynamic>) onReminderViewHistory;
  final Function(Map<String, dynamic>) onReminderChangeAudio;
  final Function(Map<String, dynamic>) onReminderResetProgress;

  const ReminderSectionWidget({
    super.key,
    required this.title,
    required this.reminders,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onReminderTap,
    required this.onReminderToggle,
    required this.onReminderEdit,
    required this.onReminderDuplicate,
    required this.onReminderShare,
    required this.onReminderPause,
    required this.onReminderDelete,
    required this.onReminderViewHistory,
    required this.onReminderChangeAudio,
    required this.onReminderResetProgress,
  });

  @override
  State<ReminderSectionWidget> createState() => _ReminderSectionWidgetState();
}

class _ReminderSectionWidgetState extends State<ReminderSectionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppTheme.mediumAnimation,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (widget.isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ReminderSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surfaceContainer,
            theme.colorScheme.surfaceContainer.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.largeRadius),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSectionHeader(context),
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _expandAnimation.value,
                  child: child,
                ),
              );
            },
            child: _buildRemindersList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: widget.onToggleExpanded,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppTheme.largeRadius),
        bottom: widget.isExpanded
            ? Radius.zero
            : Radius.circular(AppTheme.largeRadius),
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            _buildSectionIcon(context),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${widget.reminders.length} reminder${widget.reminders.length != 1 ? 's' : ''}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedRotation(
              turns: widget.isExpanded ? 0.5 : 0.0,
              duration: AppTheme.mediumAnimation,
              child: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionIcon(BuildContext context) {
    final theme = Theme.of(context);
    String iconName;
    Color iconColor;

    switch (widget.title.toLowerCase()) {
      case 'active':
        iconName = 'play_circle_filled';
        iconColor = AppTheme.successLight;
        break;
      case 'paused':
        iconName = 'pause_circle_filled';
        iconColor = AppTheme.warningLight;
        break;
      case 'completed':
        iconName = 'check_circle';
        iconColor = AppTheme.completionGold;
        break;
      default:
        iconName = 'notifications';
        iconColor = theme.colorScheme.primary;
    }

    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            iconColor.withValues(alpha: 0.15),
            iconColor.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
      ),
      child: CustomIconWidget(
        iconName: iconName,
        color: iconColor,
        size: 24,
      ),
    );
  }

  Widget _buildRemindersList(BuildContext context) {
    if (widget.reminders.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: widget.reminders.map((reminder) {
        return ReminderCardWidget(
          reminder: reminder,
          onTap: () => widget.onReminderTap(reminder),
          onToggle: () => widget.onReminderToggle(reminder),
          onEdit: () => widget.onReminderEdit(reminder),
          onDuplicate: () => widget.onReminderDuplicate(reminder),
          onShare: () => widget.onReminderShare(reminder),
          onPause: () => widget.onReminderPause(reminder),
          onDelete: () => widget.onReminderDelete(reminder),
          onViewHistory: () => widget.onReminderViewHistory(reminder),
          onChangeAudio: () => widget.onReminderChangeAudio(reminder),
          onResetProgress: () => widget.onReminderResetProgress(reminder),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    String message;
    String iconName;

    switch (widget.title.toLowerCase()) {
      case 'active':
        message = 'No active reminders.\nCreate one to get started!';
        iconName = 'add_circle_outline';
        break;
      case 'paused':
        message = 'No paused reminders.\nPause active ones when needed.';
        iconName = 'pause_circle_outline';
        break;
      case 'completed':
        message = 'No completed reminders yet.\nKeep up the good work!';
        iconName = 'celebration';
        break;
      default:
        message = 'No reminders in this section.';
        iconName = 'notifications_none';
    }

    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (widget.title.toLowerCase() == 'active') ...[
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/create-reminder'),
              icon: CustomIconWidget(
                iconName: 'add',
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text('Create Reminder'),
            ),
          ],
        ],
      ),
    );
  }
}
