import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final ValueChanged<Map<String, dynamic>> onFiltersChanged;

  const FilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> _filters;

  final List<String> _categories = [
    'All Categories',
    'Electronics',
    'Sensors',
    'Motors',
    'Microcontrollers',
    'Displays',
    'Power Supply',
    'Connectivity',
    'Mechanical',
  ];

  final List<String> _difficultyLevels = [
    'All Levels',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  final List<String> _projectTypes = [
    'All Projects',
    'Robotics',
    'IoT',
    'Automation',
    'Environmental',
    'Health Tech',
    'Smart City',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Filter Components',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filters = {
                        'category': 'All Categories',
                        'difficulty': 'All Levels',
                        'projectType': 'All Projects',
                        'costRange': RangeValues(0, 5000),
                        'availableOnly': false,
                      };
                    });
                  },
                  child: Text(
                    'Clear All',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection(
                    'Category',
                    _categories,
                    _filters['category'] as String? ?? 'All Categories',
                    (value) => setState(() => _filters['category'] = value),
                    theme,
                    colorScheme,
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Difficulty Level',
                    _difficultyLevels,
                    _filters['difficulty'] as String? ?? 'All Levels',
                    (value) => setState(() => _filters['difficulty'] = value),
                    theme,
                    colorScheme,
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Project Type',
                    _projectTypes,
                    _filters['projectType'] as String? ?? 'All Projects',
                    (value) => setState(() => _filters['projectType'] = value),
                    theme,
                    colorScheme,
                  ),
                  SizedBox(height: 3.h),
                  _buildCostRangeFilter(theme, colorScheme),
                  SizedBox(height: 3.h),
                  _buildAvailabilityFilter(theme, colorScheme),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onFiltersChanged(_filters);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Apply Filters',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String selectedValue,
    ValueChanged<String> onChanged,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = option == selectedValue;
            return FilterChip(
              label: Text(
                option,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onChanged(option),
              backgroundColor: colorScheme.surface,
              selectedColor: colorScheme.primary,
              side: BorderSide(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.3),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCostRangeFilter(ThemeData theme, ColorScheme colorScheme) {
    final costRange =
        _filters['costRange'] as RangeValues? ?? const RangeValues(0, 5000);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cost Range (₹)',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        RangeSlider(
          values: costRange,
          min: 0,
          max: 5000,
          divisions: 50,
          labels: RangeLabels(
            '₹${costRange.start.round()}',
            '₹${costRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _filters['costRange'] = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₹${costRange.start.round()}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '₹${costRange.end.round()}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvailabilityFilter(ThemeData theme, ColorScheme colorScheme) {
    final availableOnly = _filters['availableOnly'] as bool? ?? false;

    return Row(
      children: [
        Checkbox(
          value: availableOnly,
          onChanged: (value) {
            setState(() {
              _filters['availableOnly'] = value ?? false;
            });
          },
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            'Show only available components',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
