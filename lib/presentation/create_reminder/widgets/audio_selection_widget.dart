import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

import '../../../core/app_export.dart';

class AudioSelectionWidget extends StatefulWidget {
  final Map<String, dynamic>? selectedAudio;
  final Function(Map<String, dynamic>) onAudioSelected;

  const AudioSelectionWidget({
    super.key,
    this.selectedAudio,
    required this.onAudioSelected,
  });

  @override
  State<AudioSelectionWidget> createState() => _AudioSelectionWidgetState();
}

class _AudioSelectionWidgetState extends State<AudioSelectionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  bool _isPlaying = false;

  final List<Map<String, dynamic>> defaultAudios = [
    {
      'id': 'default_1',
      'name': 'Gentle Reminder',
      'duration': '0:15',
      'type': 'default',
      'description': 'Soft chime with Islamic greeting',
    },
    {
      'id': 'default_2',
      'name': 'Quran Recitation',
      'duration': '0:30',
      'type': 'default',
      'description': 'Beautiful Quranic verse recitation',
    },
    {
      'id': 'default_3',
      'name': 'Dhikr Bell',
      'duration': '0:10',
      'type': 'default',
      'description': 'Traditional Islamic bell sound',
    },
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Audio Notification',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        _buildCurrentSelection(),
        SizedBox(height: 3.h),
        _buildDefaultAudios(),
        SizedBox(height: 3.h),
        _buildCustomAudioSection(),
      ],
    );
  }

  Widget _buildCurrentSelection() {
    if (widget.selectedAudio == null) {
      return _buildSelectAudioButton();
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary,
          width: 2,
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
          GestureDetector(
            onTap: _togglePlayback,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: _isPlaying ? 'pause' : 'play_arrow',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.selectedAudio!['name'] ?? 'Selected Audio',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      widget.selectedAudio!['duration'] ?? '0:00',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    if (_isPlaying) _buildWaveform(),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showAudioLibrary(),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'library_music',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectAudioButton() {
    return GestureDetector(
      onTap: () => _showAudioLibrary(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
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
              iconName: 'music_note',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Select Audio Notification',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
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

  Widget _buildDefaultAudios() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Default Audio Options',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        ...defaultAudios.map((audio) => _buildAudioOption(audio)),
      ],
    );
  }

  Widget _buildAudioOption(Map<String, dynamic> audio) {
    final isSelected = widget.selectedAudio?['id'] == audio['id'];

    return GestureDetector(
      onTap: () => widget.onAudioSelected(audio),
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'music_note',
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    audio['name'],
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    audio['description'],
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              audio['duration'],
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(width: 2.w),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAudioSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'upload_file',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Upload Custom Audio',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Upload your own MP3 audio file for personalized notifications',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _uploadCustomAudio,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              label: Text('Choose File'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveform() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Row(
          children: List.generate(5, (index) {
            final delay = index * 0.2;
            final animationValue = (_waveController.value + delay) % 1.0;
            final height = 2 + (sin(animationValue * 2 * pi) * 2);

            return Container(
              width: 1.w,
              height: height.toDouble(),
              margin: EdgeInsets.only(right: 0.5.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(0.5.w),
              ),
            );
          }),
        );
      },
    );
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _waveController.repeat();
      } else {
        _waveController.stop();
      }
    });

    // Simulate audio playback duration
    if (_isPlaying) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isPlaying = false;
            _waveController.stop();
          });
        }
      });
    }
  }

  void _showAudioLibrary() {
    Navigator.pushNamed(context, '/audio-library');
  }

  void _uploadCustomAudio() {
    // Simulate file picker
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upload Audio'),
        content: Text(
            'File picker functionality will be implemented here. Users can select MP3 files from their device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Simulate successful upload
              widget.onAudioSelected({
                'id': 'custom_${DateTime.now().millisecondsSinceEpoch}',
                'name': 'My Custom Audio.mp3',
                'duration': '1:23',
                'type': 'custom',
                'description': 'Custom uploaded audio file',
              });
            },
            child: Text('Upload'),
          ),
        ],
      ),
    );
  }
}