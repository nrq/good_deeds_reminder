import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/audio_selection_widget.dart';
import './widgets/category_selection_widget.dart';
import './widgets/frequency_selection_widget.dart';
import './widgets/time_selection_widget.dart';

class CreateReminder extends StatefulWidget {
  const CreateReminder({super.key});

  @override
  State<CreateReminder> createState() => _CreateReminderState();
}

class _CreateReminderState extends State<CreateReminder> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _scrollController = ScrollController();

  String? _selectedCategory;
  Map<String, dynamic>? _selectedFrequency;
  TimeOfDay? _selectedTime;
  Map<String, dynamic>? _selectedAudio;
  bool _isAdvancedExpanded = false;
  bool _enableNotifications = true;
  int _repeatLimit = 0; // 0 means infinite

  bool get _isFormValid {
    return _titleController.text.trim().isNotEmpty &&
        _selectedCategory != null &&
        _selectedFrequency != null &&
        _selectedTime != null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
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
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.all(4.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleSection(),
                      SizedBox(height: 4.h),
                      CategorySelectionWidget(
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (category) {
                          setState(() => _selectedCategory = category);
                        },
                      ),
                      SizedBox(height: 4.h),
                      FrequencySelectionWidget(
                        selectedFrequency: _selectedFrequency,
                        onFrequencySelected: (frequency) {
                          setState(() => _selectedFrequency = frequency);
                        },
                      ),
                      SizedBox(height: 4.h),
                      TimeSelectionWidget(
                        selectedTime: _selectedTime,
                        onTimeSelected: (time) {
                          setState(() => _selectedTime = time);
                        },
                      ),
                      SizedBox(height: 4.h),
                      AudioSelectionWidget(
                        selectedAudio: _selectedAudio,
                        onAudioSelected: (audio) {
                          setState(() => _selectedAudio = audio);
                        },
                      ),
                      SizedBox(height: 4.h),
                      _buildDescriptionSection(),
                      SizedBox(height: 4.h),
                      _buildAdvancedOptions(),
                      SizedBox(height: 8.h), // Extra space for keyboard
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
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
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Create Reminder',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: _isFormValid ? _saveReminder : null,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
              decoration: BoxDecoration(
                color: _isFormValid
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Save',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: _isFormValid
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reminder Title',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'e.g., Call my mother, Read Quran, Exercise',
            counterText: '${_titleController.text.length}/50',
          ),
          maxLength: 50,
          textInputAction: TextInputAction.next,
          onChanged: (value) => setState(() {}),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a reminder title';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description (Optional)',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            hintText: 'Add more details about this reminder...',
            alignLabelWithHint: true,
          ),
          maxLines: 3,
          maxLength: 200,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [
            _buildSuggestionChip('May Allah bless this deed'),
            _buildSuggestionChip('For the sake of Allah'),
            _buildSuggestionChip('Seeking barakah'),
          ],
        ),
      ],
    );
  }

  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () {
        final currentText = _descriptionController.text;
        final newText = currentText.isEmpty ? text : '$currentText $text';
        _descriptionController.text = newText;
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          text,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () =>
              setState(() => _isAdvancedExpanded = !_isAdvancedExpanded),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'settings',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Advanced Options',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _isAdvancedExpanded ? 0.5 : 0,
                  duration: Duration(milliseconds: 200),
                  child: CustomIconWidget(
                    iconName: 'keyboard_arrow_down',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: _isAdvancedExpanded ? null : 0,
          child:
              _isAdvancedExpanded ? _buildAdvancedContent() : SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildAdvancedContent() {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
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
              Expanded(
                child: Text(
                  'Enable Notifications',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Switch(
                value: _enableNotifications,
                onChanged: (value) =>
                    setState(() => _enableNotifications = value),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Repeat Limit',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: RadioListTile<int>(
                  title: Text('Infinite'),
                  value: 0,
                  groupValue: _repeatLimit,
                  onChanged: (value) =>
                      setState(() => _repeatLimit = value ?? 0),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: RadioListTile<int>(
                  title: Text('Custom'),
                  value: 1,
                  groupValue: _repeatLimit,
                  onChanged: (value) =>
                      setState(() => _repeatLimit = value ?? 0),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          if (_repeatLimit == 1) ...[
            SizedBox(height: 2.h),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Number of repetitions',
                hintText: 'e.g., 30',
              ),
              keyboardType: TextInputType.number,
              initialValue: '30',
            ),
          ],
        ],
      ),
    );
  }

  void _saveReminder() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Show success animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 32,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Reminder Created!',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Your good deed reminder has been set up successfully. May Allah bless your efforts.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pushReplacementNamed(context, '/reminder-management');
              },
              child: Text('View Reminders'),
            ),
          ),
        ],
      ),
    );
  }
}
