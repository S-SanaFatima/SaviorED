import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';
import '../../../consts/app_colors.dart';
import '../viewmodels/base_building_viewmodel.dart';
import '../widgets/isometric_grid.dart';
import '../widgets/placed_item_widget.dart';

/// Base Building View - Isometric 2.5D like Clash of Clans
class BaseBuildingView extends StatefulWidget {
  const BaseBuildingView({super.key});

  @override
  State<BaseBuildingView> createState() => _BaseBuildingViewState();
}

class _BaseBuildingViewState extends State<BaseBuildingView> {
  double _scale = 1.0;
  double _panX = 0.0;
  double _panY = 0.0;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel =
          Provider.of<BaseBuildingViewModel>(context, listen: false);
      viewModel.loadBase();
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA6B57E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF95A56D),
        elevation: 0,
        title: const Text(
          'BASE BUILDING',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_on, color: Colors.white),
            onPressed: () {
              // Toggle grid visibility
            },
            tooltip: 'Toggle Grid',
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              _showPlaceItemDialog();
            },
            tooltip: 'Place Item',
          ),
        ],
      ),
      body: Consumer<BaseBuildingViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Stack(
            children: [
              // Isometric Base with Grid
              InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.5,
                maxScale: 3.0,
                boundaryMargin: const EdgeInsets.all(100),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFB8D4A0), // Light green
                        Color(0xFFA6B57E), // Medium green
                        Color(0xFF8FA06B), // Dark green
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Isometric Grid
                      IsometricGrid(
                        gridSize: 20,
                        cellSize: 60.0,
                      ),
                      // Placed Items
                      ...viewModel.placedItems.map((item) {
                        return PlacedItemWidget(
                          item: item,
                          cellSize: 60.0,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              // Controls Overlay
              Positioned(
                bottom: 20,
                right: 20,
                child: Column(
                  children: [
                    _buildControlButton(
                      icon: Icons.zoom_in,
                      onPressed: () {
                        _transformationController.value = Matrix4.identity()
                          ..scale(_scale * 1.2);
                        _scale *= 1.2;
                      },
                    ),
                    SizedBox(height: 1.h),
                    _buildControlButton(
                      icon: Icons.zoom_out,
                      onPressed: () {
                        _transformationController.value = Matrix4.identity()
                          ..scale(_scale * 0.8);
                        _scale *= 0.8;
                      },
                    ),
                    SizedBox(height: 1.h),
                    _buildControlButton(
                      icon: Icons.refresh,
                      onPressed: () {
                        _transformationController.value = Matrix4.identity();
                        _scale = 1.0;
                        _panX = 0.0;
                        _panY = 0.0;
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF95A56D)),
        onPressed: onPressed,
      ),
    );
  }

  void _showPlaceItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Place Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Image.asset(
                'assets/images/level1/tower.png',
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.castle);
                },
              ),
              title: const Text('Level 1 Tower'),
              onTap: () {
                Navigator.pop(context);
                _placeTower();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _placeTower() {
    final viewModel =
        Provider.of<BaseBuildingViewModel>(context, listen: false);
    // Place tower at center of grid (10, 10)
    viewModel.placeItem(
      itemType: 'tower',
      itemId: 'tower_level_1',
      gridX: 10,
      gridY: 10,
    );
  }
}

