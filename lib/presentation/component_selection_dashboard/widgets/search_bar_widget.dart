import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onMicrophoneTap;
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.hintText = 'Search components...',
    this.onMicrophoneTap,
    this.onFilterTap,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 7.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.surface,
            colorScheme.surfaceContainerLow,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFocused
              ? colorScheme.primary.withValues(alpha: 0.5)
              : colorScheme.outline.withValues(alpha: 0.2),
          width: _isFocused ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _isFocused
                ? colorScheme.primary.withValues(alpha: 0.15)
                : colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: _isFocused ? 12 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Container(
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'search',
                color: colorScheme.primary,
                size: 5.w,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Focus(
              onFocusChange: (focused) {
                setState(() {
                  _isFocused = focused;
                });
              },
              child: TextField(
                controller: widget.controller,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted != null
                    ? (_) => widget.onSubmitted!()
                    : null,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          if (widget.onMicrophoneTap != null) ...[
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onMicrophoneTap,
                borderRadius: BorderRadius.circular(12),
                splashColor: colorScheme.primary.withValues(alpha: 0.1),
                child: Container(
                  padding: EdgeInsets.all(2.5.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.15),
                        colorScheme.secondary.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'mic',
                    color: colorScheme.primary,
                    size: 5.w,
                  ),
                ),
              ),
            ),
          ],
          if (widget.onFilterTap != null) ...[
            Container(
              margin: EdgeInsets.only(right: 2.w, left: 1.w),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onFilterTap,
                  borderRadius: BorderRadius.circular(12),
                  splashColor: colorScheme.secondary.withValues(alpha: 0.1),
                  child: Container(
                    padding: EdgeInsets.all(2.5.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.secondary.withValues(alpha: 0.15),
                          colorScheme.tertiary.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.secondary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'tune',
                      color: colorScheme.secondary,
                      size: 5.w,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
