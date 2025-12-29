import 'package:equatable/equatable.dart';

/// Inventory Item Model
class InventoryItemModel extends Equatable {
  final String id;
  final String itemId;
  final String name;
  final String description;
  final int quantity;
  final String category; // 'collectible', 'equipment', 'consumable', 'component'
  final String rarity; // 'common', 'rare', 'epic', 'legendary'
  final String iconName;
  final String colorHex;
  final bool stackable;
  final int maxStack;
  final bool usable;
  final String? equipmentSlot; // 'helmet', 'armor', 'accessory'
  final DateTime? obtainedAt;
  final DateTime? lastUsedAt;

  const InventoryItemModel({
    required this.id,
    required this.itemId,
    required this.name,
    required this.description,
    required this.quantity,
    required this.category,
    required this.rarity,
    required this.iconName,
    required this.colorHex,
    required this.stackable,
    required this.maxStack,
    required this.usable,
    this.equipmentSlot,
    this.obtainedAt,
    this.lastUsedAt,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      id: json['id']?.toString() ?? '',
      itemId: json['itemId'] ?? json['item_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      quantity: (json['quantity'] ?? 0) as int,
      category: json['category'] ?? 'collectible',
      rarity: json['rarity'] ?? 'common',
      iconName: json['iconName'] ?? json['icon_name'] ?? 'star',
      colorHex: json['colorHex'] ?? json['color_hex'] ?? '#808080',
      stackable: json['stackable'] ?? true,
      maxStack: (json['maxStack'] ?? json['max_stack'] ?? 999) as int,
      usable: json['usable'] ?? false,
      equipmentSlot: json['equipmentSlot'] ?? json['equipment_slot'],
      obtainedAt: json['obtainedAt'] != null
          ? DateTime.parse(json['obtainedAt'] as String)
          : json['obtained_at'] != null
              ? DateTime.parse(json['obtained_at'] as String)
              : null,
      lastUsedAt: json['lastUsedAt'] != null
          ? DateTime.parse(json['lastUsedAt'] as String)
          : json['last_used_at'] != null
              ? DateTime.parse(json['last_used_at'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'name': name,
      'description': description,
      'quantity': quantity,
      'category': category,
      'rarity': rarity,
      'iconName': iconName,
      'colorHex': colorHex,
      'stackable': stackable,
      'maxStack': maxStack,
      'usable': usable,
      'equipmentSlot': equipmentSlot,
      'obtainedAt': obtainedAt?.toIso8601String(),
      'lastUsedAt': lastUsedAt?.toIso8601String(),
    };
  }

  InventoryItemModel copyWith({
    String? id,
    String? itemId,
    String? name,
    String? description,
    int? quantity,
    String? category,
    String? rarity,
    String? iconName,
    String? colorHex,
    bool? stackable,
    int? maxStack,
    bool? usable,
    String? equipmentSlot,
    DateTime? obtainedAt,
    DateTime? lastUsedAt,
  }) {
    return InventoryItemModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      rarity: rarity ?? this.rarity,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      stackable: stackable ?? this.stackable,
      maxStack: maxStack ?? this.maxStack,
      usable: usable ?? this.usable,
      equipmentSlot: equipmentSlot ?? this.equipmentSlot,
      obtainedAt: obtainedAt ?? this.obtainedAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  /// Get color from hex string
  int get colorValue {
    try {
      return int.parse(colorHex.replaceFirst('#', '0xFF'));
    } catch (e) {
      return 0xFF808080; // Default gray
    }
  }

  @override
  List<Object?> get props => [
        id,
        itemId,
        name,
        description,
        quantity,
        category,
        rarity,
        iconName,
        colorHex,
        stackable,
        maxStack,
        usable,
        equipmentSlot,
        obtainedAt,
        lastUsedAt,
      ];
}

/// Inventory Model (contains list of items)
class InventoryModel extends Equatable {
  final List<InventoryItemModel> items;
  final int totalItems;
  final int uniqueItems;

  const InventoryModel({
    required this.items,
    required this.totalItems,
    required this.uniqueItems,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    final inventoryData = json['inventory'] ?? json;
    final itemsList = (inventoryData['items'] as List<dynamic>?)
            ?.map((item) => InventoryItemModel.fromJson(item as Map<String, dynamic>))
            .toList() ??
        [];

    return InventoryModel(
      items: itemsList,
      totalItems: inventoryData['totalItems'] ?? inventoryData['total_items'] ?? 0,
      uniqueItems: inventoryData['uniqueItems'] ?? inventoryData['unique_items'] ?? itemsList.length,
    );
  }

  @override
  List<Object?> get props => [items, totalItems, uniqueItems];
}

