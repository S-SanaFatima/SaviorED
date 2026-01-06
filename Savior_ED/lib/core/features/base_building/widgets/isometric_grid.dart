import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Isometric Grid Widget - Creates a Clash of Clans style grid
class IsometricGrid extends StatelessWidget {
  final int gridSize; // e.g., 20x20
  final double cellSize; // Size of each grid cell

  const IsometricGrid({
    super.key,
    required this.gridSize,
    required this.cellSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: IsometricGridPainter(
        gridSize: gridSize,
        cellSize: cellSize,
      ),
      size: Size.infinite,
    );
  }
}

class IsometricGridPainter extends CustomPainter {
  final int gridSize;
  final double cellSize;

  IsometricGridPainter({
    required this.gridSize,
    required this.cellSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw isometric grid
    for (int x = 0; x < gridSize; x++) {
      for (int y = 0; y < gridSize; y++) {
        final isoX = (x - y) * (cellSize / 2);
        final isoY = (x + y) * (cellSize / 4);

        final screenX = centerX + isoX;
        final screenY = centerY + isoY;

        // Draw diamond shape for each cell
        final path = Path();
        path.moveTo(screenX, screenY - cellSize / 2);
        path.lineTo(screenX + cellSize / 2, screenY);
        path.lineTo(screenX, screenY + cellSize / 2);
        path.lineTo(screenX - cellSize / 2, screenY);
        path.close();

        canvas.drawPath(path, paint);
      }
    }

    // Draw center indicator
    final centerPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final centerPath = Path();
    final centerIsoX = (gridSize / 2 - gridSize / 2) * (cellSize / 2);
    final centerIsoY = (gridSize / 2 + gridSize / 2) * (cellSize / 4);
    final centerScreenX = centerX + centerIsoX;
    final centerScreenY = centerY + centerIsoY;

    centerPath.moveTo(centerScreenX, centerScreenY - cellSize / 2);
    centerPath.lineTo(centerScreenX + cellSize / 2, centerScreenY);
    centerPath.lineTo(centerScreenX, centerScreenY + cellSize / 2);
    centerPath.lineTo(centerScreenX - cellSize / 2, centerScreenY);
    centerPath.close();

    canvas.drawPath(centerPath, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

