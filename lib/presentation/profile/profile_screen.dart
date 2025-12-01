// lib/presentation/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';

// ← If you have this file later, uncomment the line below
// import '../customize_preferences/customize_preferences_sheet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        variant: AppBarVariant.standard,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12.w,
                    backgroundColor:
                        theme.colorScheme.tertiary.withOpacity(0.2),
                    child: CustomIconWidget(
                      iconName: 'person',
                      size: 48,
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amira Krid',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Style Enthusiast',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            _buildStat(context, '128', 'Outfits Worn'),
                            SizedBox(width: 4.w),
                            _buildStat(context, '42', 'Items Saved'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            // Menu Items
            _buildMenuTile(
              context,
              icon: 'checkroom',
              title: 'My Wardrobe',
              subtitle: 'View and manage your clothes',
              onTap: () => Navigator.pushNamed(context, '/wardrobe-gallery'),
            ),
            _buildMenuTile(
              context,
              icon: 'favorite',
              title: 'Favorite Outfits',
              subtitle: 'Your saved recommendations',
              onTap: () =>
                  Fluttertoast.showToast(msg: "Favorites coming soon!"),
            ),
            _buildMenuTile(
              context,
              icon: 'history',
              title: 'Outfit History',
              subtitle: 'See what you wore this week',
              onTap: () => Fluttertoast.showToast(msg: "History coming soon!"),
            ),
            _buildMenuTile(
              context,
              icon: 'tune',
              title: 'Preferences',
              subtitle: 'Style, colors, comfort level',
              onTap: () {
                // ← When you add the real sheet later, replace this block
                Fluttertoast.showToast(msg: "Preferences sheet coming soon!");
              },
            ),
            _buildMenuTile(
              context,
              icon: 'notifications',
              title: 'Notifications',
              subtitle: 'Daily recommendations, weather alerts',
              trailing: Switch(value: true, onChanged: (_) {}),
            ),
            _buildMenuTile(
              context,
              icon: 'help_outline',
              title: 'Help & Feedback',
              onTap: () =>
                  Fluttertoast.showToast(msg: "Send us your thoughts!"),
            ),
            _buildMenuTile(
              context,
              icon: 'info_outline',
              title: 'About StyleCast',
              subtitle: 'Version 1.0.0',
            ),

            SizedBox(height: 4.h),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Log Out?'),
                      content:
                          const Text('You’ll need to sign in again next time.'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel')),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () {
                            // Replace with real logout later
                            Fluttertoast.showToast(msg: "Logged out!");
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false);
                          },
                          child: const Text('Log Out',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red.withOpacity(0.5)),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: const Text('Log Out'),
              ),
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}

// ———————————————————————
// Helper widgets (must be outside the class)
// ———————————————————————

Widget _buildStat(BuildContext context, String value, String label) {
  final theme = Theme.of(context);
  return Column(
    children: [
      Text(
        value,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.tertiary,
        ),
      ),
      Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    ],
  );
}

Widget _buildMenuTile(
  BuildContext context, {
  required String icon,
  required String title,
  String? subtitle,
  Widget? trailing,
  VoidCallback? onTap,
}) {
  final theme = Theme.of(context);
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
    leading: Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomIconWidget(
          iconName: icon, color: theme.colorScheme.tertiary, size: 24),
    ),
    title: Text(title, style: theme.textTheme.titleMedium),
    subtitle: subtitle != null
        ? Text(subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ))
        : null,
    trailing: trailing ??
        CustomIconWidget(
          iconName: 'chevron_right',
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
    onTap: onTap,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    tileColor: theme.colorScheme.surface,
    hoverColor: theme.colorScheme.tertiary.withOpacity(0.05),
  );
}
