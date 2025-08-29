import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/reminder_section_widget.dart';
import './widgets/search_filter_widget.dart';

class ReminderManagement extends StatefulWidget {
  const ReminderManagement({super.key});

  @override
  State<ReminderManagement> createState() => _ReminderManagementState();
}

class _ReminderManagementState extends State<ReminderManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Search and filter state
  String _searchQuery = '';
  List<String> _selectedCategories = [];
  List<String> _selectedStatuses = [];
  List<String> _selectedFrequencies = [];

  // Section expansion state
  bool _isActiveExpanded = true;
  bool _isPausedExpanded = false;
  bool _isCompletedExpanded = false;

  // Multi-select state
  bool _isMultiSelectMode = false;
  Set<int> _selectedReminderIds = {};

  // Mock data for reminders
  final List<Map<String, dynamic>> _allReminders = [
    {
      "id": 1,
      "title": "Call Mom",
      "category": "family",
      "frequency": "daily",
      "status": "active",
      "nextOccurrence": "Today at 7:00 PM",
      "audioFile": "family_reminder.mp3",
      "createdAt": DateTime.now().subtract(Duration(days: 5)),
      "completionCount": 12,
      "description": "Remember to call mom and check how she's doing",
    },
    {
      "id": 2,
      "title": "Give Charity",
      "category": "charity",
      "frequency": "weekly",
      "status": "active",
      "nextOccurrence": "Friday at 2:00 PM",
      "audioFile": "charity_reminder.mp3",
      "createdAt": DateTime.now().subtract(Duration(days: 10)),
      "completionCount": 3,
      "description": "Weekly charity donation to help those in need",
    },
    {
      "id": 3,
      "title": "Morning Exercise",
      "category": "health",
      "frequency": "daily",
      "status": "paused",
      "nextOccurrence": "Paused",
      "audioFile": null,
      "createdAt": DateTime.now().subtract(Duration(days: 15)),
      "completionCount": 8,
      "description": "30 minutes of morning exercise routine",
    },
    {
      "id": 4,
      "title": "Read Quran",
      "category": "spiritual",
      "frequency": "daily",
      "status": "active",
      "nextOccurrence": "Tomorrow at 6:00 AM",
      "audioFile": "quran_reminder.mp3",
      "createdAt": DateTime.now().subtract(Duration(days: 20)),
      "completionCount": 18,
      "description": "Daily Quran reading and reflection",
    },
    {
      "id": 5,
      "title": "Computer Break",
      "category": "health",
      "frequency": "hourly",
      "status": "active",
      "nextOccurrence": "In 45 minutes",
      "audioFile": "break_reminder.mp3",
      "createdAt": DateTime.now().subtract(Duration(days: 3)),
      "completionCount": 25,
      "description": "Take a 5-minute break from computer work",
    },
    {
      "id": 6,
      "title": "Team Meeting Prep",
      "category": "work",
      "frequency": "weekly",
      "status": "completed",
      "nextOccurrence": "Completed",
      "audioFile": null,
      "createdAt": DateTime.now().subtract(Duration(days: 7)),
      "completionCount": 1,
      "description": "Prepare agenda and materials for weekly team meeting",
    },
    {
      "id": 7,
      "title": "Gratitude Journal",
      "category": "personal",
      "frequency": "daily",
      "status": "paused",
      "nextOccurrence": "Paused",
      "audioFile": "gratitude_reminder.mp3",
      "createdAt": DateTime.now().subtract(Duration(days: 12)),
      "completionCount": 5,
      "description": "Write three things I'm grateful for today",
    },
    {
      "id": 8,
      "title": "Dhikr After Salah",
      "category": "spiritual",
      "frequency": "daily",
      "status": "completed",
      "nextOccurrence": "Completed",
      "audioFile": "dhikr_reminder.mp3",
      "createdAt": DateTime.now().subtract(Duration(days: 30)),
      "completionCount": 25,
      "description": "Remember Allah through dhikr after each prayer",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredReminders {
    return _allReminders.where((reminder) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final title = (reminder["title"] as String).toLowerCase();
        final category = (reminder["category"] as String).toLowerCase();
        final description = (reminder["description"] as String).toLowerCase();

        if (!title.contains(query) &&
            !category.contains(query) &&
            !description.contains(query)) {
          return false;
        }
      }

      // Category filter
      if (_selectedCategories.isNotEmpty &&
          !_selectedCategories.contains(reminder["category"])) {
        return false;
      }

      // Status filter
      if (_selectedStatuses.isNotEmpty &&
          !_selectedStatuses.contains(reminder["status"])) {
        return false;
      }

      // Frequency filter
      if (_selectedFrequencies.isNotEmpty &&
          !_selectedFrequencies.contains(reminder["frequency"])) {
        return false;
      }

      return true;
    }).toList();
  }

  List<Map<String, dynamic>> get _activeReminders {
    return _filteredReminders
        .where((r) => (r["status"] as String) == "active")
        .toList();
  }

  List<Map<String, dynamic>> get _pausedReminders {
    return _filteredReminders
        .where((r) => (r["status"] as String) == "paused")
        .toList();
  }

  List<Map<String, dynamic>> get _completedReminders {
    return _filteredReminders
        .where((r) => (r["status"] as String) == "completed")
        .toList();
  }

  int get _activeReminderCount {
    return _allReminders
        .where((r) => (r["status"] as String) == "active")
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SearchFilterWidget(
                searchQuery: _searchQuery,
                selectedCategories: _selectedCategories,
                selectedStatuses: _selectedStatuses,
                selectedFrequencies: _selectedFrequencies,
                onSearchChanged: (query) =>
                    setState(() => _searchQuery = query),
                onCategoriesChanged: (categories) =>
                    setState(() => _selectedCategories = categories),
                onStatusesChanged: (statuses) =>
                    setState(() => _selectedStatuses = statuses),
                onFrequenciesChanged: (frequencies) =>
                    setState(() => _selectedFrequencies = frequencies),
                onClearAll: _clearAllFilters,
              ),
            ),
            if (_isMultiSelectMode) ...[
              SliverToBoxAdapter(child: _buildMultiSelectActions(context)),
            ],
            SliverList(
              delegate: SliverChildListDelegate([
                ReminderSectionWidget(
                  title: 'Active',
                  reminders: _activeReminders,
                  isExpanded: _isActiveExpanded,
                  onToggleExpanded: () =>
                      setState(() => _isActiveExpanded = !_isActiveExpanded),
                  onReminderTap: _handleReminderTap,
                  onReminderToggle: _handleReminderToggle,
                  onReminderEdit: _handleReminderEdit,
                  onReminderDuplicate: _handleReminderDuplicate,
                  onReminderShare: _handleReminderShare,
                  onReminderPause: _handleReminderPause,
                  onReminderDelete: _handleReminderDelete,
                  onReminderViewHistory: _handleReminderViewHistory,
                  onReminderChangeAudio: _handleReminderChangeAudio,
                  onReminderResetProgress: _handleReminderResetProgress,
                ),
                SizedBox(height: 1.h),
                ReminderSectionWidget(
                  title: 'Paused',
                  reminders: _pausedReminders,
                  isExpanded: _isPausedExpanded,
                  onToggleExpanded: () =>
                      setState(() => _isPausedExpanded = !_isPausedExpanded),
                  onReminderTap: _handleReminderTap,
                  onReminderToggle: _handleReminderToggle,
                  onReminderEdit: _handleReminderEdit,
                  onReminderDuplicate: _handleReminderDuplicate,
                  onReminderShare: _handleReminderShare,
                  onReminderPause: _handleReminderPause,
                  onReminderDelete: _handleReminderDelete,
                  onReminderViewHistory: _handleReminderViewHistory,
                  onReminderChangeAudio: _handleReminderChangeAudio,
                  onReminderResetProgress: _handleReminderResetProgress,
                ),
                SizedBox(height: 1.h),
                ReminderSectionWidget(
                  title: 'Completed',
                  reminders: _completedReminders,
                  isExpanded: _isCompletedExpanded,
                  onToggleExpanded: () => setState(
                      () => _isCompletedExpanded = !_isCompletedExpanded),
                  onReminderTap: _handleReminderTap,
                  onReminderToggle: _handleReminderToggle,
                  onReminderEdit: _handleReminderEdit,
                  onReminderDuplicate: _handleReminderDuplicate,
                  onReminderShare: _handleReminderShare,
                  onReminderPause: _handleReminderPause,
                  onReminderDelete: _handleReminderDelete,
                  onReminderViewHistory: _handleReminderViewHistory,
                  onReminderChangeAudio: _handleReminderChangeAudio,
                  onReminderResetProgress: _handleReminderResetProgress,
                ),
                SizedBox(height: 10.h), // Bottom padding for navigation
              ]),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        _isMultiSelectMode
            ? '${_selectedReminderIds.length} selected'
            : 'Reminders',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: !_isMultiSelectMode,
      leading: _isMultiSelectMode
          ? IconButton(
              onPressed: _exitMultiSelectMode,
              icon: CustomIconWidget(
                iconName: 'close',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
            )
          : null,
      actions: _isMultiSelectMode
          ? [
              IconButton(
                onPressed:
                    _selectedReminderIds.length == _filteredReminders.length
                        ? _deselectAllReminders
                        : _selectAllReminders,
                icon: CustomIconWidget(
                  iconName:
                      _selectedReminderIds.length == _filteredReminders.length
                          ? 'deselect'
                          : 'select_all',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
                tooltip:
                    _selectedReminderIds.length == _filteredReminders.length
                        ? 'Deselect All'
                        : 'Select All',
              ),
            ]
          : [
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/create-reminder'),
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
                tooltip: 'Add Reminder',
              ),
              PopupMenuButton<String>(
                onSelected: _handleMenuAction,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'sort',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'sort',
                          color: theme.colorScheme.onSurface,
                          size: 16,
                        ),
                        SizedBox(width: 3.w),
                        Text('Sort'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'export',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'download',
                          color: theme.colorScheme.onSurface,
                          size: 16,
                        ),
                        SizedBox(width: 3.w),
                        Text('Export'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'settings',
                          color: theme.colorScheme.onSurface,
                          size: 16,
                        ),
                        SizedBox(width: 3.w),
                        Text('Settings'),
                      ],
                    ),
                  ),
                ],
                icon: CustomIconWidget(
                  iconName: 'more_vert',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
            ],
      backgroundColor: theme.colorScheme.surface,
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.1),
    );
  }

  Widget _buildMultiSelectActions(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed:
                  _selectedReminderIds.isNotEmpty ? _bulkPauseReminders : null,
              icon: CustomIconWidget(
                iconName: 'pause',
                color: theme.colorScheme.onPrimary,
                size: 16,
              ),
              label: Text('Pause'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.warningLight,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _selectedReminderIds.isNotEmpty
                  ? _bulkActivateReminders
                  : null,
              icon: CustomIconWidget(
                iconName: 'play_arrow',
                color: theme.colorScheme.onPrimary,
                size: 16,
              ),
              label: Text('Activate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.successLight,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: ElevatedButton.icon(
              onPressed:
                  _selectedReminderIds.isNotEmpty ? _bulkDeleteReminders : null,
              icon: CustomIconWidget(
                iconName: 'delete',
                color: theme.colorScheme.onPrimary,
                size: 16,
              ),
              label: Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton.extended(
      onPressed: () => Navigator.pushNamed(context, '/create-reminder'),
      icon: CustomIconWidget(
        iconName: 'add',
        color: theme.colorScheme.onPrimary,
        size: 24,
      ),
      label: Text(
        'New Reminder',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: theme.colorScheme.primary,
      elevation: 4,
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surface.withValues(alpha: 0.95),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(
                context,
                'add_circle_outline',
                'add_circle',
                'Create',
                '/create-reminder',
                0,
              ),
              _buildBottomNavItem(
                context,
                'library_music_outlined',
                'library_music',
                'Audio',
                '/audio-library',
                1,
              ),
              _buildBottomNavItem(
                context,
                'notifications_outlined',
                'notifications',
                'Reminders',
                '/reminder-management',
                2,
                badge: _activeReminderCount > 0
                    ? _activeReminderCount.toString()
                    : null,
              ),
              _buildBottomNavItem(
                context,
                'celebration_outlined',
                'celebration',
                'Progress',
                '/completion-celebration',
                3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
    BuildContext context,
    String icon,
    String activeIcon,
    String label,
    String route,
    int index, {
    String? badge,
  }) {
    final theme = Theme.of(context);
    final isSelected = route == '/reminder-management';

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (route != '/reminder-management') {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomIconWidget(
                    iconName: isSelected ? activeIcon : icon,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  if (badge != null)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.5.w, vertical: 0.3.h),
                        decoration: BoxDecoration(
                          color: AppTheme.errorLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints:
                            BoxConstraints(minWidth: 20, minHeight: 20),
                        child: Text(
                          badge,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Event handlers
  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // Simulate refreshing reminder schedules
    });
  }

  void _clearAllFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCategories.clear();
      _selectedStatuses.clear();
      _selectedFrequencies.clear();
    });
  }

  void _handleReminderTap(Map<String, dynamic> reminder) {
    if (_isMultiSelectMode) {
      _toggleReminderSelection(reminder["id"] as int);
    } else {
      Navigator.pushNamed(
        context,
        '/reminder-detail',
        arguments: reminder,
      );
    }
  }

  void _handleReminderToggle(Map<String, dynamic> reminder) {
    setState(() {
      final currentStatus = reminder["status"] as String;
      reminder["status"] = currentStatus == "active" ? "paused" : "active";
      if (reminder["status"] == "active") {
        reminder["nextOccurrence"] = "In 1 hour"; // Mock next occurrence
      } else {
        reminder["nextOccurrence"] = "Paused";
      }
    });
  }

  void _handleReminderEdit(Map<String, dynamic> reminder) {
    Navigator.pushNamed(
      context,
      '/create-reminder',
      arguments: {'editMode': true, 'reminder': reminder},
    );
  }

  void _handleReminderDuplicate(Map<String, dynamic> reminder) {
    setState(() {
      final newReminder = Map<String, dynamic>.from(reminder);
      newReminder["id"] = _allReminders.length + 1;
      newReminder["title"] = "${reminder["title"]} (Copy)";
      newReminder["createdAt"] = DateTime.now();
      newReminder["completionCount"] = 0;
      _allReminders.add(newReminder);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder duplicated successfully'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _handleReminderShare(Map<String, dynamic> reminder) {
    final shareText = '''
Good Deeds Reminder: ${reminder["title"]}
Category: ${reminder["category"]}
Frequency: ${reminder["frequency"]}
Description: ${reminder["description"]}

Shared from Good Deeds Reminder App
''';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder shared successfully'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _handleReminderPause(Map<String, dynamic> reminder) {
    setState(() {
      reminder["status"] = reminder["status"] == "paused" ? "active" : "paused";
      reminder["nextOccurrence"] =
          reminder["status"] == "paused" ? "Paused" : "In 1 hour";
    });
  }

  void _handleReminderDelete(Map<String, dynamic> reminder) {
    setState(() {
      _allReminders.removeWhere((r) => r["id"] == reminder["id"]);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder deleted'),
        backgroundColor: AppTheme.errorLight,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _allReminders.add(reminder);
            });
          },
        ),
      ),
    );
  }

  void _handleReminderViewHistory(Map<String, dynamic> reminder) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
              ],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 2.h),
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Text(
                  'Completion History',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.all(6.w),
                  itemCount: reminder["completionCount"] as int,
                  itemBuilder: (context, index) {
                    final date = DateTime.now().subtract(Duration(days: index));
                    return ListTile(
                      leading: CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.successLight,
                        size: 24,
                      ),
                      title: Text('Completed'),
                      subtitle: Text('${date.day}/${date.month}/${date.year}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleReminderChangeAudio(Map<String, dynamic> reminder) {
    Navigator.pushNamed(context, '/audio-library');
  }

  void _handleReminderResetProgress(Map<String, dynamic> reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Progress'),
        content: Text(
            'Are you sure you want to reset the completion progress for "${reminder["title"]}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                reminder["completionCount"] = 0;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Progress reset successfully'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'sort':
        _showSortOptions();
        break;
      case 'export':
        _exportReminders();
        break;
      case 'settings':
        _showSettings();
        break;
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort Reminders',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'schedule',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('By Next Occurrence'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'date_range',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('By Date Created'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'abc',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('Alphabetically'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'trending_up',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('By Completion Count'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _exportReminders() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminders exported successfully'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _showSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings feature coming soon'),
        backgroundColor: AppTheme.warningLight,
      ),
    );
  }

  // Multi-select methods
  void _toggleReminderSelection(int reminderId) {
    setState(() {
      if (_selectedReminderIds.contains(reminderId)) {
        _selectedReminderIds.remove(reminderId);
        if (_selectedReminderIds.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedReminderIds.add(reminderId);
        _isMultiSelectMode = true;
      }
    });
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedReminderIds.clear();
    });
  }

  void _selectAllReminders() {
    setState(() {
      _selectedReminderIds =
          _filteredReminders.map((r) => r["id"] as int).toSet();
    });
  }

  void _deselectAllReminders() {
    setState(() {
      _selectedReminderIds.clear();
    });
  }

  void _bulkPauseReminders() {
    setState(() {
      for (final reminder in _allReminders) {
        if (_selectedReminderIds.contains(reminder["id"])) {
          reminder["status"] = "paused";
          reminder["nextOccurrence"] = "Paused";
        }
      }
    });
    _exitMultiSelectMode();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedReminderIds.length} reminders paused'),
        backgroundColor: AppTheme.warningLight,
      ),
    );
  }

  void _bulkActivateReminders() {
    setState(() {
      for (final reminder in _allReminders) {
        if (_selectedReminderIds.contains(reminder["id"])) {
          reminder["status"] = "active";
          reminder["nextOccurrence"] = "In 1 hour";
        }
      }
    });
    _exitMultiSelectMode();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedReminderIds.length} reminders activated'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _bulkDeleteReminders() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Reminders'),
        content: Text(
            'Are you sure you want to delete ${_selectedReminderIds.length} selected reminders?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allReminders
                    .removeWhere((r) => _selectedReminderIds.contains(r["id"]));
              });
              _exitMultiSelectMode();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('${_selectedReminderIds.length} reminders deleted'),
                  backgroundColor: AppTheme.errorLight,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
