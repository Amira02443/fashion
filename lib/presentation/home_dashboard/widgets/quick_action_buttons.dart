import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../../widgets/custom_icon_widget.dart';

/// Quick action buttons for outfit feedback
/// Implements thumb-friendly touch targets
class QuickActionButtons extends StatelessWidget {
  final VoidCallback onWearingThis;
  final VoidCallback onNotToday;
  final VoidCallback onCustomize;

  const QuickActionButtons({
    super.key,
    required this.onWearingThis,
    required this.onNotToday,
    required this.onCustomize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          // Wearing This button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onWearingThis,
              icon: CustomIconWidget(
                iconName: 'thumb_up',
                size: 20,
                color: theme.colorScheme.onTertiary,
              ),
              label: Text('Wearing This'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.tertiary,
                foregroundColor: theme.colorScheme.onTertiary,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),

          // Not Today button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onNotToday,
              icon: CustomIconWidget(
                iconName: 'thumb_down',
                size: 20,
                color: theme.colorScheme.onSurface,
              ),
              label: Text('Not Today'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                side: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),

          // Customize button
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
            child: IconButton(
              onPressed: onCustomize,
              icon: CustomIconWidget(
                iconName: 'tune',
                size: 24,
                color: theme.colorScheme.onSurface,
              ),
              padding: EdgeInsets.all(2.h),
              constraints: BoxConstraints(minWidth: 12.w, minHeight: 6.h),
            ),
          ),
        ],
      ),
    );
  }
}
