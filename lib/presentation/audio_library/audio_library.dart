
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/audio_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/storage_indicator_widget.dart';
import './widgets/upload_bottom_sheet_widget.dart';

class AudioLibrary extends StatefulWidget {
  const AudioLibrary({super.key});

  @override
  State<AudioLibrary> createState() => _AudioLibraryState();
}

class _AudioLibraryState extends State<AudioLibrary>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final AudioRecorder _audioRecorder = AudioRecorder();
  String _searchQuery = '';
  String? _currentlyPlayingId;
  bool _isRecording = false;
  int _currentBottomNavIndex = 1;

  // Mock data for audio files
  final List<Map<String, dynamic>> _audioFiles = [
    {
      "id": "1",
      "filename": "Morning Dua.mp3",
      "duration": "2:45",
      "size": "3.2 MB",
      "uploadDate": "2025-08-25",
      "isFavorite": true,
      "category": "Duas",
      "path": "/storage/audio/morning_dua.mp3",
    },
    {
      "id": "2",
      "filename": "Quran Recitation - Al Fatiha.m4a",
      "duration": "1:30",
      "size": "2.1 MB",
      "uploadDate": "2025-08-24",
      "isFavorite": false,
      "category": "Quran",
      "path": "/storage/audio/al_fatiha.m4a",
    },
    {
      "id": "3",
      "filename": "Call Mom Reminder.mp3",
      "duration": "0:15",
      "size": "0.5 MB",
      "uploadDate": "2025-08-23",
      "isFavorite": false,
      "category": "Personal",
      "path": "/storage/audio/call_mom.mp3",
    },
    {
      "id": "4",
      "filename": "Exercise Motivation.mp3",
      "duration": "3:20",
      "size": "4.8 MB",
      "uploadDate": "2025-08-22",
      "isFavorite": true,
      "category": "Health",
      "path": "/storage/audio/exercise_motivation.mp3",
    },
    {
      "id": "5",
      "filename": "Charity Reminder.m4a",
      "duration": "1:05",
      "size": "1.8 MB",
      "uploadDate": "2025-08-21",
      "isFavorite": false,
      "category": "Charity",
      "path": "/storage/audio/charity_reminder.m4a",
    },
  ];

  List<Map<String, dynamic>> get _filteredAudioFiles {
    if (_searchQuery.isEmpty) {
      return _audioFiles;
    }
    return _audioFiles.where((file) {
      final filename = (file['filename'] as String).toLowerCase();
      final category = (file['category'] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();
      return filename.contains(query) || category.contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllAudioTab(),
                  _buildFavoritesTab(),
                  _buildCategoriesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.colorScheme.surface,
            AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.95),
          ],
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
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Audio Library',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${_audioFiles.length} audio files',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _buildUploadButton(),
            ],
          ),
          SizedBox(height: 2.h),
          SearchBarWidget(
            onChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
            showClearButton: _searchQuery.isNotEmpty,
            onClear: () {
              setState(() {
                _searchQuery = '';
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return GestureDetector(
      onTap: _showUploadBottomSheet,
      child: Container(
        width: 12.w,
        height: 12.w,
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
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: 'add',
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'library_music',
                  size: 16,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                SizedBox(width: 2.w),
                Text('All'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'favorite',
                  size: 16,
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
                SizedBox(width: 2.w),
                Text('Favorites'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'category',
                  size: 16,
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
                SizedBox(width: 2.w),
                Text('Categories'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllAudioTab() {
    if (_filteredAudioFiles.isEmpty && _searchQuery.isNotEmpty) {
      return _buildNoSearchResults();
    }

    if (_audioFiles.isEmpty) {
      return EmptyStateWidget(
        onUploadPressed: _showUploadBottomSheet,
      );
    }

    return Column(
      children: [
        StorageIndicatorWidget(
          usedStorage: 12.4 * 1024 * 1024, // 12.4 MB
          totalStorage: 100 * 1024 * 1024, // 100 MB
          fileCount: _audioFiles.length,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshAudioLibrary,
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 2.h),
              itemCount: _filteredAudioFiles.length,
              itemBuilder: (context, index) {
                final audioFile = _filteredAudioFiles[index];
                return Dismissible(
                  key: Key(audioFile['id'] as String),
                  background: _buildSwipeBackground(isLeft: true),
                  secondaryBackground: _buildSwipeBackground(isLeft: false),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      _deleteAudioFile(audioFile['id'] as String);
                    } else {
                      _toggleFavorite(audioFile['id'] as String);
                    }
                  },
                  child: AudioCardWidget(
                    audioFile: audioFile,
                    isPlaying: _currentlyPlayingId == audioFile['id'],
                    isFavorite: audioFile['isFavorite'] as bool,
                    onPlay: () => _playAudio(audioFile['id'] as String),
                    onPause: () => _pauseAudio(),
                    onDelete: () => _deleteAudioFile(audioFile['id'] as String),
                    onRename: () => _renameAudioFile(audioFile['id'] as String),
                    onSetDefault: () =>
                        _setAsDefault(audioFile['id'] as String),
                    onShare: () => _shareAudioFile(audioFile['id'] as String),
                    onFavorite: () =>
                        _toggleFavorite(audioFile['id'] as String),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesTab() {
    final favoriteFiles =
        _audioFiles.where((file) => file['isFavorite'] as bool).toList();

    if (favoriteFiles.isEmpty) {
      return _buildEmptyFavorites();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      itemCount: favoriteFiles.length,
      itemBuilder: (context, index) {
        final audioFile = favoriteFiles[index];
        return AudioCardWidget(
          audioFile: audioFile,
          isPlaying: _currentlyPlayingId == audioFile['id'],
          isFavorite: true,
          onPlay: () => _playAudio(audioFile['id'] as String),
          onPause: () => _pauseAudio(),
          onDelete: () => _deleteAudioFile(audioFile['id'] as String),
          onRename: () => _renameAudioFile(audioFile['id'] as String),
          onSetDefault: () => _setAsDefault(audioFile['id'] as String),
          onShare: () => _shareAudioFile(audioFile['id'] as String),
          onFavorite: () => _toggleFavorite(audioFile['id'] as String),
        );
      },
    );
  }

  Widget _buildCategoriesTab() {
    final categories = <String, List<Map<String, dynamic>>>{};

    for (final file in _audioFiles) {
      final category = file['category'] as String;
      categories.putIfAbsent(category, () => []).add(file);
    }

    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories.keys.elementAt(index);
        final files = categories[category]!;

        return _buildCategorySection(category, files);
      },
    );
  }

  Widget _buildCategorySection(
      String category, List<Map<String, dynamic>> files) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
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
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
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
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: _getCategoryIcon(category),
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
                        category,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${files.length} ${files.length == 1 ? 'file' : 'files'}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ...files
              .map((file) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: AudioCardWidget(
                      audioFile: file,
                      isPlaying: _currentlyPlayingId == file['id'],
                      isFavorite: file['isFavorite'] as bool,
                      onPlay: () => _playAudio(file['id'] as String),
                      onPause: () => _pauseAudio(),
                      onDelete: () => _deleteAudioFile(file['id'] as String),
                      onRename: () => _renameAudioFile(file['id'] as String),
                      onSetDefault: () => _setAsDefault(file['id'] as String),
                      onShare: () => _shareAudioFile(file['id'] as String),
                      onFavorite: () => _toggleFavorite(file['id'] as String),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isLeft
              ? [
                  AppTheme.errorLight,
                  AppTheme.errorLight.withValues(alpha: 0.8)
                ]
              : [
                  AppTheme.lightTheme.colorScheme.tertiary,
                  AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.8)
                ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'delete' : 'favorite',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeft ? 'Delete' : 'Favorite',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'No results found',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try searching with different keywords or check your spelling.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFavorites() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'favorite_border',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'No Favorites Yet',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Mark audio files as favorites to see them here.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, 'add_circle_outline', 'add_circle', 'Create',
                  '/create-reminder'),
              _buildNavItem(1, 'library_music_outlined', 'library_music',
                  'Audio', '/audio-library'),
              _buildNavItem(2, 'notifications_outlined', 'notifications',
                  'Reminders', '/reminder-management'),
              _buildNavItem(3, 'celebration_outlined', 'celebration',
                  'Progress', '/completion-celebration'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, String icon, String activeIcon, String label, String route) {
    final isSelected = _currentBottomNavIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentBottomNavIndex = index;
        });
        if (route != '/audio-library') {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: isSelected ? activeIcon : icon,
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUploadBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UploadBottomSheetWidget(
        onRecordNew: _recordNewAudio,
        onChooseFromFiles: _chooseFromFiles,
        onBrowseCollection: _browseCollection,
      ),
    );
  }

  Future<void> _recordNewAudio() async {
    try {
      if (!_isRecording) {
        if (await _audioRecorder.hasPermission()) {
          String path;
          if (kIsWeb) {
            path = 'recording.wav';
            await _audioRecorder.start(
                const RecordConfig(encoder: AudioEncoder.wav),
                path: path);
          } else {
            final dir = await getTemporaryDirectory();
            path =
                '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
            await _audioRecorder.start(const RecordConfig(), path: path);
          }

          setState(() {
            _isRecording = true;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Recording started...'),
              action: SnackBarAction(
                label: 'Stop',
                onPressed: _stopRecording,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Microphone permission denied')),
          );
        }
      } else {
        await _stopRecording();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recording failed: Please try again')),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        // Add the recorded file to the library
        final newFile = {
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "filename":
              "Recording_${DateTime.now().day}-${DateTime.now().month}.m4a",
          "duration": "0:30",
          "size": "1.2 MB",
          "uploadDate": DateTime.now().toString().split(' ')[0],
          "isFavorite": false,
          "category": "Personal",
          "path": path,
        };

        setState(() {
          _audioFiles.insert(0, newFile);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recording saved successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save recording')),
      );
    }
  }

  Future<void> _chooseFromFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'm4a', 'wav'],
        allowMultiple: true,
      );

      if (result != null) {
        for (final file in result.files) {
          final newFile = {
            "id": DateTime.now().millisecondsSinceEpoch.toString(),
            "filename": file.name,
            "duration": "Unknown",
            "size": _formatFileSize(file.size ?? 0),
            "uploadDate": DateTime.now().toString().split(' ')[0],
            "isFavorite": false,
            "category": "Uploaded",
            "path": kIsWeb ? "web_file_${file.name}" : file.path ?? "",
          };

          setState(() {
            _audioFiles.insert(0, newFile);
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${result.files.length} file(s) uploaded successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File upload failed: Please try again')),
      );
    }
  }

  void _browseCollection() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Islamic audio collection coming soon!')),
    );
  }

  Future<void> _refreshAudioLibrary() async {
    await Future.delayed(Duration(seconds: 1));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Audio library refreshed')),
    );
  }

  void _playAudio(String audioId) {
    setState(() {
      _currentlyPlayingId = audioId;
    });

    final audioFile = _audioFiles.firstWhere((file) => file['id'] == audioId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing: ${audioFile['filename']}')),
    );
  }

  void _pauseAudio() {
    setState(() {
      _currentlyPlayingId = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Audio paused')),
    );
  }

  void _deleteAudioFile(String audioId) {
    final audioFile = _audioFiles.firstWhere((file) => file['id'] == audioId);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Audio File'),
        content:
            Text('Are you sure you want to delete "${audioFile['filename']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _audioFiles.removeWhere((file) => file['id'] == audioId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Audio file deleted')),
              );
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _renameAudioFile(String audioId) {
    final audioFile = _audioFiles.firstWhere((file) => file['id'] == audioId);
    final controller =
        TextEditingController(text: audioFile['filename'] as String);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename Audio File'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'New filename',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  audioFile['filename'] = controller.text;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Audio file renamed')),
                );
              }
            },
            child: Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _setAsDefault(String audioId) {
    final audioFile = _audioFiles.firstWhere((file) => file['id'] == audioId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              '${audioFile['filename']} set as default notification sound')),
    );
  }

  void _shareAudioFile(String audioId) {
    final audioFile = _audioFiles.firstWhere((file) => file['id'] == audioId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${audioFile['filename']}')),
    );
  }

  void _toggleFavorite(String audioId) {
    setState(() {
      final audioFile = _audioFiles.firstWhere((file) => file['id'] == audioId);
      audioFile['isFavorite'] = !(audioFile['isFavorite'] as bool);
    });

    final audioFile = _audioFiles.firstWhere((file) => file['id'] == audioId);
    final isFavorite = audioFile['isFavorite'] as bool;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(isFavorite ? 'Added to favorites' : 'Removed from favorites'),
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'duas':
        return 'favorite';
      case 'quran':
        return 'menu_book';
      case 'personal':
        return 'person';
      case 'health':
        return 'fitness_center';
      case 'charity':
        return 'volunteer_activism';
      case 'uploaded':
        return 'cloud_upload';
      default:
        return 'folder';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '${bytes} B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}
