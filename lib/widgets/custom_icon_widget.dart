// lib/widgets/custom_icon_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIconWidget extends StatelessWidget {
  final String iconName;
  final double size;
  final Color? color;

  const CustomIconWidget({
    super.key,
    required this.iconName,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = color ?? theme.colorScheme.onSurface;

    // Use Material Icons (filled) via name mapping
    final IconData? materialIcon = _getMaterialIcon(iconName);

    if (materialIcon != null) {
      return Icon(materialIcon, size: size, color: iconColor);
    }

    // Fallback to SVG assets (create assets/icons/ folder later)
    return SvgPicture.asset(
      'assets/icons/$iconName.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      // Remove errorBuilder in production when SVGs exist
    );
  }

  IconData? _getMaterialIcon(String name) {
    const map = {
      'home': Icons.home_rounded,
      'checkroom': Icons.checkroom_rounded,
      'favorite': Icons.favorite_rounded,
      'person': Icons.person_rounded,
      'camera_alt': Icons.camera_alt_rounded,
      'add_a_photo': Icons.add_a_photo_rounded,
      'tune': Icons.tune_rounded,
      'close': Icons.close_rounded,
      'chevron_right': Icons.chevron_right_rounded,
      'refresh': Icons.refresh_rounded,
      'thumb_up': Icons.thumb_up_rounded,
      'thumb_down': Icons.thumb_down_rounded,
      'check_circle': Icons.check_circle_rounded,
      'expand_more': Icons.expand_more_rounded,
      'expand_less': Icons.expand_less_rounded,
      'lightbulb': Icons.lightbulb_rounded,
      'location_on': Icons.location_on_rounded,
      'notifications': Icons.notifications_rounded,
      'edit': Icons.edit_rounded,
      'delete': Icons.delete_rounded,
      'search': Icons.search_rounded,
      'info': Icons.info_rounded,
      'photo_library': Icons.photo_library_rounded,
      'history': Icons.history_rounded,
      'help_outline': Icons.help_outline_rounded,
      'info_outline': Icons.info_outline_rounded,
    };
    return map[name];
  }
}
