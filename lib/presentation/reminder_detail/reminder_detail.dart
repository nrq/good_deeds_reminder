import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/audio_preview_widget.dart';
import './widgets/completion_history_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/reminder_header_widget.dart';
import './widgets/reminder_info_cards_widget.dart';

class ReminderDetail extends StatefulWidget {
  const ReminderDetail({super.key});

  @override
  State<ReminderDetail> createState() => _ReminderDetailState();
}

class _ReminderDetailState extends State<ReminderDetail>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock reminder data
  final Map<String, dynamic> reminderData = {
    "id": 1,
    "title": "Call Mom",
    "category": "Family",
    "description": "Weekly call to check on mom and share updates about life",
    "frequency": {
      "type": "weekly",
      "interval": 1,
      "days": ["Sunday"],
      "time": "19:00"
    },
    "nextDue": "2025-08-31T19:00:00.000Z",
    "audioFile": {
      "id": 1,
      "name": "gentle-reminder.mp3",
      "duration": "2:30",
      "size": "3.2 MB",
      "url": "https://example.com/audio/gentle-reminder.mp3"
    },
    "createdAt": "2025-08-20T10:30:00.000Z",
    "isPaused": false,
    "completedCount": 12,
    "streak": 3,
    "successRate": 85,
    "completionHistory": [
      {
        "id": 1,
        "completedAt": "2025-08-25T19:15:00.000Z",
        "note": "Had a great conversation about her garden"
      },
      {"id": 2, "completedAt": "2025-08-18T19:30:00.000Z", "note": null},
      {
        "id": 3,
        "completedAt": "2025-08-11T20:00:00.000Z",
        "note": "Discussed upcoming family reunion"
      },
      {"id": 4, "completedAt": "2025-08-04T19:45:00.000Z", "note": null},
      {
        "id": 5,
        "completedAt": "2025-07-28T19:20:00.000Z",
        "note": "She shared her new recipe"
      },
      {"id": 6, "completedAt": "2025-07-21T19:10:00.000Z", "note": null}
    ]
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimation();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: AppTheme.mediumAnimation,
      vsync: this,
    );
    _slideController = AnimationController(
      duration: AppTheme.longAnimation,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startEntryAnimation() {
    Future.delayed(Duration(milliseconds: 100), () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Reminder Details',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showMoreOptions,
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with gradient background and stats
                ReminderHeaderWidget(
                  reminder: reminderData,
                  onEditPressed: _handleEdit,
                ),
                SizedBox(height: 4.h),

                // Information cards
                ReminderInfoCardsWidget(
                  reminder: reminderData,
                ),
                SizedBox(height: 4.h),

                // Audio preview
                AudioPreviewWidget(
                  audioFile: reminderData["audioFile"] as Map<String, dynamic>?,
                  onPlayPause: _handleAudioPlayPause,
                  onChangeAudio: _handleChangeAudio,
                ),
                SizedBox(height: 4.h),

                // Completion history
                CompletionHistoryWidget(
                  completionHistory: (reminderData["completionHistory"] as List)
                      .cast<Map<String, dynamic>>(),
                ),
                SizedBox(height: 4.h),

                // Action buttons
                ActionButtonsWidget(
                  reminder: reminderData,
                  onCompleteNow: _handleCompleteNow,
                  onEdit: _handleEdit,
                  onPauseResume: _handlePauseResume,
                  onDelete: _handleDelete,
                ),
                SizedBox(height: 4.h),

                // Quick actions
                QuickActionsWidget(
                  reminder: reminderData,
                  onDuplicate: _handleDuplicate,
                  onShare: _handleShare,
                  onResetProgress: _handleResetProgress,
                ),
                SizedBox(height: 8.h), // Bottom padding for safe area
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.extraLargeRadius),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Notification Settings'),
              onTap: () {
                Navigator.pop(context);
                _handleNotificationSettings();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.audioBlue,
                size: 6.w,
              ),
              title: Text('Reschedule'),
              onTap: () {
                Navigator.pop(context);
                _handleReschedule();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'analytics',
                color: AppTheme.successLight,
                size: 6.w,
              ),
              title: Text('View Analytics'),
              onTap: () {
                Navigator.pop(context);
                _handleViewAnalytics();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _handleCompleteNow() {
    HapticFeedback.lightImpact();

    // Show completion animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.successLight.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.successLight,
                  size: 12.w,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Completed!',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.successLight,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Great job on completing "${reminderData["title"]}"',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/completion-celebration');
                  },
                  child: Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleEdit() {
    Navigator.pushNamed(context, '/create-reminder', arguments: reminderData);
  }

  void _handlePauseResume() {
    setState(() {
      reminderData["isPaused"] = !(reminderData["isPaused"] as bool);
    });

    final isPaused = reminderData["isPaused"] as bool;
    Fluttertoast.showToast(
      msg: isPaused ? 'Reminder paused' : 'Reminder resumed',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleDelete() {
    Navigator.pop(context);
    Fluttertoast.showToast(
      msg: 'Reminder deleted',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleDuplicate() {
    final duplicatedReminder = Map<String, dynamic>.from(reminderData);
    duplicatedReminder["title"] = "${reminderData["title"]} (Copy)";
    duplicatedReminder["id"] = DateTime.now().millisecondsSinceEpoch;

    Navigator.pushNamed(context, '/create-reminder',
        arguments: duplicatedReminder);
  }

  void _handleShare() {
    final shareText = '''
Good Deed Reminder: ${reminderData["title"]}
Category: ${reminderData["category"]}
Frequency: ${_getFrequencyText()}
Completed: ${reminderData["completedCount"]} times
Success Rate: ${reminderData["successRate"]}%

Stay consistent with your good deeds! 🌟
''';

    // In a real app, you would use the share plugin
    Clipboard.setData(ClipboardData(text: shareText));
    Fluttertoast.showToast(
      msg: 'Reminder details copied to clipboard',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleResetProgress() {
    setState(() {
      reminderData["completedCount"] = 0;
      reminderData["streak"] = 0;
      reminderData["successRate"] = 0;
      reminderData["completionHistory"] = <Map<String, dynamic>>[];
    });

    Fluttertoast.showToast(
      msg: 'Progress reset successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleAudioPlayPause() {
    // Handle audio playback
    Fluttertoast.showToast(
      msg: 'Audio playback toggled',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleChangeAudio() {
    Navigator.pushNamed(context, '/audio-library');
  }

  void _handleNotificationSettings() {
    Fluttertoast.showToast(
      msg: 'Opening notification settings',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleReschedule() {
    Fluttertoast.showToast(
      msg: 'Opening reschedule options',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleViewAnalytics() {
    Fluttertoast.showToast(
      msg: 'Opening analytics view',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  String _getFrequencyText() {
    final frequency = reminderData["frequency"] as Map<String, dynamic>;
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
}
