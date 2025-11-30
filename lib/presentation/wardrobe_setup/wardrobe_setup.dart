import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/camera_capture_sheet.dart';
import './widgets/category_selection_sheet.dart';
import './widgets/empty_wardrobe_card.dart';
import './widgets/wardrobe_item_card.dart';

class WardrobeSetup extends StatefulWidget {
  const WardrobeSetup({super.key});

  @override
  State<WardrobeSetup> createState() => _WardrobeSetupState();
}

class _WardrobeSetupState extends State<WardrobeSetup> {
  // Camera controller
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();

  // Wardrobe items storage
  final List<Map<String, dynamic>> _wardrobeItems = [];

  // Clothing categories
  final List<String> _categories = [
    'Tops',
    'Bottoms',
    'Dresses',
    'Outerwear',
    'Shoes',
    'Accessories',
  ];

  // Progress tracking
  int get _itemCount => _wardrobeItems.length;
  double get _progress => (_itemCount / 10).clamp(0.0, 1.0);
  bool get _canContinue => _itemCount >= 5;

  // Loading state
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  /// Initialize camera with platform detection
  Future<void> _initializeCamera() async {
    try {
      // Request camera permission
      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) {
        _showPermissionDialog();
        return;
      }

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        return;
      }

      // Select appropriate camera based on platform
      final camera = kIsWeb
          ? _cameras!.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras!.first,
            )
          : _cameras!.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras!.first,
            );

      // Initialize camera controller
      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      // Apply platform-specific settings
      await _applyCameraSettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  /// Request camera permission
  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Apply camera settings (skip unsupported features on web)
  Future<void> _applyCameraSettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {
      debugPrint('Focus mode not supported: $e');
    }

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {
        debugPrint('Flash mode not supported: $e');
      }
    }
  }

  /// Show permission dialog
  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Camera Permission Required',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'StyleCast needs camera access to capture your clothing items for personalized outfit recommendations.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Open camera capture sheet
  void _openCameraCapture({String? suggestedCategory}) {
    if (!_isCameraInitialized || _cameraController == null) {
      _showErrorSnackBar('Camera not available. Please try again.');
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CameraCaptureSheet(
        cameraController: _cameraController!,
        suggestedCategory: suggestedCategory,
        onCapture: _handlePhotoCapture,
      ),
    );
  }

  /// Handle photo capture
  Future<void> _handlePhotoCapture(XFile photo, String? category) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Simulate AI categorization delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Auto-detect category (simulated)
      final detectedCategory = category ?? _detectCategory();

      // Show category selection sheet
      if (mounted) {
        final selectedCategory = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => CategorySelectionSheet(
            detectedCategory: detectedCategory,
            categories: _categories,
          ),
        );

        if (selectedCategory != null) {
          // Add item to wardrobe
          setState(() {
            _wardrobeItems.add({
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'imagePath': photo.path,
              'category': selectedCategory,
              'timestamp': DateTime.now(),
            });
            _isProcessing = false;
          });

          _showSuccessSnackBar('Item added to wardrobe!');
        } else {
          setState(() {
            _isProcessing = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showErrorSnackBar('Failed to process photo. Please try again.');
    }
  }

  /// Simulate AI category detection
  String _detectCategory() {
    final random = DateTime.now().millisecond % _categories.length;
    return _categories[random];
  }

  /// Pick image from gallery
  Future<void> _pickFromGallery({String? suggestedCategory}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        await _handlePhotoCapture(image, suggestedCategory);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image. Please try again.');
    }
  }

  /// Delete wardrobe item
  void _deleteItem(String itemId) {
    setState(() {
      _wardrobeItems.removeWhere((item) => item['id'] == itemId);
    });
    _showSuccessSnackBar('Item removed from wardrobe');
  }

  /// Show category selection for empty card
  void _showCategoryOptions(String category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Add $category',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 3.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 24,
                ),
                title: Text(
                  'Take Photo',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _openCameraCapture(suggestedCategory: category);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'photo_library',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 24,
                ),
                title: Text(
                  'Choose from Gallery',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery(suggestedCategory: category);
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Navigate to home dashboard
  void _continueToHome() {
    Navigator.pushReplacementNamed(context, '/home-dashboard');
  }

  /// Skip wardrobe setup
  void _skipSetup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Skip Wardrobe Setup?',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'You can add items to your wardrobe later from your profile. However, outfit recommendations will be limited without wardrobe data.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _continueToHome();
            },
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }

  /// Show success snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Build Your Wardrobe',
        variant: AppBarVariant.standard,
        actions: [
          CustomAppBarAction(
            icon: Icons.close,
            tooltip: 'Skip for Now',
            onPressed: _skipSetup,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            _buildProgressSection(),

            // Main content
            Expanded(
              child: _isProcessing
                  ? _buildLoadingState()
                  : _buildWardrobeGrid(),
            ),

            // Continue button
            if (_canContinue) _buildContinueButton(),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: CustomBottomBar(
        currentItem: BottomNavItem.wardrobe,
        onItemTapped: (item) {
          // Handle navigation
        },
      ),
    );
  }

  /// Build progress section
  Widget _buildProgressSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_itemCount of 10 items',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              Text(
                '${(_progress * 100).toInt()}%',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 0.8.h,
              backgroundColor: AppTheme.lightTheme.colorScheme.outlineVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.tertiary,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _itemCount < 5
                ? 'Add at least 5 items to continue'
                : 'Great! Add more items for better recommendations',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Build wardrobe grid
  Widget _buildWardrobeGrid() {
    return RefreshIndicator(
      onRefresh: () async {
        // Simulate re-analysis
        await Future.delayed(const Duration(seconds: 1));
        _showSuccessSnackBar('Wardrobe re-analyzed');
      },
      child: GridView.builder(
        padding: EdgeInsets.all(4.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 2.h,
          childAspectRatio: 0.75,
        ),
        itemCount: _wardrobeItems.length + _categories.length,
        itemBuilder: (context, index) {
          if (index < _wardrobeItems.length) {
            // Existing wardrobe item
            final item = _wardrobeItems[index];
            return WardrobeItemCard(
              item: item,
              onDelete: () => _deleteItem(item['id']),
              onEdit: () => _showCategoryOptions(item['category']),
            );
          } else {
            // Empty card for category
            final categoryIndex = index - _wardrobeItems.length;
            if (categoryIndex < _categories.length) {
              return EmptyWardrobeCard(
                category: _categories[categoryIndex],
                onTap: () => _showCategoryOptions(_categories[categoryIndex]),
              );
            }
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.tertiary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Analyzing clothing item...',
            style: AppTheme.lightTheme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  /// Build floating action button
  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _openCameraCapture(),
      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      icon: CustomIconWidget(
        iconName: 'camera_alt',
        color: AppTheme.lightTheme.colorScheme.onTertiary,
        size: 24,
      ),
      label: Text(
        'Add Item',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onTertiary,
        ),
      ),
    );
  }

  /// Build continue button
  Widget _buildContinueButton() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _continueToHome,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 2.h),
          ),
          child: const Text('Continue to StyleCast'),
        ),
      ),
    );
  }
}
