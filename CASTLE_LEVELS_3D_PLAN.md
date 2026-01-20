# Castle Levels & 3D Base System - Implementation Plan

## Overview
A 10-level progression system where players unlock inventory items and place them in their 3D base. Each level is completed by unlocking all required items and placing them correctly.

---

## 🏰 Base System Architecture

### Base Structure
- **Ground/Platform**: 3D terrain where castle and items are placed
- **Grid System**: Placement grid for precise item positioning
- **Camera System**: 3D camera controls (rotate, zoom, pan)
- **Placement Mode**: Toggle between view/edit modes
- **Save State**: Persist base layout to backend

### Base Components
1. **Castle** (Main structure - changes per level)
2. **Walls** (Defensive structures)
3. **Towers** (Defense points)
4. **Buildings** (Resource generators)
5. **Decorations** (Aesthetic items)
6. **Paths/Roads** (Connecting structures)
7. **Resources** (Visual representation of coins/stones/wood)

---

## 📊 Level Progression System

### Level Structure
Each level has:
- **Required Items**: List of inventory items that must be unlocked
- **Castle Model**: Unique 3D castle .obj file
- **Placement Requirements**: Specific items that must be placed
- **Completion Criteria**: All items unlocked + placed correctly
- **Rewards**: XP, coins, stones, wood, new items

### 10 Levels Breakdown

#### **Level 1: Foundation**
- **Theme**: Basic Settlement
- **Castle**: `castle_level_1_foundation.obj`
- **Required Items**:
  - Basic Wall (x4)
  - Small Tower (x2)
  - Gate (x1)
  - Basic House (x1)
- **Completion**: Place all items around castle
- **Rewards**: 100 XP, 50 coins, 20 stones, 10 wood

#### **Level 2: Expansion**
- **Theme**: Growing Village
- **Castle**: `castle_level_2_expansion.obj`
- **Required Items**:
  - Medium Wall (x6)
  - Watchtower (x3)
  - Barracks (x1)
  - Storage Shed (x1)
  - Path Tiles (x10)
- **Completion**: Connect buildings with paths
- **Rewards**: 200 XP, 100 coins, 40 stones, 20 wood

#### **Level 3: Fortification**
- **Theme**: Fortress
- **Castle**: `castle_level_3_fortification.obj`
- **Required Items**:
  - Strong Wall (x8)
  - Defense Tower (x4)
  - Armory (x1)
  - Training Ground (x1)
  - Gatehouse (x1)
  - Barracks (x2)
- **Completion**: Create defensive perimeter
- **Rewards**: 300 XP, 150 coins, 60 stones, 30 wood

#### **Level 4: Commerce**
- **Theme**: Trading Hub
- **Castle**: `castle_level_4_commerce.obj`
- **Required Items**:
  - Market Stall (x3)
  - Trading Post (x1)
  - Warehouse (x1)
  - Merchant House (x2)
  - Market Square (x1)
  - Decorative Fountain (x1)
- **Completion**: Create market area
- **Rewards**: 400 XP, 200 coins, 80 stones, 40 wood

#### **Level 5: Production**
- **Theme**: Industrial Base
- **Castle**: `castle_level_5_production.obj`
- **Required Items**:
  - Workshop (x2)
  - Forge (x1)
  - Quarry (x1)
  - Lumber Mill (x1)
  - Storage Yard (x1)
  - Production Path (x15)
- **Completion**: Connect production buildings
- **Rewards**: 500 XP, 250 coins, 100 stones, 50 wood

#### **Level 6: Defense**
- **Theme**: Military Stronghold
- **Castle**: `castle_level_6_defense.obj`
- **Required Items**:
  - Fortress Wall (x10)
  - Battle Tower (x5)
  - Command Center (x1)
  - Barracks Complex (x2)
  - Training Arena (x1)
  - Weapon Storage (x1)
  - Defense Gate (x2)
- **Completion**: Create military district
- **Rewards**: 600 XP, 300 coins, 120 stones, 60 wood

#### **Level 7: Culture**
- **Theme**: Cultural Center
- **Castle**: `castle_level_7_culture.obj`
- **Required Items**:
  - Library (x1)
  - Temple (x1)
  - Statue (x3)
  - Garden (x2)
  - Plaza (x1)
  - Cultural Hall (x1)
  - Decorative Trees (x10)
- **Completion**: Create cultural district
- **Rewards**: 700 XP, 350 coins, 140 stones, 70 wood

#### **Level 8: Advanced**
- **Theme**: Advanced Settlement
- **Castle**: `castle_level_8_advanced.obj`
- **Required Items**:
  - Advanced Workshop (x2)
  - Research Lab (x1)
  - Advanced Barracks (x2)
  - Advanced Storage (x2)
  - Advanced Tower (x4)
  - Advanced Wall (x12)
  - Command Tower (x1)
