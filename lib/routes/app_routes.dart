import 'package:flutter/material.dart';
import '../presentation/completion_celebration/completion_celebration.dart';
import '../presentation/create_reminder/create_reminder.dart';
import '../presentation/reminder_management/reminder_management.dart';
import '../presentation/audio_library/audio_library.dart';
import '../presentation/reminder_detail/reminder_detail.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String completionCelebration = '/completion-celebration';
  static const String createReminder = '/create-reminder';
  static const String reminderManagement = '/reminder-management';
  static const String audioLibrary = '/audio-library';
  static const String reminderDetail = '/reminder-detail';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const ReminderManagement(),
    completionCelebration: (context) => const CompletionCelebration(),
    createReminder: (context) => const CreateReminder(),
    reminderManagement: (context) => const ReminderManagement(),
    audioLibrary: (context) => const AudioLibrary(),
    reminderDetail: (context) => const ReminderDetail(),
    // TODO: Add your other routes here
  };
}
