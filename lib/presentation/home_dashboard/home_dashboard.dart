// lib/presentation/home_dashboard/home_dashboard.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';

/// Home Dashboard - Écran principal avec recommandations IA
class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  bool _isLoading = false;

  // Données météo mock
  final Map<String, String> _weather = {
    'temp': '72°F',
    'condition': 'Partly Cloudy',
    'city': 'San Francisco',
  };

  // Tenue principale du jour
  final Map<String, dynamic> _mainOutfit = {
    'images': [
      'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=800',
      'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800',
      'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=800',
      'https://images.unsplash.com/photo-1549062572-544a64fb0c56?w=800',
    ],
    'score': 92,
    'reason':
        'Perfect for today\'s mild weather! Denim jacket + cotton t-shirt = ideal comfort.',
  };

  // Alternatives
  final List<Map<String, dynamic>> _alternatives = [
    {
      'images': [
        'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800',
        'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=800',
      ],
      'score': 85,
    },
    {
      'images': [
        'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=800',
        'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800',
      ],
      'score': 78,
    },
  ];

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    Fluttertoast.showToast(
      msg: "New outfits generated!",
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'StyleCast',
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () =>
                Fluttertoast.showToast(msg: "2 new recommendations!"),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: theme.colorScheme.tertiary),
                  SizedBox(height: 3.h),
                  const Text('Generating your perfect outfit...'),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _refresh,
              color: theme.colorScheme.tertiary,
              child: ListView(
                padding: EdgeInsets.all(4.w),
                children: [
                  // === MÉTÉO ===
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Row(
                        children: [
                          Image.network(
                            'https://cdn-icons-png.flaticon.com/128/1163/1163661.png',
                            width: 60,
                          ),
                          SizedBox(width: 4.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_weather['temp']!,
                                  style: theme.textTheme.headlineMedium),
                              Text(_weather['condition']!),
                              Text(_weather['city']!,
                                  style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // === TENUE DU JOUR ===
                  Text("Today's Outfit", style: theme.textTheme.headlineSmall),
                  SizedBox(height: 2.h),

                  // Grille 2x2 des vêtements
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 3.w,
                    crossAxisSpacing: 3.w,
                    children: _mainOutfit['images']
                        .map<Widget>((url) => ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(url, fit: BoxFit.cover),
                            ))
                        .toList(),
                  ),

                  SizedBox(height: 2.h),
                  Text(_mainOutfit['reason'],
                      style: theme.textTheme.bodyMedium),

                  SizedBox(height: 4.h),

                  // === ALTERNATIVES ===
                  Text("More ideas", style: theme.textTheme.titleLarge),
                  SizedBox(height: 2.h),
                  SizedBox(
                    height: 32.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _alternatives.length,
                      itemBuilder: (context, i) {
                        final alt = _alternatives[i];
                        return Padding(
                          padding: EdgeInsets.only(right: 4.w),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      alt['images'][0],
                                      width: 60.w,
                                      height: 24.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Text('${alt['score']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              const Text("Tap to swap",
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 6.h),
                ],
              ),
            ),

      // === BOUTONS D’ACTION ===
      bottomSheet: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Fluttertoast.showToast(msg: "Not today"),
                child: const Text("Not Today"),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () =>
                    Fluttertoast.showToast(msg: "Outfit saved to history!"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary),
                child: const Text("I'm Wearing This"),
              ),
            ),
          ],
        ),
      ),

      // Bottom navigation
      bottomNavigationBar: CustomBottomBar(
        currentItem: BottomNavItem.home,
        onItemTapped: (item) {},
      ),
    );
  }
}
