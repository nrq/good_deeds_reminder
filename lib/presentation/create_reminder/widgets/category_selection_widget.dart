import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategorySelectionWidget extends StatefulWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelectionWidget({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategorySelectionWidget> createState() =>
      _CategorySelectionWidgetState();
}

class _CategorySelectionWidgetState extends State<CategorySelectionWidget> {
  final List<Map<String, dynamic>> categories = [
    {
      'id': 'prayer',
      'name': 'Prayer',
      'icon': 'mosque',
      'color': AppTheme.lightTheme.colorScheme.primary,
    },
    {
      'id': 'charity',
      'name': 'Charity',
      'icon': 'volunteer_activism',
      'color': AppTheme.lightTheme.colorScheme.tertiary,
    },
    {
      'id': 'family',
      'name': 'Family',
      'icon': 'family_restroom',
      'color': Color(0xFFE91E63),
    },
    {
      'id': 'health',
      'name': 'Health',
      'icon': 'favorite',
      'color': Color(0xFF4CAF50),
    },
    {
      'id': 'learning',
      'name': 'Learning',
      'icon': 'school',
      'color': Color(0xFF2196F3),
    },
    {
      'id': 'custom',
      'name': 'Custom',
      'icon': 'add_circle_outline',
      'color': AppTheme.lightTheme.colorScheme.onSurfaceVariant,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 12.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            itemCount: categories.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = widget.selectedCategory == category['id'];

              return GestureDetector(
                onTap: () => widget.onCategorySelected(category['id']),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: 20.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (category['color'] as Color).withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? category['color'] as Color
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow
                            .withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: category['icon'],
                        color: isSelected
                            ? category['color'] as Color
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        category['name'],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? category['color'] as Color
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
