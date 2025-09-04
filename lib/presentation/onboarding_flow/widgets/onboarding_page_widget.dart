import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String description;
  final String iconName;
  final Color iconColor;
  final bool showAnimation;

  const OnboardingPageWidget({
    super.key,
    required this.title,
    required this.description,
    required this.iconName,
    required this.iconColor,
    this.showAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 100.w,
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Section with Animation
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: showAnimation
                  ? TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1500),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.8 + (0.2 * value),
                          child: CustomIconWidget(
                            iconName: iconName,
                            color: iconColor,
                            size: 20.w,
                          ),
                        );
                      },
                    )
                  : CustomIconWidget(
                      iconName: iconName,
                      color: iconColor,
                      size: 20.w,
                    ),
            ),
          ),
          SizedBox(height: 6.h),

          // Title
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
