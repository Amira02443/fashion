import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Alternative outfit suggestion card for horizontal scroll
/// Compact version of main outfit card
class AlternativeOutfitCard extends StatelessWidget {
  final Map<String, dynamic> outfit;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const AlternativeOutfitCard({
    super.key,
    required this.outfit,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outfitImages = outfit['images'] as List<String>;
    final weatherScore = outfit['weatherScore'] as int;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 45.w,
        margin: EdgeInsets.only(right: 3.w),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Outfit preview
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 25.h,
                child: outfitImages.length == 1
                    ? CustomImageWidget(
                        imageUrl: outfitImages[0],
                        width: double.infinity,
                        height: 25.h,
                        fit: BoxFit.cover,
                        semanticLabel: outfit['semanticLabels'][0] as String,
                      )
                    : GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                        ),
                        itemCount:
                            outfitImages.length > 4 ? 4 : outfitImages.length,
                        itemBuilder: (context, index) {
                          return CustomImageWidget(
                            imageUrl: outfitImages[index],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            semanticLabel: (outfit['semanticLabels']
                                as List<String>)[index],
                          );
                        },
                      ),
              ),
            ),

            // Weather score badge
            Padding(
              padding: EdgeInsets.all(2.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getScoreColor(weatherScore, theme)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      size: 12,
                      color: _getScoreColor(weatherScore, theme),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '$weatherScore%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getScoreColor(weatherScore, theme),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score, ThemeData theme) {
    if (score >= 80) {
      return const Color(0xFF10B981);
    } else if (score >= 60) {
      return const Color(0xFFF59E0B);
    }
    return const Color(0xFFEF4444);
  }
}
