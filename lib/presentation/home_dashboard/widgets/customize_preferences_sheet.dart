import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../../widgets/custom_icon_widget.dart';

/// Bottom sheet for customizing outfit preferences
/// Allows users to adjust recommendation parameters
class CustomizePreferencesSheet extends StatefulWidget {
  final Map<String, dynamic> currentPreferences;
  final Function(Map<String, dynamic>) onSave;

  const CustomizePreferencesSheet({
    super.key,
    required this.currentPreferences,
    required this.onSave,
  });

  @override
  State<CustomizePreferencesSheet> createState() =>
      _CustomizePreferencesSheetState();
}

class _CustomizePreferencesSheetState extends State<CustomizePreferencesSheet> {
  late Map<String, dynamic> _preferences;

  @override
  void initState() {
    super.initState();
    _preferences = Map.from(widget.currentPreferences);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Customize Preferences',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    size: 24,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Style preference
            Text(
              'Style Preference',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: ['Casual', 'Formal', 'Sporty', 'Trendy'].map((style) {
                final isSelected = _preferences['style'] == style;
                return FilterChip(
                  label: Text(style),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _preferences['style'] = style);
                  },
                  backgroundColor: theme.colorScheme.surface,
                  selectedColor: theme.colorScheme.tertiary.withValues(
                    alpha: 0.2,
                  ),
                  checkmarkColor: theme.colorScheme.tertiary,
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 3.h),

            // Color preference
            Text(
              'Preferred Colors',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: ['Neutral', 'Bright', 'Dark', 'Pastel'].map((color) {
                final isSelected = (_preferences['colors'] as List).contains(
                  color,
                );
                return FilterChip(
                  label: Text(color),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      final colors = _preferences['colors'] as List;
                      if (selected) {
                        colors.add(color);
                      } else {
                        colors.remove(color);
                      }
                    });
                  },
                  backgroundColor: theme.colorScheme.surface,
                  selectedColor: theme.colorScheme.tertiary.withValues(
                    alpha: 0.2,
                  ),
                  checkmarkColor: theme.colorScheme.tertiary,
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 3.h),

            // Comfort level
            Text(
              'Comfort Level',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Slider(
              value: (_preferences['comfort'] as double),
              min: 0,
              max: 100,
              divisions: 10,
              label: '${(_preferences['comfort'] as double).round()}%',
              onChanged: (value) {
                setState(() => _preferences['comfort'] = value);
              },
            ),
            SizedBox(height: 3.h),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onSave(_preferences);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.tertiary,
                  foregroundColor: theme.colorScheme.onTertiary,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Save Preferences'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
