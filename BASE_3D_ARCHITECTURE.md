# 3D Base Architecture & Technical Design

## 🏗️ Base System Overview

The 3D base system allows players to build and customize their castle grounds by placing unlocked inventory items in a 3D environment.

---

## 📐 Base Grid System

### Grid Specifications
- **Grid Size**: 20x20 units (configurable per level)
- **Cell Size**: 1x1 unit (1 meter)
- **Grid Type**: Square grid with snap-to-grid placement
- **Height Levels**: Multi-level support (ground, elevated platforms)

### Grid Coordinates
```dart
class GridPosition {
  int x;  // -10 to +10
  int z;  // -10 to +10
  int y;  // Height level (0 = ground, 1+ = elevated)
  
  Vector3 toWorldPosition() {
    return Vector3(x.toDouble(), y.toDouble(), z.toDouble());
  }
}
```

---

## 🎮 3D Rendering Architecture

### Recommended Flutter Packages

#### Option 1: flutter_gl (Recommended)
```yaml
dependencies:
  flutter_gl: ^0.0.1
  openGL_es: ^0.0.1
```
- **Pros**: Native OpenGL ES, good performance
- **Cons**: Complex setup, requires native code

#### Option 2: model_viewer (WebGL)
```yaml
dependencies:
  model_viewer: ^0.8.0
```
- **Pros**: Easy to use, WebGL-based
- **Cons**: WebView dependency, may have performance issues

#### Option 3: Custom WebGL (Best for Production)
- Use `dart:html` for web
- Use platform channels for native
- Full control over rendering

### 3D Scene Structure

```dart
class Base3DScene {
  // Camera
  CameraController camera;
  
  // Lighting
  List<Light> lights;
  
  // Objects
  List<PlacedItem3D> placedItems;
  CastleModel? castle;
  GridRenderer grid;
  
  // Environment
  Skybox skybox;
  Terrain terrain;
}
```

### Camera System

```dart
class CameraController {
  Vector3 position;
  Vector3 target;
  double distance;
  double rotationX;
  double rotationY;
  
  // Controls
  void rotate(double deltaX, double deltaY);
  void zoom(double delta);
  void pan(double deltaX, double deltaZ);
  void reset();
  void focusOn(Vector3 position);
}
```

---

## 📦 3D Model Loading System

### Model Loader Interface

```dart
abstract class ModelLoader {
  Future<Model3D> loadModel(String path);
  Future<void> preloadModels(List<String> paths);
  void dispose();
}

class OBJModelLoader implements ModelLoader {
  Future<Model3D> loadModel(String path) async {
    // Load .obj file
    // Parse vertices, faces, normals, UVs
    // Load .mtl material file
    // Load textures
    // Return Model3D object
  }
}
```

### Model3D Class

```dart
class Model3D {
  String id;
  String name;
  List<Mesh> meshes;
  List<Material> materials;
  BoundingBox bounds;
  Vector3 pivotPoint; // Bottom center for placement
  
  // Rendering
  void render(Matrix4 transform);
  void dispose();
}
```

### Model Caching

```dart
class ModelCache {
  static final Map<String, Model3D> _cache = {};
  
  static Future<Model3D> getModel(String path) async {
    if (_cache.containsKey(path)) {
      return _cache[path]!;
    }
    final model = await ModelLoader().loadModel(path);
    _cache[path] = model;
    return model;
  }
  
  static void preload(List<String> paths) {
    // Preload models in background
  }
}
```

---

## 🎯 Item Placement System

### Placement State

```dart
enum PlacementMode {
  view,      // Just viewing
  place,     // Placing new item
  edit,      // Editing existing item
  delete     // Deleting item
}

class PlacementController {
  PlacementMode mode;
  ItemTemplate? selectedItem;
  PlacedItem? editingItem;
  GridPosition? hoverPosition;
  bool isValidPlacement;
  
  void startPlacement(ItemTemplate item);
  void cancelPlacement();
  void confirmPlacement();
  void updateHover(GridPosition position);
  bool validatePlacement(GridPosition position, ItemTemplate item);
}
```

### Placement Validation

```dart
class PlacementValidator {
  bool canPlace({
    required GridPosition position,
    required ItemTemplate item,
    required List<PlacedItem> existingItems,
    required BaseLayout layout,
  }) {
    // Check grid bounds
    if (!isWithinBounds(position, item.size)) return false;
    
    // Check overlaps
    if (hasOverlap(position, item.size, existingItems)) return false;
    
    // Check level requirements
    if (!meetsLevelRequirements(item, layout.level)) return false;
    
    // Check dependencies (e.g., wall must connect to another wall)
    if (!meetsDependencies(item, existingItems)) return false;
    
    return true;
  }
}
```

### Placed Item Data

```dart
class PlacedItem {
  String id;
  String itemTemplateId;
  GridPosition position;
  double rotationY; // Rotation around Y axis (0-360)
  double scale;    // Scale factor (default 1.0)
  DateTime placedAt;
  
  // 3D representation
  Model3D? model;
  Matrix4 get transformMatrix {
    return Matrix4.identity()
      ..translate(position.x, position.y, position.z)
      ..rotateY(rotationY * pi / 180)
      ..scale(scale);
  }
}
```

---

## 🏰 Castle Model System

### Castle Data

