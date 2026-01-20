import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/placed_item_model.dart';

/// Widget for displaying placed items on the isometric grid
class PlacedItemWidget extends StatelessWidget {
  final PlacedItemModel item;
  final double cellSize;

  const PlacedItemWidget({
    super.key,
    required this.item,
    required this.cellSize,
  });

  @override
  Widget build(BuildContext context) {
    // Convert grid coordinates to isometric screen coordinates
    final centerX = MediaQuery.of(context).size.width / 2;
    final centerY = MediaQuery.of(context).size.height / 2;

    final isoX = (item.gridX - 10) * (cellSize / 2);
    final isoY = (item.gridX + item.gridY - 20) * (cellSize / 4);

    final screenX = centerX + isoX;
    final screenY = centerY + isoY;

    // Get image path based on item type and ID
    String imagePath = _getImagePath(item.itemType, item.itemId);

    return Positioned(
      left: screenX - cellSize / 2,
      top: screenY - cellSize / 2,
      child: Transform.rotate(
        angle: item.rotation * math.pi / 180,
        child: GestureDetector(
          onTap: () {
            // Show item details or options
            _showItemOptions(context);
          },
          child: Container(
            width: cellSize,
            height: cellSize,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if image not found
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.7),
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Icon(
                      _getItemIcon(item.itemType),
                      color: Colors.white,
                      size: cellSize * 0.6,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _getImagePath(String itemType, String itemId) {
    // Map item IDs to image paths
    if (itemType == 'tower') {
      if (itemId == 'tower_level_1') {
        return 'assets/images/level1/tower.png';
      }
    }
    // Add more mappings as needed
    return 'assets/images/level1/tower.png'; // Default
  }

  IconData _getItemIcon(String itemType) {
    switch (itemType) {
      case 'tower':
        return Icons.castle;
      case 'wall':
        return Icons.fence;
      case 'building':
        return Icons.home;
      default:
        return Icons.place;
    }
  }

  void _showItemOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.rotate_right),
              title: const Text('Rotate'),
              onTap: () {
                // Rotate item
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Remove'),
              onTap: () {
                // Remove item
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

