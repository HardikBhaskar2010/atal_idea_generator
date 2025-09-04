import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ComponentChipWidget extends StatelessWidget {
  final String name;
  final String category;
  final String categoryIcon;
  final int quantity;
  final VoidCallback onRemove;
  final VoidCallback? onQuantityIncrease;
  final VoidCallback? onQuantityDecrease;

  const ComponentChipWidget({
    super.key,
    required this.name,
    required this.category,
    required this.categoryIcon,
    required this.quantity,
    required this.onRemove,
    this.onQuantityIncrease,
    this.onQuantityDecrease,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: Material(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onLongPress: onRemove,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: categoryIcon,
                      color: colorScheme.primary,
                      size: 3.w,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      category,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer
                            .withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(width: 2.w),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onQuantityDecrease != null) ...[
                        GestureDetector(
                          onTap: onQuantityDecrease,
                          child: CustomIconWidget(
                            iconName: 'remove',
                            color: colorScheme.onPrimary,
                            size: 3.w,
                          ),
                        ),
                        SizedBox(width: 1.w),
                      ],
                      Text(
                        quantity.toString(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      if (onQuantityIncrease != null) ...[
                        SizedBox(width: 1.w),
                        GestureDetector(
                          onTap: onQuantityIncrease,
                          child: CustomIconWidget(
                            iconName: 'add',
                            color: colorScheme.onPrimary,
                            size: 3.w,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