```dart
class CastleModel {
  int level;
  String modelPath; // Path to .obj file
  Vector3 position; // Center position
  Vector3 size;     // Bounding box size
  Model3D? model;
  
  // Level-specific properties
  Map<String, dynamic> properties;
}
```

### Castle Loading

```dart
class CastleManager {
  static Future<CastleModel> loadCastle(int level) async {
    final castle = CastleModel(
      level: level,
      modelPath: 'assets/models/castles/castle_level_$level.obj',
      position: Vector3.zero(),
    );
    castle.model = await ModelCache.getModel(castle.modelPath);
    return castle;
  }
}
```

---

## 📊 Level Progression System

### Level Requirements

```dart
class LevelRequirements {
  int level;
  String name;
  String description;
  List<ItemRequirement> requiredItems;
  PlacementRequirements placementRequirements;
  Rewards rewards;
  
  bool isCompleted(BaseLayout layout) {
    // Check all items unlocked
    if (!allItemsUnlocked(layout)) return false;
    
    // Check all items placed
    if (!allItemsPlaced(layout)) return false;
    
    // Check specific placement requirements
    if (!meetsPlacementRequirements(layout)) return false;
    
    return true;
  }
}

class ItemRequirement {
  String itemTemplateId;
  int quantity;
  bool mustPlace; // Must be placed to complete level
}
```

### Level Progress Tracking

```dart
class LevelProgress {
  int level;
  List<String> unlockedItems;
  List<String> placedItems;
  Map<String, int> itemCounts; // itemId -> count
  
  double get completionPercentage {
    final total = requiredItems.length;
    final completed = placedItems.length;
    return completed / total;
  }
  
  bool get isCompleted {
    return completionPercentage >= 1.0;
  }
}
```

---

## 💾 Data Persistence

### Base Layout Model

```dart
class BaseLayout {
  String userId;
  int level;
  String castleModelPath;
  List<PlacedItem> placedItems;
  List<String> unlockedItems;
  List<int> completedLevels;
  DateTime lastUpdated;
  
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'level': level,
      'castleModelPath': castleModelPath,
      'placedItems': placedItems.map((e) => e.toJson()).toList(),
      'unlockedItems': unlockedItems,
      'completedLevels': completedLevels,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
```

### Backend API Integration

```dart
class BaseService {
  Future<BaseLayout> getMyBase() async {
    final response = await ApiService().get('/api/base/my-base');
    return BaseLayout.fromJson(response.data);
  }
  
  Future<void> placeItem(PlacedItem item) async {
    await ApiService().post('/api/base/place-item', data: item.toJson());
  }
  
  Future<void> removeItem(String itemId) async {
    await ApiService().delete('/api/base/remove-item/$itemId');
  }
  
  Future<LevelProgress> completeLevel(int level) async {
    final response = await ApiService().post('/api/base/complete-level', data: {'level': level});
    return LevelProgress.fromJson(response.data);
  }
}
```

---

## 🎨 UI Components

### Base3DView Widget

```dart
class Base3DView extends StatefulWidget {
  @override
  State<Base3DView> createState() => _Base3DViewState();
}

class _Base3DViewState extends State<Base3DView> {
  Base3DScene scene;
  CameraController camera;
  PlacementController placement;
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 3D Scene
        ModelViewer(
          scene: scene,
          camera: camera,
          onTap: _handleTap,
          onDrag: _handleDrag,
        ),
        
        // UI Overlays
        PlacementUI(controller: placement),
        LevelProgressUI(),
        InventoryPanel(),
      ],
    );
  }
}
```

### Inventory3DPanel

```dart
class Inventory3DPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            CategoryFilter(),
            GridView.builder(
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) {
                final item = viewModel.items[index];
                return InventoryItemCard(
                  item: item,
                  isUnlocked: viewModel.isUnlocked(item.id),
                  onTap: () => _startPlacement(item),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
```

---

## 🚀 Performance Optimization

### Rendering Optimizations

1. **Frustum Culling**: Only render visible objects
2. **Level of Detail (LOD)**: Use simpler models when far away
3. **Instancing**: Batch render identical items
4. **Texture Compression**: Use compressed texture formats
5. **Occlusion Culling**: Don't render hidden objects

### Memory Management

```dart
class ResourceManager {
  static void unloadUnusedModels() {
    // Unload models not in current scene
  }
  
  static void preloadNextLevel() {
    // Preload next level models in background
  }
}
```

---

## 📱 Touch Controls

### Gesture Handling

```dart
class Base3DGestures {
  // Rotate camera
  void onPanUpdate(DragUpdateDetails details) {
    camera.rotate(details.delta.dx, details.delta.dy);
  }
  
  // Zoom
  void onScaleUpdate(ScaleUpdateDetails details) {
    camera.zoom(details.scale);
  }
  
  // Tap to place/select
  void onTap(TapDownDetails details) {
    final worldPos = screenToWorld(details.localPosition);
    if (placement.mode == PlacementMode.place) {
      placement.confirmPlacement(worldPos);
    }
  }
}
```

---

## 🎯 Next Implementation Steps

1. **Choose 3D rendering solution**
2. **Create basic 3D scene with camera**
3. **Implement grid system**
4. **Load first castle model**
5. **Implement item placement**
6. **Add level progression logic**
7. **Integrate with backend**
8. **Polish UI/UX**

---

**This architecture provides the technical foundation for the 3D base building system.**

