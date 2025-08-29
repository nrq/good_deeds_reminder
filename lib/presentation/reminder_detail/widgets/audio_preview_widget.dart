import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AudioPreviewWidget extends StatefulWidget {
  final Map<String, dynamic>? audioFile;
  final VoidCallback? onPlayPause;
  final VoidCallback? onChangeAudio;

  const AudioPreviewWidget({
    super.key,
    this.audioFile,
    this.onPlayPause,
    this.onChangeAudio,
  });

  @override
  State<AudioPreviewWidget> createState() => _AudioPreviewWidgetState();
}

class _AudioPreviewWidgetState extends State<AudioPreviewWidget>
    with TickerProviderStateMixin {
  bool _isPlaying = false;
  double _currentPosition = 0.0;
  double _volume = 0.7;
  late AnimationController _waveAnimationController;
  late AnimationController _playButtonController;

  @override
  void initState() {
    super.initState();
    _waveAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _playButtonController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _waveAnimationController.dispose();
    _playButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.audioFile == null) {
      return _buildNoAudioState();
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'audiotrack',
                color: AppTheme.audioBlue,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Audio Preview',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: widget.onChangeAudio,
                child: Text('Change'),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.audioBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
              border: Border.all(
                color: AppTheme.audioBlue.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'music_note',
                      color: AppTheme.audioBlue,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.audioFile!["name"] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${widget.audioFile!["duration"] ?? "0:00"} • ${widget.audioFile!["size"] ?? "0 MB"}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(color: AppTheme.textSecondaryLight),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                _buildWaveform(),
                SizedBox(height: 3.h),
                _buildAudioControls(),
                SizedBox(height: 2.h),
                _buildVolumeControl(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoAudioState() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'audiotrack',
                color: AppTheme.textDisabledLight,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'No Audio Assigned',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
              border: Border.all(
                color: AppTheme.dividerLight,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: 'library_music',
                  color: AppTheme.textDisabledLight,
                  size: 12.w,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Add an audio file to play when this reminder triggers',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 3.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: widget.onChangeAudio,
                    icon: CustomIconWidget(
                      iconName: 'add',
                      color: Colors.white,
                      size: 5.w,
                    ),
                    label: Text('Add Audio File'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveform() {
    return Container(
      height: 8.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(20, (index) {
          return AnimatedBuilder(
            animation: _waveAnimationController,
            builder: (context, child) {
              final height = (index % 4 + 1) * 1.5.h;
              final animatedHeight =
                  _isPlaying
                      ? height *
                          (0.3 +
                              0.7 *
                                  (1 +
                                          sin(
                                            index * 0.1 -
                                                _waveAnimationController.value,
                                          ))
                                      .abs())
                      : height * 0.3;

              return Container(
                width: 0.8.w,
                height: animatedHeight,
                decoration: BoxDecoration(
                  color:
                      index <= (_currentPosition * 20).floor()
                          ? AppTheme.audioBlue
                          : AppTheme.audioBlue.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildAudioControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => _seekBackward(),
          icon: CustomIconWidget(
            iconName: 'replay_10',
            color: AppTheme.audioBlue,
            size: 6.w,
          ),
          tooltip: 'Rewind 10 seconds',
        ),
        SizedBox(width: 4.w),
        GestureDetector(
          onTap: _togglePlayPause,
          child: AnimatedBuilder(
            animation: _playButtonController,
            builder: (context, child) {
              return Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  color: AppTheme.audioBlue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.audioBlue.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Transform.scale(
                  scale: 1.0 - (_playButtonController.value * 0.1),
                  child: CustomIconWidget(
                    iconName: _isPlaying ? 'pause' : 'play_arrow',
                    color: Colors.white,
                    size: 8.w,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(width: 4.w),
        IconButton(
          onPressed: () => _seekForward(),
          icon: CustomIconWidget(
            iconName: 'forward_10',
            color: AppTheme.audioBlue,
            size: 6.w,
          ),
          tooltip: 'Forward 10 seconds',
        ),
      ],
    );
  }

  Widget _buildVolumeControl() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'volume_down',
          color: AppTheme.textSecondaryLight,
          size: 5.w,
        ),
        Expanded(
          child: Slider(
            value: _volume,
            onChanged: (value) {
              setState(() {
                _volume = value;
              });
            },
            activeColor: AppTheme.audioBlue,
            inactiveColor: AppTheme.audioBlue.withValues(alpha: 0.3),
          ),
        ),
        CustomIconWidget(
          iconName: 'volume_up',
          color: AppTheme.textSecondaryLight,
          size: 5.w,
        ),
      ],
    );
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    _playButtonController.forward().then((_) {
      _playButtonController.reverse();
    });

    if (_isPlaying) {
      _waveAnimationController.repeat();
    } else {
      _waveAnimationController.stop();
    }

    widget.onPlayPause?.call();
  }

  void _seekBackward() {
    setState(() {
      _currentPosition = (_currentPosition - 0.1).clamp(0.0, 1.0);
    });
  }

  void _seekForward() {
    setState(() {
      _currentPosition = (_currentPosition + 0.1).clamp(0.0, 1.0);
    });
  }
}
