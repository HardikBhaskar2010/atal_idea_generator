import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

enum SkillLevel { beginner, intermediate, advanced }

class SkillLevelSelector extends StatelessWidget {
  final SkillLevel? selectedLevel;
  final ValueChanged<SkillLevel> onChanged;

  const SkillLevelSelector({
    super.key,
    required this.selectedLevel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skill Level',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Select your experience level to get personalized project suggestions',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 3.h),
        Column(
          children: [
            _buildSkillOption(
              context,
              SkillLevel.beginner,
              'Beginner',
              'New to electronics and programming. Perfect for simple projects with step-by-step guidance.',
              'lightbulb_outline',
            ),
            SizedBox(height: 2.h),
            _buildSkillOption(
              context,
              SkillLevel.intermediate,
              'Intermediate',
              'Some experience with basic circuits and coding. Ready for moderate complexity projects.',
              'build',
            ),
            SizedBox(height: 2.h),
            _buildSkillOption(
              context,
              SkillLevel.advanced,
              'Advanced',
              'Experienced with complex systems and programming. Looking for challenging innovative projects.',
              'rocket_launch',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillOption(
    BuildContext context,
    SkillLevel level,
    String title,
    String description,
    String iconName,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = selectedLevel == level;

    return GestureDetector(
      onTap: () => onChanged(level),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'check',
                    color: colorScheme.onPrimary,
                    size: 4.w,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
