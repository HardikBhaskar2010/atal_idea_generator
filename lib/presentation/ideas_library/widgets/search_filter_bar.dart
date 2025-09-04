import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearchChanged;
  final String selectedFilter;
  final List<String> filterOptions;
  final Function(String) onFilterChanged;
  final bool showFavoritesOnly;
  final VoidCallback onToggleFavoritesOnly;

  const SearchFilterBar({
    super.key,
    required this.controller,
    required this.onSearchChanged,
    required this.selectedFilter,
    required this.filterOptions,
    required this.onFilterChanged,
    required this.showFavoritesOnly,
    required this.onToggleFavoritesOnly,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: TextField(
              controller: controller,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search your ideas...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          controller.clear();
                          onSearchChanged('');
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color: colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Filter Row
          Row(
            children: [
              // Filter Dropdown
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: selectedFilter,
                    onChanged: (value) => onFilterChanged(value!),
                    underline: const SizedBox(),
                    isExpanded: true,
                    icon: CustomIconWidget(
                      iconName: 'expand_more',
                      color: colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                    items: filterOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: _getFilterIcon(option),
                              color: colorScheme.onSurfaceVariant,
                              size: 4.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              option,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(width: 2.w),

              // Favorites Toggle
              GestureDetector(
                onTap: onToggleFavoritesOnly,
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: showFavoritesOnly
                        ? Colors.red.withValues(alpha: 0.1)
                        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: showFavoritesOnly
                          ? Colors.red.withValues(alpha: 0.3)
                          : colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: showFavoritesOnly ? 'favorite' : 'favorite_border',
                        color: showFavoritesOnly ? Colors.red : colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Fav',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: showFavoritesOnly ? Colors.red : colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getFilterIcon(String filter) {
    switch (filter) {
      case 'All':
        return 'dashboard';
      case 'Beginner':
        return 'school';
      case 'Intermediate':
        return 'trending_up';
      case 'Advanced':
        return 'rocket_launch';
      case 'Robotics':
        return 'smart_toy';
      case 'Environment':
        return 'eco';
      case 'Health':
        return 'favorite';
      case 'Agriculture':
        return 'agriculture';
      case 'Smart City':
        return 'location_city';
      default:
        return 'category';
    }
  }
}