- **Completion**: Upgrade all basic structures
- **Rewards**: 800 XP, 400 coins, 160 stones, 80 wood

#### **Level 9: Master**
- **Theme**: Master Fortress
- **Castle**: `castle_level_9_master.obj`
- **Required Items**:
  - Master Castle Gate (x1)
  - Master Tower (x6)
  - Master Wall (x15)
  - Grand Hall (x1)
  - Master Workshop (x1)
  - Master Barracks (x3)
  - Master Storage (x3)
  - Master Decorations (x5)
- **Completion**: Master-level base
- **Rewards**: 900 XP, 450 coins, 180 stones, 90 wood

#### **Level 10: Legendary**
- **Theme**: Legendary Kingdom
- **Castle**: `castle_level_10_legendary.obj`
- **Required Items**:
  - Legendary Castle Core (x1)
  - Legendary Tower (x8)
  - Legendary Wall (x20)
  - Legendary Gate (x2)
  - Grand Palace (x1)
  - Legendary Workshop (x2)
  - Legendary Barracks (x4)
  - Legendary Storage (x4)
  - Legendary Decorations (x10)
  - Legendary Statues (x5)
- **Completion**: Complete legendary kingdom
- **Rewards**: 1000 XP, 500 coins, 200 stones, 100 wood + Special Title

---

## 🎮 3D Inventory System

### Inventory Categories

#### 1. **Structures**
- **Walls**: Basic, Medium, Strong, Fortress, Advanced, Master, Legendary
- **Towers**: Small, Watchtower, Defense, Battle, Advanced, Master, Legendary
- **Gates**: Basic, Gatehouse, Defense, Advanced, Master, Legendary
- **Buildings**: Houses, Barracks, Workshops, Storage, etc.

#### 2. **Decorations**
- Statues
- Fountains
- Trees
- Gardens
- Paths/Roads
- Lighting

#### 3. **Functional Items**
- Resource Generators
- Storage Buildings
- Production Buildings
- Defense Structures

### 3D Model Requirements

#### File Format
- **Primary**: `.obj` (with `.mtl` material files)
- **Alternative**: `.glb` / `.gltf` (for better compression)
- **Textures**: `.png` / `.jpg` (diffuse, normal, specular maps)

#### Model Specifications
- **Poly Count**: 500-5000 triangles per item (optimized for mobile)
- **Texture Size**: 512x512 to 2048x2048 (depending on item size)
- **Scale**: Consistent unit scale (1 unit = 1 meter)
- **Origin**: Bottom-center for placement
- **LOD**: Level of Detail versions (optional)

#### Required 3D Models

**Castles (10 models)**
1. `castle_level_1_foundation.obj`
2. `castle_level_2_expansion.obj`
3. `castle_level_3_fortification.obj`
4. `castle_level_4_commerce.obj`
5. `castle_level_5_production.obj`
6. `castle_level_6_defense.obj`
7. `castle_level_7_culture.obj`
8. `castle_level_8_advanced.obj`
9. `castle_level_9_master.obj`
10. `castle_level_10_legendary.obj`

**Inventory Items (50+ models)**
- Walls (7 variants)
- Towers (7 variants)
- Gates (6 variants)
- Buildings (20+ variants)
- Decorations (15+ variants)
- Paths/Roads (5 variants)

---

## 🛠️ Technical Implementation

### Backend Changes

#### Database Schema

```javascript
// User Base Layout
{
  userId: ObjectId,
  level: Number, // 1-10
  castleModel: String, // Path to castle .obj
  placedItems: [{
    itemId: ObjectId,
    itemTemplateId: ObjectId,
    position: { x: Number, y: Number, z: Number },
    rotation: { x: Number, y: Number, z: Number },
    scale: Number
  }],
  unlockedItems: [ObjectId], // Item template IDs
  completedLevels: [Number], // [1, 2, 3...]
  createdAt: Date,
  updatedAt: Date
}

// Level Requirements
{
  level: Number,
  requiredItems: [{
    itemTemplateId: ObjectId,
    quantity: Number,
    mustPlace: Boolean
  }],
  completionCriteria: {
    allItemsUnlocked: Boolean,
    allItemsPlaced: Boolean,
    specificPlacements: [{
      itemTemplateId: ObjectId,
      positionRange: { min: {x,y,z}, max: {x,y,z} }
    }]
  },
  rewards: {
    xp: Number,
    coins: Number,
    stones: Number,
    wood: Number,
    unlockItems: [ObjectId]
  }
}
```

