import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

/// Weather summary card displaying current conditions
/// Implements subtle elevation with rounded corners
class WeatherSummaryCard extends StatelessWidget {
  final String temperature;
  final String condition;
  final String location;
  final String weatherIcon;
  final VoidCallback onRefresh;

  const WeatherSummaryCard({
    super.key,
    required this.temperature,
    required this.condition,
    required this.location,
    required this.weatherIcon,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Weather icon
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomImageWidget(
                imageUrl: weatherIcon,
                width: 10.w,
                height: 10.w,
                fit: BoxFit.contain,
                semanticLabel: "Weather condition icon showing $condition",
              ),
            ),
          ),
          SizedBox(width: 4.w),

          // Weather details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  temperature,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  condition,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      size: 16,
                      color: theme.colorScheme.tertiary,
                    ),
                    SizedBox(width: 1.w),
                    Expanded(
                      child: Text(
                        location,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.tertiary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Refresh button
          IconButton(
            onPressed: onRefresh,
            icon: CustomIconWidget(
              iconName: 'refresh',
              size: 24,
              color: theme.colorScheme.tertiary,
            ),
            padding: EdgeInsets.all(2.w),
            constraints: BoxConstraints(
              minWidth: 10.w,
              minHeight: 10.w,
            ),
          ),
        ],
      ),
    );
  }
}
