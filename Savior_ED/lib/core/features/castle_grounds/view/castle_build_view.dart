import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';
import '../viewmodels/castle_grounds_viewmodel.dart';
import '../models/placed_item_model.dart';
import '../../../consts/app_colors.dart';

class CastleBuildView extends StatefulWidget {
  const CastleBuildView({super.key});

  @override
  State<CastleBuildView> createState() => _CastleBuildViewState();
}

class _CastleBuildViewState extends State<CastleBuildView> {
  // PERFECT SYMMETRY CONSTANTS
  final double worldSize = 2000.0;
  final int gridCount = 40;
  final double cellSize = 50.0; // 2000 / 40 = 50.0 (Clean math)

  // THE MEADOW BOUNDARY (Perfectly Centered 40%)
  // Building allowed only in the central 800px area
  final double minValidY = 600.0;
  final double maxValidY = 1400.0;
  final double minValidX = 600.0;
  final double maxValidX = 1400.0;

  List<PlacedItemModel> localPlacedItems = [];
  String? draggingItem;
  Offset? dragGridPos;
  final GlobalKey _worldKey = GlobalKey();
  ui.Image? wallSpriteSheet;

  @override
  void initState() {
    super.initState();
    _loadAssets();
    final castleViewModel = Provider.of<CastleGroundsViewModel>(
      context,
      listen: false,
    );
    if (castleViewModel.castle != null) {
      localPlacedItems = List.from(castleViewModel.castle!.placedItems);
    }
  }

  Future<void> _loadAssets() async {
    final data = await DefaultAssetBundle.of(
      context,
    ).load('assets/images/castle_wall_assets.png');
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    setState(() {
      wallSpriteSheet = frame.image;
    });
  }

  bool _isPositionValid(double wx, double wy) {
    // Add a small buffer (1px) to prevent floating point edge issues
    return wx >= minValidX - 1 &&
        wx <= maxValidX - cellSize + 1 &&
        wy >= minValidY - 1 &&
        wy <= maxValidY - cellSize + 1;
  }

