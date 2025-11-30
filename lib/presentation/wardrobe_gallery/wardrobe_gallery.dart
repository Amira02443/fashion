// lib/presentation/wardrobe_gallery/wardrobe_gallery.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import '../wardrobe_setup/widgets/wardrobe_item_card.dart';

class WardrobeGallery extends StatefulWidget {
  const WardrobeGallery({super.key});

  @override
  State<WardrobeGallery> createState() => _WardrobeGalleryState();
}

class _WardrobeGalleryState extends State<WardrobeGallery>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data — sera remplacé par Hive/Firestore plus tard
  final List<Map<String, dynamic>> _allItems = [
    {
      'id': '1',
      'imagePath':
          'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=800',
      'category': 'Tops',
    },
    {
      'id': '2',
      'imagePath':
          'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800',
      'category': 'Bottoms',
    },
    {
      'id': '3',
      'imagePath':
          'https://images.unsplash.com/photo-1594736797933-d0501ba2fe65?w=800',
      'category': 'Dresses',
    },
    {
      'id': '4',
      'imagePath':
          'https://images.unsplash.com/photo-1604176354204-9268737828e4?w=800',
      'category': 'Outerwear',
    },
    {
      'id': '5',
      'imagePath':
          'https://images.unsplash.com/photo-1585487000160-6ebcfceb0d03?w=800',
      'category': 'Shoes',
    },
  ];

  final List<String> _categories = [
    'All',
    'Tops',
    'Bottoms',
    'Dresses',
    'Outerwear',
    'Shoes',
    'Accessories',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Utilisation de NestedScrollView + SliverAppBar → méthode officielle Flutter
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: const Text('My Wardrobe'),
            floating: true,
            pinned: true,
            snap: false,
            centerTitle: false,
            elevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            actions: [
              IconButton(
                icon: CustomIconWidget(iconName: 'search', size: 24),
                onPressed: () =>
                    Fluttertoast.showToast(msg: "Search coming soon!"),
              ),
              SizedBox(width: 2.w),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: theme.colorScheme.tertiary,
              indicatorWeight: 3,
              labelColor: theme.colorScheme.tertiary,
              unselectedLabelColor:
                  theme.colorScheme.onSurface.withOpacity(0.6),
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              tabs: _categories.map((c) => Tab(text: c)).toList(),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: _categories.map((category) {
            final filtered = category == 'All'
                ? _allItems
                : _allItems.where((i) => i['category'] == category).toList();

            if (filtered.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'checkroom',
                      size: 90,
                      color: theme.colorScheme.tertiary.withOpacity(0.25),
                    ),
                    SizedBox(height: 4.h),
                    Text('No $category yet',
                        style: theme.textTheme.headlineSmall),
                    SizedBox(height: 1.5.h),
                    Text(
                      'Tap the + button to add your first item',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: EdgeInsets.all(4.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.w,
                mainAxisSpacing: 4.w,
                childAspectRatio: 0.75,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                return WardrobeItemCard(
                  item: item,
                  onDelete: () {
                    setState(() => _allItems.remove(item));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item['category']} removed'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  onEdit: () =>
                      Fluttertoast.showToast(msg: "Edit coming soon!"),
                );
              },
            );
          }).toList(),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.tertiary,
        elevation: 8,
        onPressed: () => Navigator.pushNamed(context, '/wardrobe-setup'),
        child: CustomIconWidget(
            iconName: 'add_a_photo', color: Colors.white, size: 28),
      ),
    );
  }
}
