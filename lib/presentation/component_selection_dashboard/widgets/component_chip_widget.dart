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
      margin: EdgeInsets.only(right: 3.w),
      width: 40.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.8),
            colorScheme.secondaryContainer.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onLongPress: onRemove,
          borderRadius: BorderRadius.circular(16),
          splashColor: colorScheme.primary.withValues(alpha: 0.1),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and remove button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary.withValues(alpha: 0.2),
                            colorScheme.secondary.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: categoryIcon,
                        color: colorScheme.primary,
                        size: 5.w,
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: EdgeInsets.all(1.5.w),
                        decoration: BoxDecoration(
                          color: colorScheme.error.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.error.withValues(alpha: 0.3),
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: 'close',
                          color: colorScheme.error,
                          size: 3.5.w,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),

                // Component name and category
                Text(
                  name,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimaryContainer,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'category',
                      color:
                          colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                      size: 3.w,
                    ),
                    SizedBox(width: 1.w),
                    Expanded(
                      child: Text(
                        category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),

                // Enhanced Quantity controls
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onQuantityDecrease != null)
                        GestureDetector(
                          onTap: onQuantityDecrease,
                          child: Container(
                            padding: EdgeInsets.all(1.5.w),
                            decoration: BoxDecoration(
                              color: colorScheme.error.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.error.withValues(alpha: 0.3),
                              ),
                            ),
                            child: CustomIconWidget(
                              iconName: 'remove',
                              color: colorScheme.error,
                              size: 3.w,
                            ),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary.withValues(alpha: 0.1),
                                colorScheme.secondary.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'inventory',
                                color: colorScheme.primary,
                                size: 3.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                quantity.toString(),
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (onQuantityIncrease != null)
                        GestureDetector(
                          onTap: onQuantityIncrease,
                          child: Container(
                            padding: EdgeInsets.all(1.5.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary.withValues(alpha: 0.2),
                                  colorScheme.secondary.withValues(alpha: 0.1),
                                ],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: CustomIconWidget(
                              iconName: 'add',
                              color: colorScheme.primary,
                              size: 3.w,
                            ),
                          ),
                        ),
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
