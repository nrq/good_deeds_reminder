import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AudioCardWidget extends StatefulWidget {
  final Map<String, dynamic> audioFile;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onDelete;
  final VoidCallback onRename;
  final VoidCallback onSetDefault;
  final VoidCallback onShare;
  final VoidCallback onFavorite;
  final bool isPlaying;
  final bool isFavorite;

  const AudioCardWidget({
    super.key,
    required this.audioFile,
    required this.onPlay,
    required this.onPause,
    required this.onDelete,
    required this.onRename,
    required this.onSetDefault,
    required this.onShare,
    required this.onFavorite,
    this.isPlaying = false,
    this.isFavorite = false,
  });

  @override
  State<AudioCardWidget> createState() => _AudioCardWidgetState();
}

class _AudioCardWidgetState extends State<AudioCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onLongPress: () => _showContextMenu(context),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightTheme.colorScheme.surface,
                    AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow
                        .withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainContent(),
                    if (_isExpanded) ...[
                      SizedBox(height: 2.h),
                      _buildExpandedPlayer(),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent() {
    return Row(
      children: [
        _buildPlayButton(),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.audioFile['filename'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.isFavorite)
                    CustomIconWidget(
                      iconName: 'favorite',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 16,
                    ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'access_time',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    widget.audioFile['duration'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                  SizedBox(width: 4.w),
                  CustomIconWidget(
                    iconName: 'folder_open',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    widget.audioFile['size'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildWaveformPreview(),
      ],
    );
  }

  Widget _buildPlayButton() {
    return GestureDetector(
      onTap: widget.isPlaying ? widget.onPause : widget.onPlay,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 12.w,
        height: 12.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.isPlaying
                ? [
                    AppTheme.lightTheme.colorScheme.tertiary,
                    AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.8),
                  ]
                : [
                    AppTheme.lightTheme.colorScheme.primary,
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.8),
                  ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (widget.isPlaying
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.primary)
                  .withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: CustomIconWidget(
              key: ValueKey(widget.isPlaying),
              iconName: widget.isPlaying ? 'pause' : 'play_arrow',
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWaveformPreview() {
    return Container(
      width: 15.w,
      height: 6.h,
      child: CustomPaint(
        painter: WaveformPainter(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.6),
          isAnimating: widget.isPlaying,
        ),
      ),
    );
  }

  Widget _buildExpandedPlayer() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
      ),
      child: Column(
        children: [
          _buildProgressBar(),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton('volume_up', () {}),
              _buildControlButton('replay_10', () {}),
              _buildControlButton('forward_10', () {}),
              _buildControlButton('loop', () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
            activeTrackColor: AppTheme.lightTheme.colorScheme.primary,
            inactiveTrackColor:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            thumbColor: AppTheme.lightTheme.colorScheme.primary,
          ),
          child: Slider(
            value: 0.3,
            onChanged: (value) {},
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1:23',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            Text(
              widget.audioFile['duration'] as String,
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlButton(String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 18,
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppTheme.extraLargeRadius)),
        ),
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            _buildContextMenuItem('edit', 'Rename', widget.onRename),
            _buildContextMenuItem('delete', 'Delete', widget.onDelete),
            _buildContextMenuItem(
                'star', 'Set as Default', widget.onSetDefault),
            _buildContextMenuItem('share', 'Share', widget.onShare),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
      String iconName, String title, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 20,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}

class WaveformPainter extends CustomPainter {
  final Color color;
  final bool isAnimating;

  WaveformPainter({required this.color, this.isAnimating = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / 20;
    final heights = [
      0.3,
      0.7,
      0.5,
      0.9,
      0.4,
      0.8,
      0.6,
      0.2,
      0.9,
      0.5,
      0.7,
      0.3,
      0.8,
      0.4,
      0.6,
      0.9,
      0.2,
      0.7,
      0.5,
      0.8
    ];

    for (int i = 0; i < heights.length; i++) {
      final x = i * barWidth + barWidth / 2;
      final barHeight = size.height * heights[i];
      final y1 = (size.height - barHeight) / 2;
      final y2 = y1 + barHeight;

      canvas.drawLine(Offset(x, y1), Offset(x, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => isAnimating;
}
