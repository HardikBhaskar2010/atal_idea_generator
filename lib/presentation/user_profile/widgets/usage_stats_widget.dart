import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class UsageStatsWidget extends StatelessWidget {
  final Map<String, dynamic> statsData;

  const UsageStatsWidget({
    super.key,
    required this.statsData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> stats = [
      {
        "title": "Ideas Generated",
        "value": statsData["ideasGenerated"] ?? 0,
        "icon": "lightbulb",
        "color": Colors.amber,
        "subtitle": "This month",
      },
      {
        "title": "Projects Completed",
        "value": statsData["projectsCompleted"] ?? 0,
        "icon": "check_circle",
        "color": Colors.green,
        "subtitle": "Total",
      },
      {
        "title": "Components Scanned",
        "value": statsData["componentsScanned"] ?? 0,
        "icon": "qr_code_scanner",
        "color": Colors.blue,
        "subtitle": "This week",
      },
      {
        "title": "Days Active",
        "value": statsData["daysActive"] ?? 0,
        "icon": "calendar_today",
        "color": Colors.purple,
        "subtitle": "This month",
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  "Usage Statistics",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    "Updated today",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 1.2,
              ),
              itemCount: stats.length,
              itemBuilder: (context, index) {
                final stat = stats[index];
                return Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: (stat["color"] as Color).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: (stat["color"] as Color).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: (stat["color"] as Color)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: CustomIconWidget(
                              iconName: stat["icon"] as String,
                              color: stat["color"] as Color,
                              size: 4.w,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "${stat["value"]}",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        stat["title"] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        stat["subtitle"] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 4.w),
        ],
      ),
    );
  }
}