#### API Endpoints

```
GET    /api/base/my-base              - Get user's base layout
POST   /api/base/place-item          - Place item in base
DELETE /api/base/remove-item/:id      - Remove item from base
PUT    /api/base/update-item/:id      - Update item position/rotation
GET    /api/base/levels/:level        - Get level requirements
POST   /api/base/complete-level       - Complete level and get rewards
GET    /api/base/progress             - Get level progression
```

### Frontend Implementation

#### 3D Rendering
- **Library**: `flutter_3d_controller` or `model_viewer` (WebGL)
- **Alternative**: Custom OpenGL/WebGL implementation
- **Package**: Consider `flutter_gl` or `three_dart` for 3D

#### Key Components

1. **Base3DView**
   - 3D scene renderer
   - Camera controls
   - Touch gestures (rotate, zoom, pan)
   - Grid overlay

2. **ItemPlacementSystem**
   - Drag & drop items
   - Snap to grid
   - Rotation controls
   - Placement validation

3. **Inventory3DPanel**
   - 3D preview of items
   - Category filters
   - Unlock status
   - Drag to place

4. **LevelProgressTracker**
   - Show required items
   - Track unlocked items
   - Track placed items
   - Completion status

---

## 📋 Implementation Phases

### Phase 1: Foundation (Week 1-2)
- [ ] Design base grid system
- [ ] Implement 3D camera controls
- [ ] Create base layout data structure
- [ ] Backend API for base management
- [ ] Basic 3D scene setup

### Phase 2: Inventory System (Week 3-4)
- [ ] 3D model loader
- [ ] Inventory 3D preview
- [ ] Item placement system
- [ ] Save/load base layout
- [ ] Basic item models (5-10 items)

### Phase 3: Level System (Week 5-6)
- [ ] Level requirements system
- [ ] Unlock tracking
- [ ] Placement validation
- [ ] Level completion logic
- [ ] Rewards system

### Phase 4: Castle Models (Week 7-8)
- [ ] Design 10 castle models
- [ ] Create/acquire 3D models
- [ ] Optimize models for mobile
- [ ] Texture creation
- [ ] Integration with base system

### Phase 5: Full Inventory (Week 9-10)
- [ ] Create all inventory item models
- [ ] Categorization system
- [ ] Advanced placement features
- [ ] Visual feedback
- [ ] Polish and optimization

### Phase 6: Testing & Polish (Week 11-12)
- [ ] Level progression testing
- [ ] Performance optimization
- [ ] UI/UX improvements
- [ ] Bug fixes
- [ ] Final polish

---

## 🎨 3D Model Sources

### Options for Obtaining Models

1. **Create Custom Models**
   - Use Blender (free)
   - Hire 3D artist
   - Use AI tools (Meshy, etc.)

2. **Asset Stores**
   - Unity Asset Store
   - Sketchfab
   - TurboSquid
   - CGTrader
   - Free3D

3. **Free Resources**
   - OpenGameArt.org
   - Poly Haven
   - Kenney.nl (game assets)

### Recommended Approach
- **Start**: Use free/low-cost assets for prototyping
- **Polish**: Create custom models for final release
- **Mix**: Combine purchased assets with custom work

---

## 📊 Progress Tracking

### User Progress Data
```dart
class BaseProgress {
  int currentLevel;
  List<int> completedLevels;
  Map<String, int> unlockedItems; // itemId -> quantity
  Map<String, int> placedItems; // itemId -> quantity
  Map<int, LevelProgress> levelProgress; // level -> progress
}

class LevelProgress {
  int level;
  List<String> requiredItems;
  List<String> unlockedItems;
  List<String> placedItems;
  bool isCompleted;
  double completionPercentage;
}
```

### UI Indicators
- Progress bar per level
- Item unlock status (locked/unlocked/placed)
- Level completion badge
- Next level preview

---

## 🎯 Success Metrics

### Completion Criteria
- All 10 levels designed and implemented
- 50+ inventory items with 3D models
- Smooth 3D rendering (60 FPS on mid-range devices)
- Intuitive placement system
- Clear progression feedback

### User Experience Goals
- Easy to understand level requirements
- Satisfying placement mechanics
- Clear visual feedback
- Smooth progression
- Engaging 3D base building

---

## 📝 Next Steps

1. **Approve this plan**
2. **Choose 3D rendering solution** (flutter_gl, three_dart, or WebGL)
3. **Create/acquire first castle model** (Level 1)
4. **Implement basic 3D scene**
5. **Build placement system**
6. **Create level progression logic**
7. **Iterate and expand**

---

**This plan provides a comprehensive roadmap for implementing the 10-level castle progression system with 3D inventory and base building.**

