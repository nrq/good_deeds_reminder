import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget implementing Islamic minimalism design principles
/// with contextual actions and adaptive behavior for spiritual applications
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Whether to show the back button (automatically determined if not specified)
  final bool? showBackButton;

  /// Custom leading widget (overrides back button if provided)
  final Widget? leading;

  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Whether to show elevation shadow
  final bool showElevation;

  /// Background color override (uses theme color if not specified)
  final Color? backgroundColor;

  /// Text color override (uses theme color if not specified)
  final Color? foregroundColor;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom bottom widget (for tabs, progress indicators, etc.)
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton,
    this.leading,
    this.actions,
    this.showElevation = true,
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? theme.appBarTheme.foregroundColor,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: showElevation ? 2.0 : 0.0,
      shadowColor: theme.colorScheme.shadow,
      leading: leading ??
          ((showBackButton ?? canPop) ? _buildBackButton(context) : null),
      actions: actions ?? _buildDefaultActions(context),
      bottom: bottom,
      automaticallyImplyLeading: false,
    );
  }

  /// Builds the back button with Islamic design principles
  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 20,
      ),
      tooltip: 'Back',
      splashRadius: 20,
    );
  }

  /// Builds default actions based on current route context
  List<Widget>? _buildDefaultActions(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    switch (currentRoute) {
      case '/create-reminder':
        return [
          IconButton(
            onPressed: () =>
                _showHelpBottomSheet(context, 'Create Reminder Help'),
            icon: Icon(Icons.help_outline_rounded, size: 20),
            tooltip: 'Help',
            splashRadius: 20,
          ),
        ];

      case '/audio-library':
        return [
          IconButton(
            onPressed: () => _showSearchBottomSheet(context),
            icon: Icon(Icons.search_rounded, size: 20),
            tooltip: 'Search Audio',
            splashRadius: 20,
          ),
          IconButton(
            onPressed: () => _showFilterBottomSheet(context),
            icon: Icon(Icons.filter_list_rounded, size: 20),
            tooltip: 'Filter',
            splashRadius: 20,
          ),
        ];

      case '/reminder-management':
        return [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/create-reminder'),
            icon: Icon(Icons.add_rounded, size: 20),
            tooltip: 'Add Reminder',
            splashRadius: 20,
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'sort',
                child: Row(
                  children: [
                    Icon(Icons.sort_rounded, size: 16),
                    SizedBox(width: 8),
                    Text('Sort'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_rounded, size: 16),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
            icon: Icon(Icons.more_vert_rounded, size: 20),
            tooltip: 'More options',
          ),
        ];

      default:
        return null;
    }
  }

  /// Shows contextual help bottom sheet
  void _showHelpBottomSheet(BuildContext context, String helpTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.help_outline_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 12),
                Text(
                  helpTitle,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'This feature helps you create meaningful reminders for your spiritual journey. Set custom times, choose audio recitations, and build consistent habits.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Got it'),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  /// Shows search bottom sheet for audio library
  void _showSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search audio files...',
                prefixIcon: Icon(Icons.search_rounded),
                suffixIcon: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_rounded),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  /// Shows filter bottom sheet for audio library
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Audio',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.access_time_rounded),
              title: Text('Duration'),
              trailing: Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(context);
                // Handle duration filter
              },
            ),
            ListTile(
              leading: Icon(Icons.category_rounded),
              title: Text('Category'),
              trailing: Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(context);
                // Handle category filter
              },
            ),
            ListTile(
              leading: Icon(Icons.person_rounded),
              title: Text('Reciter'),
              trailing: Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(context);
                // Handle reciter filter
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Reset'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Handles popup menu actions
  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'sort':
        _showSortBottomSheet(context);
        break;
      case 'settings':
        // Navigate to settings or show settings bottom sheet
        break;
    }
  }

  /// Shows sort options bottom sheet
  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort Reminders',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.schedule_rounded),
              title: Text('By Time'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.date_range_rounded),
              title: Text('By Date Created'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.abc_rounded),
              title: Text('Alphabetically'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.priority_high_rounded),
              title: Text('By Priority'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}
