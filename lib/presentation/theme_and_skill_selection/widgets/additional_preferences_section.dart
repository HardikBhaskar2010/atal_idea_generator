import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AdditionalPreferencesSection extends StatelessWidget {
  final String? selectedDuration;
  final String? selectedTeamSize;
  final List<String> selectedInterests;
  final ValueChanged<String> onDurationChanged;
  final ValueChanged<String> onTeamSizeChanged;
  final ValueChanged<List<String>> onInterestsChanged;

  const AdditionalPreferencesSection({
    super.key,
    required this.selectedDuration,
    required this.selectedTeamSize,
    required this.selectedInterests,
    required this.onDurationChanged,
    required this.onTeamSizeChanged,
    required this.onInterestsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Preferences',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Optional settings to further customize your project suggestions',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 3.h),

        // Project Duration
        _buildPreferenceSection(
          context,
          'Project Duration',
          ['1 week', '1 month', 'Semester'],
          selectedDuration,
          onDurationChanged,
        ),

        SizedBox(height: 3.h),

        // Team Size
        _buildPreferenceSection(
          context,
          'Team Size',
          ['Individual', '2-3 members', '4+ members'],
          selectedTeamSize,
          onTeamSizeChanged,
        ),

        SizedBox(height: 3.h),

        // Special Interests
        _buildInterestsSection(context),
      ],
    );
  }

  Widget _buildPreferenceSection(
    BuildContext context,
    String title,
    List<String> options,
    String? selectedValue,
    ValueChanged<String> onChanged,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  option,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInterestsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final interests = [
      'IoT',
      'Machine Learning',
      'Sensors',
      'Automation',
      'Mobile Apps',
      'Web Development',
      '3D Printing',
      'Drones',
      'Solar Energy',
      'Water Conservation',
      'Air Quality',
      'Gaming'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special Interests',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: interests.map((interest) {
            final isSelected = selectedInterests.contains(interest);
            return GestureDetector(
              onTap: () {
                List<String> updatedInterests = List.from(selectedInterests);
                if (isSelected) {
                  updatedInterests.remove(interest);
                } else {
                  updatedInterests.add(interest);
                }
                onInterestsChanged(updatedInterests);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.tertiary.withValues(alpha: 0.2)
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.tertiary
                        : colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      interest,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? colorScheme.tertiary
                            : colorScheme.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                    if (isSelected) ...[
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'close',
                        color: colorScheme.tertiary,
                        size: 3.w,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
