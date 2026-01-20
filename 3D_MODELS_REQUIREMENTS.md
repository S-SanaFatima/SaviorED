# 3D Models Requirements & Specifications

## 📋 Model List

### Castles (10 Models)

| Level | File Name | Theme | Complexity | Poly Count |
|-------|-----------|-------|------------|------------|
| 1 | `castle_level_1_foundation.obj` | Basic Settlement | Low | 500-1000 |
| 2 | `castle_level_2_expansion.obj` | Growing Village | Low-Medium | 1000-2000 |
| 3 | `castle_level_3_fortification.obj` | Fortress | Medium | 2000-3000 |
| 4 | `castle_level_4_commerce.obj` | Trading Hub | Medium | 2000-3500 |
| 5 | `castle_level_5_production.obj` | Industrial Base | Medium | 2500-4000 |
| 6 | `castle_level_6_defense.obj` | Military Stronghold | Medium-High | 3000-4500 |
| 7 | `castle_level_7_culture.obj` | Cultural Center | Medium-High | 3000-5000 |
| 8 | `castle_level_8_advanced.obj` | Advanced Settlement | High | 4000-6000 |
| 9 | `castle_level_9_master.obj` | Master Fortress | High | 5000-7000 |
| 10 | `castle_level_10_legendary.obj` | Legendary Kingdom | Very High | 6000-10000 |

---

### Inventory Items (50+ Models)

#### Walls (7 Variants)
1. `wall_basic.obj` - Basic wooden wall
2. `wall_medium.obj` - Stone wall
3. `wall_strong.obj` - Reinforced wall
4. `wall_fortress.obj` - Fortress wall
5. `wall_advanced.obj` - Advanced wall
6. `wall_master.obj` - Master wall
7. `wall_legendary.obj` - Legendary wall

**Specifications:**
- Size: 1x1x2 units (width x depth x height)
- Poly Count: 100-300 per wall
- Texture: 512x512

#### Towers (7 Variants)
1. `tower_small.obj` - Small watchtower
2. `tower_watch.obj` - Watchtower
3. `tower_defense.obj` - Defense tower
4. `tower_battle.obj` - Battle tower
5. `tower_advanced.obj` - Advanced tower
6. `tower_master.obj` - Master tower
7. `tower_legendary.obj` - Legendary tower

**Specifications:**
- Size: 2x2x4 units (circular base)
- Poly Count: 200-500 per tower
- Texture: 512x512

#### Gates (6 Variants)
1. `gate_basic.obj` - Basic gate
2. `gate_house.obj` - Gatehouse
3. `gate_defense.obj` - Defense gate
4. `gate_advanced.obj` - Advanced gate
5. `gate_master.obj` - Master gate
6. `gate_legendary.obj` - Legendary gate

**Specifications:**
- Size: 2x1x3 units
- Poly Count: 300-600 per gate
- Texture: 512x512

#### Buildings (20+ Variants)

**Housing:**
- `house_basic.obj`
- `house_medium.obj`
- `house_large.obj`
- `merchant_house.obj`

**Military:**
- `barracks_basic.obj`
- `barracks_advanced.obj`
- `barracks_master.obj`
- `armory.obj`
- `training_ground.obj`
- `training_arena.obj`
- `command_center.obj`

**Production:**
- `workshop_basic.obj`
- `workshop_advanced.obj`
- `workshop_master.obj`
- `forge.obj`
- `quarry.obj`
- `lumber_mill.obj`

**Storage:**
- `storage_shed.obj`
- `warehouse.obj`
- `storage_advanced.obj`
- `storage_master.obj`

**Commercial:**
- `market_stall.obj`
- `trading_post.obj`
- `market_square.obj`

**Cultural:**
- `library.obj`
- `temple.obj`
- `cultural_hall.obj`
- `grand_hall.obj`
- `palace.obj`

**Specifications:**
- Size: Varies (2x2 to 4x4 units)
- Poly Count: 300-1000 per building
- Texture: 512x512 to 1024x1024

#### Decorations (15+ Variants)
- `statue_small.obj`
- `statue_medium.obj`
- `statue_large.obj`
- `fountain_basic.obj`
- `fountain_grand.obj`
- `tree_small.obj`
- `tree_medium.obj`
- `tree_large.obj`
- `garden_small.obj`
- `garden_large.obj`
- `path_straight.obj`
- `path_corner.obj`
- `path_intersection.obj`
- `lighting_torch.obj`
- `lighting_lantern.obj`

**Specifications:**
- Size: 0.5x0.5 to 2x2 units
- Poly Count: 50-200 per decoration
- Texture: 256x256 to 512x512

---

## 📐 Technical Specifications

### File Format
- **Primary**: `.obj` (Wavefront OBJ)
- **Materials**: `.mtl` (Material Template Library)
- **Textures**: `.png` or `.jpg`
- **Alternative**: `.glb` / `.gltf` (for better compression)

### Model Requirements

