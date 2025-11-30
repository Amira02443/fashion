// lib/widgets/custom_app_bar.dart
import 'package:flutter/material.dart';

enum AppBarVariant { standard, transparent }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AppBarVariant variant;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = AppBarVariant.standard,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = variant == AppBarVariant.transparent
        ? Colors.transparent
        : theme.appBarTheme.backgroundColor;

    return AppBar(
      backgroundColor: backgroundColor,
      elevation: variant == AppBarVariant.transparent ? 0 : null,
      centerTitle: true,
      title: Text(title, style: theme.textTheme.titleLarge),
      actions: actions,
      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  const CustomAppBarAction({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(icon), tooltip: tooltip, onPressed: onPressed);
  }
}
