import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SettingsSectionWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final Function(String)? onItemTap;

  const SettingsSectionWidget({
    super.key,
    required this.title,
    required this.items,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == items.length - 1;

            return Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: item["type"] == "toggle"
                        ? null
                        : () => onItemTap?.call(item["key"] as String),
                    borderRadius: BorderRadius.vertical(
                      top: index == 0 ? Radius.circular(3.w) : Radius.zero,
                      bottom: isLast ? Radius.circular(3.w) : Radius.zero,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 3.h,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              color: (item["iconColor"] as Color? ??
                                      colorScheme.primary)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: CustomIconWidget(
                              iconName: item["icon"] as String,
                              color: item["iconColor"] as Color? ??
                                  colorScheme.primary,
                              size: 5.w,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["title"] as String,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (item["subtitle"] != null) ...[
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    item["subtitle"] as String,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          SizedBox(width: 2.w),
                          _buildTrailingWidget(item, theme, colorScheme),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: colorScheme.outline.withValues(alpha: 0.1),
                    indent: 17.w,
                  ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTrailingWidget(
    Map<String, dynamic> item,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    switch (item["type"] as String?) {
      case "toggle":
        return Switch(
          value: item["value"] as bool? ?? false,
          onChanged: (value) {
            // Handle toggle change
            onItemTap?.call("${item["key"]}_toggle");
          },
          activeColor: colorScheme.primary,
        );
      case "badge":
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: item["badgeColor"] as Color? ??
                colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Text(
            item["badgeText"] as String? ?? "",
            style: theme.textTheme.bodySmall?.copyWith(
              color: item["badgeColor"] as Color? ?? colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      default:
        return CustomIconWidget(
          iconName: 'chevron_right',
          color: colorScheme.onSurfaceVariant,
          size: 5.w,
        );
    }
  }
}