#### Geometry
- **Format**: Triangles only (no quads or n-gons)
- **Normals**: Per-vertex normals required
- **UV Mapping**: Required for all textured surfaces
- **Origin**: Bottom-center (0, 0, 0) for placement
- **Scale**: 1 unit = 1 meter
- **Orientation**: Y-up, Z-forward

#### Optimization
- **Poly Count**: Keep under specified limits
- **No Duplicate Vertices**: Merge vertices
- **Efficient Topology**: Clean edge loops
- **LOD Versions**: Optional (for performance)

#### Textures
- **Format**: PNG (with alpha) or JPG
- **Size**: 256x256 to 2048x2048 (based on item size)
- **Maps Required**:
  - Diffuse/Albedo (required)
  - Normal (recommended)
  - Specular (optional)
  - AO/Ambient Occlusion (optional)

### Material Properties

```mtl
# Example Material File
newmtl CastleStone
Ka 0.2 0.2 0.2    # Ambient
Kd 0.8 0.7 0.6    # Diffuse
Ks 0.1 0.1 0.1    # Specular
Ns 32.0           # Shininess
map_Kd castle_stone_diffuse.png
map_bump castle_stone_normal.png
```

---

## 📁 File Structure

```
assets/
  models/
    castles/
      castle_level_1_foundation.obj
      castle_level_1_foundation.mtl
      castle_level_1_foundation_diffuse.png
      castle_level_1_foundation_normal.png
      ...
    walls/
      wall_basic.obj
      wall_basic.mtl
      wall_basic_diffuse.png
      ...
    towers/
      tower_small.obj
      ...
    gates/
      gate_basic.obj
      ...
    buildings/
      houses/
      military/
      production/
      storage/
      commercial/
      cultural/
    decorations/
      statues/
      fountains/
      trees/
      gardens/
      paths/
      lighting/
```

---

## 🎨 Art Style Guidelines

### Visual Style
- **Theme**: Medieval/Fantasy castle building
- **Art Style**: Low-poly, stylized (not hyper-realistic)
- **Color Palette**: Warm earth tones, stone grays, wood browns
- **Detail Level**: Moderate (optimized for mobile)

### Consistency
- **Scale**: Consistent across all models
- **Texture Style**: Unified texture style
- **Color Scheme**: Cohesive color palette
- **Detail Density**: Similar detail level

---

## 🔧 Model Creation Workflow

### Step 1: Design
- Sketch concept art
- Define dimensions
- Plan texture layout

### Step 2: Modeling
- Create base mesh in Blender/3DS Max
- Optimize topology
- UV unwrap

### Step 3: Texturing
- Create diffuse texture
- Create normal map (optional)
- Create material file

### Step 4: Export
- Export as .obj
- Include .mtl file
- Export textures

### Step 5: Optimization
- Reduce poly count if needed
- Compress textures
- Test in engine

### Step 6: Integration
- Import to Flutter project
- Test loading
- Verify placement

---

## 📊 Model Statistics

### Total Models Required
- **Castles**: 10
- **Walls**: 7
- **Towers**: 7
- **Gates**: 6
- **Buildings**: 25+
- **Decorations**: 15+
- **Total**: 70+ models

### Estimated File Sizes
- **Castles**: 500KB - 2MB each (with textures)
- **Buildings**: 200KB - 800KB each
- **Walls/Towers**: 100KB - 300KB each
- **Decorations**: 50KB - 200KB each
- **Total Assets**: ~50-100MB

---

## 🎯 Priority Order

### Phase 1 (MVP)
1. Castle Level 1
2. Basic Wall
3. Small Tower
4. Basic Gate
5. Basic House
6. Basic Barracks

### Phase 2 (Level 1-3)
7. Castle Levels 2-3
8. Medium/Strong Walls
9. Watchtower/Defense Tower
10. Gatehouse
11. Additional Buildings

### Phase 3 (Level 4-6)
12. Castle Levels 4-6
13. Advanced Structures
14. Production Buildings
15. Decorations

### Phase 4 (Level 7-10)
16. Castle Levels 7-10
17. Master/Legendary Variants
18. All Remaining Items

---

## 📝 Model Naming Convention

### Format
`{category}_{variant}_{level}.obj`

### Examples
- `castle_level_1_foundation.obj`
- `wall_basic.obj`
- `tower_small.obj`
- `building_barracks_advanced.obj`
- `decoration_statue_small.obj`

### Material Files
- Same name as .obj but .mtl extension
- `castle_level_1_foundation.mtl`

### Textures
- `{model_name}_diffuse.png`
- `{model_name}_normal.png`
- `{model_name}_specular.png`

---

## ✅ Quality Checklist

Before finalizing a model:
- [ ] Poly count within limits
- [ ] UV mapping complete
- [ ] Textures created
- [ ] Material file configured
- [ ] Origin at bottom-center
- [ ] Scale is correct (1 unit = 1 meter)
- [ ] No duplicate vertices
- [ ] Normals calculated
- [ ] Tested in engine
- [ ] Optimized for mobile

---

**This document provides complete specifications for all 3D models needed for the castle base building system.**

