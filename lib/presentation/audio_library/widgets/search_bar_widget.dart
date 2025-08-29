import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final bool showClearButton;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Search audio files...',
    required this.onChanged,
    this.onClear,
    this.showClearButton = false,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
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
                      .withValues(alpha: 0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
              border: Border.all(
                color: _isFocused
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.5)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                width: _isFocused ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isFocused
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.shadow
                          .withValues(alpha: 0.05),
                  blurRadius: _isFocused ? 12 : 6,
                  offset: Offset(0, _isFocused ? 4 : 2),
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              onTap: () {
                setState(() => _isFocused = true);
                _animationController.forward();
              },
              onTapOutside: (_) {
                setState(() => _isFocused = false);
                _animationController.reverse();
                FocusScope.of(context).unfocus();
              },
              style: AppTheme.lightTheme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.6),
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: _isFocused
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: widget.showClearButton
                    ? GestureDetector(
                        onTap: () {
                          _controller.clear();
                          widget.onChanged('');
                          if (widget.onClear != null) {
                            widget.onClear!();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'close',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 3.5.w,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
