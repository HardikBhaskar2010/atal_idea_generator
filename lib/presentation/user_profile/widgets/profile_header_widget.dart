import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfileHeaderWidget({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(6.w),
          bottomRight: Radius.circular(6.w),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: 2.h),
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.onPrimary,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: userData["avatar"] != null
                    ? CustomImageWidget(
                        imageUrl: userData["avatar"] as String,
                        width: 20.w,
                        height: 20.w,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: colorScheme.onPrimary.withValues(alpha: 0.2),
                        child: CustomIconWidget(
                          iconName: 'person',
                          color: colorScheme.onPrimary,
                          size: 10.w,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              userData["name"] as String? ?? "Student Name",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(5.w),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'school',
                    color: colorScheme.onPrimary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Flexible(
                    child: Text(
                      userData["institution"] as String? ??
                          "ATAL Tinkering Lab",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: userData["tier"] == "Pro"
                    ? Colors.amber.withValues(alpha: 0.2)
                    : colorScheme.onPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(
                  color: userData["tier"] == "Pro"
                      ? Colors.amber
                      : colorScheme.onPrimary.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                "${userData["tier"] as String? ?? "Free"} Tier",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: userData["tier"] == "Pro"
                      ? Colors.amber
                      : colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
