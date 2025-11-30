// lib/widgets/custom_bottom_bar.dart
import 'package:flutter/material.dart';

enum BottomNavItem { home, wardrobe, favorites, profile }

class CustomBottomBar extends StatelessWidget {
  final BottomNavItem currentItem;
  final Function(BottomNavItem) onItemTapped;

  const CustomBottomBar({
    super.key,
    required this.currentItem,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.tertiary;

    return BottomNavigationBar(
      currentIndex: currentItem.index,
      onTap: (i) => onItemTapped(BottomNavItem.values[i]),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: color,
      unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.4),
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Today'),
        BottomNavigationBarItem(
          icon: Icon(Icons.checkroom_rounded),
          label: 'Wardrobe',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_rounded),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