  void _addItem(String type, int gx, int gy) {
    // Math Check before adding (Use world coordinates)
    if (!_isPositionValid(gx * cellSize, gy * cellSize)) return;

    setState(() {
      localPlacedItems.removeWhere(
        (item) => item.gridX == gx && item.gridY == gy,
      );

      final newItem = PlacedItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        itemType: type,
        gridX: gx,
        gridY: gy,
      );
      localPlacedItems.add(newItem);
      if (type == 'wall') _updateWallConnections();
    });
  }

  void _updateWallConnections() {
    for (int i = 0; i < localPlacedItems.length; i++) {
      if (localPlacedItems[i].itemType != 'wall') continue;

      int mask = 0;
      int gx = localPlacedItems[i].gridX;
      int gy = localPlacedItems[i].gridY;

      if (_hasWallAt(gx, gy - 1)) mask |= 1;
      if (_hasWallAt(gx + 1, gy)) mask |= 2;
      if (_hasWallAt(gx, gy + 1)) mask |= 4;
      if (_hasWallAt(gx - 1, gy)) mask |= 8;

      localPlacedItems[i] = localPlacedItems[i].copyWith(bitmask: mask);
    }
  }

  bool _hasWallAt(int gx, int gy) {
    return localPlacedItems.any(
      (item) => item.itemType == 'wall' && item.gridX == gx && item.gridY == gy,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA6B57E),
      appBar: AppBar(
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: const Color(0xFF95A56D).withOpacity(0.8)),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'CASTLE BUILDER',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.save, color: Colors.white, size: 20),
            ),
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final viewModel = Provider.of<CastleGroundsViewModel>(
                context,
                listen: false,
              );
              bool success = await viewModel.saveLayout(localPlacedItems);
              if (success) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Kingdom layout saved!'),
                    backgroundColor: Colors.green,
                  ),
                );
                if (context.mounted) Navigator.pop(context);
              } else {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Error: ${viewModel.errorMessage}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          InteractiveViewer(
            boundaryMargin: EdgeInsets.zero,
            minScale: 0.2, // Increased min scale to keep it symmetrical
            maxScale: 2.5,
            child: Center(
              child: SizedBox(
                width: worldSize,
                height: worldSize,
                child: DragTarget<String>(
                  key: _worldKey,
                  onWillAcceptWithDetails: (details) {
                    setState(() => draggingItem = details.data);
                    return true;
                  },
                  onMove: (details) {
                    final box =
                        _worldKey.currentContext?.findRenderObject()
                            as RenderBox?;
                    if (box != null) {
                      final localPos = box.globalToLocal(details.offset);
                      setState(() {
                        int gx = (localPos.dx / cellSize).floor().clamp(
                          0,
                          gridCount - 1,
                        );
                        int gy = (localPos.dy / cellSize).floor().clamp(
                          0,
                          gridCount - 1,
                        );
                        dragGridPos = Offset(gx.toDouble(), gy.toDouble());
                      });
                    }
                  },
                  onLeave: (data) => setState(() {
                    draggingItem = null;
                    dragGridPos = null;
                  }),
                  onAcceptWithDetails: (details) {
                    final box =
                        _worldKey.currentContext?.findRenderObject()
                            as RenderBox?;
                    if (box != null) {
                      final localPos = box.globalToLocal(details.offset);
                      int gx = (localPos.dx / cellSize).floor().clamp(
                        0,
                        gridCount - 1,
                      );
                      int gy = (localPos.dy / cellSize).floor().clamp(
                        0,
                        gridCount - 1,
                      );
                      _addItem(details.data, gx, gy);
                      setState(() {
                        draggingItem = null;
                        dragGridPos = null;
                      });
                    }
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // 0. The 3D Beauty Border
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/kingdom_boundary_final.png',
                            fit: BoxFit.fill,
                          ),
                        ),

                        // 1. Placement Grid (Symmetry Locked Meadow)
                        Positioned(
                          left: minValidX,
                          top: minValidY,
                          width: maxValidX - minValidX,
                          height: maxValidY - minValidY,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 2.5,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: 0.15,
                                    child: Image.asset(
                                      'assets/images/green_grass_grid_base.png',
                                      repeat: ImageRepeat.repeat,
                                    ),
                                  ),
                                ),
                                // Fine grid lines for Meadow
                                for (
                                  double i = 0;
                                  i < (maxValidX - minValidX);
                                  i += cellSize
                                ) ...[
                                  Positioned(
                                    left: i,
                                    top: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 0.5,
                                      color: Colors.white10,
                                    ),
                                  ),
                                  Positioned(
                                    top: i,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 0.5,
                                      color: Colors.white10,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        // 2. Placed Kingdom Items
                        ...localPlacedItems.map(
                          (item) => Positioned(
                            key: ValueKey(item.id),
                            left: item.gridX * cellSize,
                            top: item.gridY * cellSize,
                            child: _buildPlacedItemWidget(item, false),
                          ),
                        ),

                        // 3. Ghost Visualization
                        if (draggingItem != null && dragGridPos != null)
                          Positioned(
                            left: dragGridPos!.dx * cellSize,
                            top: dragGridPos!.dy * cellSize,
                            child: _buildPlacedItemWidget(
                              PlacedItemModel(
                                id: 'ghost',
                                itemType: draggingItem!,
                                gridX: dragGridPos!.dx.toInt(),
                                gridY: dragGridPos!.dy.toInt(),
                              ),
                              true,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          _buildInventoryDrawer(),
        ],
      ),
    );
  }

  Widget _buildPlacedItemWidget(PlacedItemModel item, bool isGhost) {
    final bool isValid = _isPositionValid(
      item.gridX * cellSize,
      item.gridY * cellSize,
    );

    Widget content;
    if (item.itemType == 'wall') {
      content = _buildWallSprite(item.bitmask, isGhost && !isValid);
    } else {
      content = Icon(
        _getIconFor(item.itemType),
        color: isGhost && !isValid ? Colors.red.withOpacity(0.5) : Colors.white,
        size: cellSize * 1.0, // PERFECT SCALE LOCK
      );
    }

    return Container(
      width: cellSize,
      height: cellSize,
      alignment: Alignment.center,
      child: isGhost
          ? Opacity(opacity: 0.6, child: content)
          : TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) =>
                  Transform.scale(scale: value, child: child),
              child: content,
            ),
    );
  }

  Widget _buildWallSprite(int mask, bool isInvalid) {
    if (wallSpriteSheet == null) {
      return Container(
        width: cellSize,
        height: cellSize,
        color: isInvalid
            ? Colors.red.withOpacity(0.3)
            : Colors.grey.withOpacity(0.3),
      );
    }
    return CustomPaint(
      size: Size(cellSize, cellSize),
      painter: WallPainter(wallSpriteSheet!, mask, isInvalid),
    );
  }

  Widget _buildInventoryDrawer() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: DefaultTabController(
        length: 3,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 22.h,
              color: Colors.black.withOpacity(0.6),
              child: Column(
                children: [
                  TabBar(
                    indicatorColor: AppColors.coinGold,
                    labelColor: AppColors.coinGold,
                    unselectedLabelColor: Colors.white60,
                    indicatorWeight: 3,
                    tabs: [
                      Tab(text: 'BUILD', icon: Icon(Icons.fort, size: 20)),
                      Tab(text: 'NATURE', icon: Icon(Icons.park, size: 20)),
                      Tab(
                        text: 'DECOR',
                        icon: Icon(Icons.auto_awesome, size: 20),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildCategoryList(['wall', 'tower', 'gate']),
                        _buildCategoryList(['tree', 'rock', 'bush']),
                        _buildCategoryList(['statue', 'bench', 'fountain']),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(List<String> items) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      children: items
          .map((type) => _buildInvItem(_getIconFor(type), type))
          .toList(),
    );
  }

  IconData _getIconFor(String type) {
    switch (type) {
      case 'wall':
        return Icons.view_agenda;
      case 'tower':
        return Icons.fort;
      case 'gate':
        return Icons.door_front_door;
      case 'tree':
        return Icons.park;
      case 'rock':
        return Icons.landscape;
      case 'bush':
        return Icons.grass;
      case 'statue':
        return Icons.person_pin;
      case 'bench':
        return Icons.chair_alt;
      case 'fountain':
        return Icons.water;
      default:
        return Icons.help;
    }
  }

  Widget _buildInvItem(IconData icon, String type) {
    return Draggable<String>(
      data: type,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.8,
          child: Transform.scale(
            scale: 1.2,
            child: _buildItemIcon(icon, true, type),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildItemIcon(icon, false, type),
      ),
      child: _buildItemIcon(icon, false, type),
    );
  }

  Widget _buildItemIcon(IconData icon, bool isSelected, String type) {
    return Container(
      margin: EdgeInsets.only(right: 5.w),
      width: 22.w,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.coinGold : Colors.white10,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24.sp),
          SizedBox(height: 1.h),
          Text(
            type.toUpperCase(),
            style: TextStyle(
              color: Colors.white70,
              fontSize: 8.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class WallPainter extends CustomPainter {
  final ui.Image image;
  final int mask;
  final bool isInvalid;
  WallPainter(this.image, this.mask, this.isInvalid);

  @override
  void paint(Canvas canvas, Size size) {
    final double sw = image.width / 4;
    final double sh = image.height / 2;

    int index = 0;
    if (mask == 1)
      index = 1;
    else if (mask == 2)
      index = 2;
    else if (mask == 4)
      index = 3;
    else if (mask == 8)
      index = 4;
    else if (mask == 5)
      index = 5;
    else if (mask == 10)
      index = 6;
    else if (mask != 0)
      index = 7;

    final int col = index % 4;
    final int row = index ~/ 4;

    final src = Rect.fromLTWH(col * sw, row * sh, sw, sh);
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);

    final paint = Paint()..filterQuality = ui.FilterQuality.high;
    if (isInvalid) {
      paint.colorFilter = const ColorFilter.mode(
        Colors.red,
        BlendMode.modulate,
      );
    }

    canvas.drawImageRect(image, src, dst, paint);
  }

  @override
  bool shouldRepaint(covariant WallPainter oldDelegate) =>
      oldDelegate.mask != mask ||
      oldDelegate.isInvalid != isInvalid ||
      oldDelegate.image != image;
}
