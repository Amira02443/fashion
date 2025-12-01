// lib/main.dart
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';  

import 'core/app_export.dart';
import 'presentation/wardrobe_setup/wardrobe_setup.dart';
import 'presentation/home_dashboard/home_dashboard.dart';
import 'presentation/wardrobe_gallery/wardrobe_gallery.dart';
import 'presentation/profile/profile_screen.dart';
import 'widgets/custom_app_bar.dart';

// Global navigator key for route navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Main entry point
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style (status bar + navigation bar)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // Initialize cameras for wardrobe capture
  // Wrap in try-catch to handle platforms without camera support
  List<CameraDescription> cameras = [];
  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint('Camera initialization failed (this is normal on some platforms): $e');
    // Continue with empty camera list - app will still work
  }

  // Run app with error handling
  runZonedGuarded(() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      // In production: send to Crashlytics / Sentry
    };

    runApp(StyleCastApp(cameras: cameras));
  }, (error, stack) {
    debugPrint('Uncaught error: $error');
    // In production: report to crash analytics
  });
}

class StyleCastApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const StyleCastApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'StyleCast',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light, // Change to system later if desired

          // Pass cameras to wardrobe setup
          initialRoute: AppRoutes.homeDashboard,
          navigatorKey: navigatorKey,

          routes: {
            AppRoutes.wardrobeSetup: (context) =>  WardrobeSetup(),
            AppRoutes.homeDashboard: (context) =>  MainScreen(initialIndex: 0),
            AppRoutes.wardrobeGallery: (context) =>  MainScreen(initialIndex: 1),
            AppRoutes.profile: (context) =>  MainScreen(initialIndex: 3),
          },

          builder: (context, child) {
            // Initialize toast
            FToast fToast = FToast();
            fToast.init(context);

            return Stack(
              children: [
                child!,
                // Optional: Global loading overlay can go here
              ],
            );
          },
        );
      },
    );
  }
}

// Main screen with persistent bottom navigation
class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomeDashboard(),
    WardrobeGallery(),
    FavoritesScreen(),       // Coming soon
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomBar(
        currentItem: BottomNavItem.values[_currentIndex],
        onItemTapped: (item) => _onTabTapped(item.index),
      ),
    );
  }
}

// Placeholder for future screens
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Favorites'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_rounded, size: 80, color: Colors.pink[300]),
            const SizedBox(height: 16),
            Text(
              'Your favorite outfits will appear here',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart on any recommendation to save it',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}