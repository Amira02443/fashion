import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

/// Main outfit recommendation card with Pinterest-inspired layout
/// Displays clothing combination with AI reasoning
class OutfitRecommendationCard extends StatefulWidget {
  final Map<String, dynamic> outfit;
  final VoidCallback onTap;

  const OutfitRecommendationCard({
    super.key,
    required this.outfit,
    required this.onTap,
  });

  @override
  State<OutfitRecommendationCard> createState() =>
      _OutfitRecommendationCardState();
}

class _OutfitRecommendationCardState extends State<OutfitRecommendationCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outfitImages = widget.outfit['images'] as List<String>;
    final weatherScore = widget.outfit['weatherScore'] as int;
    final reasoning = widget.outfit['reasoning'] as String;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Outfit images grid
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SizedBox(
                height: 50.h,
                child: outfitImages.length == 1
                    ? CustomImageWidget(
                        imageUrl: outfitImages[0],
                        width: double.infinity,
                        height: 50.h,
                        fit: BoxFit.cover,
                        semanticLabel:
                            widget.outfit['semanticLabels'][0] as String,
                      )
                    : GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          childAspectRatio: outfitImages.length == 2
                              ? 0.8
                              : 1.0,
                        ),
                        itemCount: outfitImages.length > 4
                            ? 4
                            : outfitImages.length,
                        itemBuilder: (context, index) {
                          return CustomImageWidget(
                            imageUrl: outfitImages[index],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            semanticLabel:
                                (widget.outfit['semanticLabels']
                                    as List<String>)[index],
                          );
                        },
                      ),
              ),
            ),

            // Outfit details
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weather appropriateness indicator
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getScoreColor(
                            weatherScore,
                            theme,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: weatherScore >= 80
                                  ? 'check_circle'
                                  : 'info',
                              size: 16,
                              color: _getScoreColor(weatherScore, theme),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '$weatherScore% Weather Match',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: _getScoreColor(weatherScore, theme),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Why This Outfit section
                  InkWell(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Why This Outfit?',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              CustomIconWidget(
                                iconName: _isExpanded
                                    ? 'expand_less'
                                    : 'expand_more',
                                size: 24,
                                color: theme.colorScheme.onSurface,
                              ),
                            ],
                          ),
                          if (_isExpanded) ...[
                            SizedBox(height: 2.h),
                            Text(
                              reasoning,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.8,
                                ),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score, ThemeData theme) {
    if (score >= 80) {
      return const Color(0xFF10B981); // Success green
    } else if (score >= 60) {
      return const Color(0xFFF59E0B); // Warning amber
    }
    return const Color(0xFFEF4444); // Error red
  }
}
