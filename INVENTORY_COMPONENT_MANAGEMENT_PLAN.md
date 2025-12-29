# 📦 Inventory & Component Management System - Implementation Plan

## 🎯 Overview

This document outlines the complete plan for implementing an Inventory and Component Management system for the SaviorED application. This system will allow users to track, manage, and utilize items, resources, badges, and components they collect throughout their learning journey.

---

## 📋 Table of Contents

1. [System Architecture](#system-architecture)
2. [Database Models](#database-models)
3. [Backend API Endpoints](#backend-api-endpoints)
4. [Frontend Components](#frontend-components)
5. [Features & Functionality](#features--functionality)
6. [Implementation Phases](#implementation-phases)
7. [UI/UX Design](#uiux-design)

---

## 🏗️ System Architecture

### Core Concepts

1. **Inventory Items**: Collectible items users can earn and store
2. **Components**: Resources used for crafting/upgrading (coins, stones, wood, special components)
3. **Badges/Rewards**: Achievement badges from treasure chests
4. **Equipment**: Items that can be equipped/used for bonuses
5. **Resources**: Currency and materials (coins, stones, wood)

### System Components

```
Inventory System
├── Items (Collectibles, Equipment, Consumables)
├── Resources (Coins, Stones, Wood, Special Materials)
├── Badges (Treasure Chest Rewards)
├── Components (Building Materials, Crafting Items)
└── Equipment (Items that provide bonuses)
```

---

## 📊 Database Models

### 1. Item Model (`Item.model.js`)

```javascript
{
  userId: ObjectId (ref: User),
  itemId: String, // Reference to ItemTemplate
  quantity: Number,
  category: String, // 'collectible', 'equipment', 'consumable', 'component'
  rarity: String, // 'common', 'rare', 'epic', 'legendary'
  obtainedAt: Date,
  lastUsedAt: Date,
  metadata: {
    // Item-specific data (stats, bonuses, etc.)
  }
}
```

### 2. ItemTemplate Model (`ItemTemplate.model.js`)

```javascript
{
  itemId: String (unique),
  name: String,
  description: String,
  category: String,
  rarity: String,
  iconName: String, // Icon identifier
  colorHex: String,
  stackable: Boolean,
  maxStack: Number,
  sellable: Boolean,
  sellPrice: Number,
  buyable: Boolean,
  buyPrice: Number,
  usable: Boolean,
  useEffect: {
    type: String, // 'bonus', 'consumable', 'upgrade'
    value: Number,
    duration: Number // For temporary effects
  },
  craftingRecipe: {
    // If craftable, list required components
    components: [{ itemId: String, quantity: Number }],
    resultQuantity: Number
  }
}
```

### 3. UserInventory Model (Alternative: extend User model)

```javascript
// Or add to existing User model
{
  inventory: {
    items: [{
      itemId: String,
      quantity: Number,
      obtainedAt: Date
    }],
    maxSlots: Number,
    unlockedSlots: Number
  },
  equipment: {
    // Slots for equipped items
    helmet: String, // itemId
    armor: String,
    accessory: String,
    // etc.
  }
}
```

---

## 🔌 Backend API Endpoints

### Inventory Endpoints

#### 1. Get User Inventory
```
GET /api/inventory
Authorization: Bearer {token}

Response:
{
  "success": true,
  "inventory": {
    "items": [
      {
        "id": "item_instance_id",
        "itemId": "item_template_id",
        "name": "Item Name",
        "quantity": 5,
        "category": "collectible",
        "rarity": "rare",
        "iconName": "star",
        "colorHex": "#FFD700",
        "obtainedAt": "2024-01-01T10:00:00.000Z"
      }
    ],
    "totalItems": 25,
    "maxSlots": 50,
    "unlockedSlots": 30
  }
}
```

#### 2. Get Item Details
```
GET /api/inventory/items/:itemId
Authorization: Bearer {token}
```

#### 3. Use Item
```
POST /api/inventory/items/:itemId/use
Authorization: Bearer {token}

Request Body:
{
  "quantity": 1 // Optional, defaults to 1
}

Response:
{
  "success": true,
  "message": "Item used successfully",
  "effect": {
    "type": "bonus",
    "value": 10,
    "duration": 3600
  },
  "remainingQuantity": 4
}
```

#### 4. Discard Item
```
DELETE /api/inventory/items/:itemId
Authorization: Bearer {token}

Request Body:
{
  "quantity": 1 // Optional, defaults to all
}
```

#### 5. Get Item Templates (Catalogue)
```
GET /api/inventory/templates?category=all&rarity=all
Authorization: Bearer {token}
```

### Component Management Endpoints

#### 6. Get Components
```
GET /api/components
Authorization: Bearer {token}

Response:
{
  "success": true,
  "components": {
    "resources": {
      "coins": 1500,
      "stones": 800,
      "wood": 500
    },
    "materials": [
      {
        "itemId": "iron_ore",
        "name": "Iron Ore",
        "quantity": 25,
        "iconName": "ore",
        "colorHex": "#8B4513"
      }
    ]
  }
}
```

#### 7. Craft Item
```
POST /api/components/craft
Authorization: Bearer {token}

Request Body:
{
  "itemId": "sword",
  "quantity": 1
}

Response:
{
  "success": true,
  "message": "Item crafted successfully",
  "craftedItem": {
    "itemId": "sword",
    "quantity": 1
  },
  "consumedComponents": [
    {"itemId": "iron_ore", "quantity": 5},
    {"itemId": "wood", "quantity": 2}
  ]
}
```

#### 8. Transfer Resources
```
POST /api/components/transfer
Authorization: Bearer {token}

Request Body:
{
  "from": "inventory",
  "to": "castle",
  "itemId": "coins",
  "quantity": 100
}
```

### Equipment Endpoints

#### 9. Get Equipped Items
```
GET /api/equipment
Authorization: Bearer {token}
```

#### 10. Equip Item
```
POST /api/equipment/equip
Authorization: Bearer {token}

Request Body:
{
  "itemId": "helmet_rare",
  "slot": "helmet"
}
```

#### 11. Unequip Item
```
POST /api/equipment/unequip
Authorization: Bearer {token}

Request Body:
{
  "slot": "helmet"
}
```

---

## 🎨 Frontend Components

### Directory Structure

```
lib/core/features/inventory/
├── models/
│   ├── inventory_item_model.dart
│   ├── item_template_model.dart
│   └── component_model.dart
├── viewmodels/
│   ├── inventory_viewmodel.dart
│   ├── component_viewmodel.dart
│   └── equipment_viewmodel.dart
├── views/
│   ├── inventory_view.dart
│   ├── component_view.dart
│   ├── item_detail_view.dart
│   └── crafting_view.dart
└── widgets/
    ├── inventory_item_card.dart
    ├── component_card.dart
    ├── equipment_slot.dart
    └── item_category_filter.dart
```

### Key Flutter Models

#### InventoryItemModel
```dart
class InventoryItemModel {
  final String id;
  final String itemId;
  final String name;
  final String description;
  final int quantity;
  final String category; // collectible, equipment, consumable, component
  final String rarity; // common, rare, epic, legendary
  final String iconName;
  final String colorHex;
  final DateTime? obtainedAt;
  final DateTime? lastUsedAt;
  final Map<String, dynamic>? metadata;
}
```

#### ComponentModel
```dart
class ComponentModel {
  final Map<String, int> resources; // coins, stones, wood
  final List<InventoryItemModel> materials;
}
```

---

## ✨ Features & Functionality

### Phase 1: Basic Inventory (MVP)

1. **View Inventory**
   - List all items user owns
   - Filter by category (collectibles, equipment, consumables, components)
   - Filter by rarity
   - Search items by name
   - Sort by name, quantity, rarity, date obtained

2. **Item Details**
   - View item information
   - See quantity owned
   - View item stats/effects
   - See where item was obtained

3. **Resource Display**
   - Show coins, stones, wood
   - Show special materials
   - Resource summary card

### Phase 2: Item Management

1. **Use Items**
   - Use consumable items
   - Apply temporary bonuses
   - Equip/unequip items

2. **Discard Items**
   - Remove items from inventory
   - Confirm before discarding

3. **Item Stacking**
   - Stack identical items
   - Visual representation of stack size

### Phase 3: Component System

1. **Component Tracking**
   - Track crafting materials
   - Show component quantities
   - Component sources/obtainment methods

2. **Crafting System**
   - Craft items from components
   - View crafting recipes
   - Craft multiple items
   - Preview required components

3. **Resource Management**
   - Transfer resources between inventory and castle
   - Resource exchange/trading (future)

### Phase 4: Equipment System

1. **Equipment Slots**
   - Helmet, Armor, Accessory slots
   - Visual equipment slots
   - Equipment bonuses display

2. **Equipment Effects**
   - Apply bonuses to user stats
   - Visual indicators of active bonuses
   - Equipment sets (future)

### Phase 5: Advanced Features

1. **Item Categories**
   - Collectibles (achievement items)
   - Equipment (wearable items with stats)
   - Consumables (one-time use items)
   - Components (crafting materials)

2. **Rarity System**
   - Common (Gray)
   - Rare (Blue)
   - Epic (Purple)
   - Legendary (Gold)

3. **Item Obtainment**
   - From treasure chests
   - From focus sessions
   - From achievements
   - From purchases (future)

---

## 🎯 Implementation Phases

### Phase 1: Backend Foundation (Week 1)

- [ ] Create ItemTemplate model
- [ ] Create UserInventory model (or extend User)
- [ ] Create Item model for user items
- [ ] Create inventory routes
- [ ] Create component routes
- [ ] Seed initial item templates
- [ ] Integrate with treasure chest system (award items)
- [ ] Integrate with focus session completion (award items)

### Phase 2: Basic Inventory UI (Week 2)

- [ ] Create inventory models in Flutter
- [ ] Create inventory viewmodel
- [ ] Create inventory view (list items)
- [ ] Create item detail view
- [ ] Add inventory navigation to app
- [ ] Display resources (coins, stones, wood)

### Phase 3: Item Management (Week 3)

- [ ] Implement use item functionality
- [ ] Implement discard item functionality
- [ ] Add item filtering and sorting
- [ ] Add search functionality
- [ ] Improve item cards UI

### Phase 4: Component System (Week 4)

- [ ] Create component viewmodel
- [ ] Create component view
- [ ] Implement crafting system backend
- [ ] Implement crafting UI
- [ ] Add component tracking

### Phase 5: Equipment System (Week 5)

- [ ] Create equipment model
- [ ] Create equipment viewmodel
- [ ] Create equipment view
- [ ] Implement equip/unequip functionality
- [ ] Apply equipment bonuses

### Phase 6: Polish & Integration (Week 6)

- [ ] Add animations
- [ ] Improve UI/UX
- [ ] Add notifications for new items
- [ ] Integration testing
- [ ] Performance optimization

---

## 🎨 UI/UX Design

### Inventory View

```
┌─────────────────────────────────────┐
│  ← Back    INVENTORY      Filter ⚙️ │
├─────────────────────────────────────┤
│  Resources:                          │
│  [💰 1500] [🪨 800] [🪵 500]        │
├─────────────────────────────────────┤
│  [All] [Collectibles] [Equipment]   │
│  [Consumables] [Components]         │
├─────────────────────────────────────┤
│  ┌──────┐ ┌──────┐ ┌──────┐        │
│  │ ⭐   │ │ 🏆   │ │ ⚔️   │        │
│  │ Star │ │ Badge│ │Sword │        │
│  │ x5   │ │ x1   │ │ x2   │        │
│  └──────┘ └──────┘ └──────┘        │
│  ┌──────┐ ┌──────┐ ┌──────┐        │
│  │ 📜   │ │ 💎   │ │ 🔧   │        │
│  │ Scroll│ │Gem  │ │ Tool │        │
│  │ x3   │ │ x1   │ │ x10  │        │
│  └──────┘ └──────┘ └──────┘        │
│  ...                                 │
└─────────────────────────────────────┘
```

### Item Detail View

```
┌─────────────────────────────────────┐
│  ← Back                             │
├─────────────────────────────────────┤
│         [Large Item Icon]            │
│          Item Name                   │
│         Rarity Badge                 │
├─────────────────────────────────────┤
│  Description:                        │
│  This item provides...               │
├─────────────────────────────────────┤
│  Quantity Owned: 5                   │
│  Obtained: Jan 1, 2024               │
├─────────────────────────────────────┤
│  [Use Item] [Discard]                │
└─────────────────────────────────────┘
```

### Component View

```
┌─────────────────────────────────────┐
│  ← Back    COMPONENTS               │
├─────────────────────────────────────┤
│  Resources:                          │
│  💰 Coins: 1500                     │
│  🪨 Stones: 800                     │
│  🪵 Wood: 500                       │
├─────────────────────────────────────┤
│  Materials:                          │
│  ┌──────┐ ┌──────┐ ┌──────┐        │
│  │ ⛏️   │ │ 🔩   │ │ 💎   │        │
│  │ Iron │ │ Steel│ │ Gem  │        │
│  │ Ore  │ │ Bar  │ │      │        │
│  │ x25  │ │ x10  │ │ x5   │        │
│  └──────┘ └──────┘ └──────┘        │
├─────────────────────────────────────┤
│  [Craft Items]                       │
└─────────────────────────────────────┘
```

### Crafting View

```
┌─────────────────────────────────────┐
│  ← Back    CRAFTING                 │
├─────────────────────────────────────┤
│  Item to Craft:                      │
│  ┌─────────────────────┐            │
│  │      [Item Icon]    │            │
│  │    Item Name        │            │
│  │  Quantity: [1]      │            │
│  └─────────────────────┘            │
├─────────────────────────────────────┤
│  Required Materials:                 │
│  ⛏️ Iron Ore: 5/25 ✓               │
│  🔩 Steel Bar: 2/10 ✓               │
│  🪵 Wood: 3/500 ✓                  │
├─────────────────────────────────────┤
│  [Craft Item]                        │
└─────────────────────────────────────┘
```

---

## 🔗 Integration Points

### 1. Treasure Chest System
- Award items when chest is unlocked
- Badges are items in inventory
- Special items for rare chests

### 2. Focus Session System
- Award items/components on session completion
- Bonus items for streaks
- Special rewards for milestones

### 3. Castle System
- Use components for castle upgrades
- Transfer resources between inventory and castle
- Craft castle decorations/improvements

### 4. Profile System
- Show equipped items in profile
- Display inventory stats
- Show collection completion

---

## 📝 Item Categories & Examples

### Collectibles
- Achievement badges
- Milestone tokens
- Event items
- Rare collectibles

### Equipment
- Helmets (focus bonus)
- Armor (defense/resistance)
- Accessories (special bonuses)
- Tools (productivity boost)

### Consumables
- Focus boosters (temporary XP boost)
- Energy potions
- Time extenders
- Lucky charms

### Components
- Crafting materials (iron, wood, stone variants)
- Special materials (rare drops)
- Blueprints (crafting recipes)

---

## 🎯 Success Metrics

1. Users can view all collected items
2. Users can manage their inventory
3. Users can craft items from components
4. Users can equip items for bonuses
5. System integrates seamlessly with existing features
6. Performance: < 2s load time for inventory
7. User engagement: Inventory viewed regularly

---

## 🚀 Next Steps

1. Review and approve this plan
2. Set up backend models and routes
3. Create Flutter models and viewmodels
4. Build UI components
5. Integrate with existing systems
6. Test thoroughly
7. Deploy and monitor

---

**Last Updated**: January 2025
**Status**: Planning Phase
**Priority**: High

