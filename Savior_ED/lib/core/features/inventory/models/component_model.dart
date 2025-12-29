import 'package:equatable/equatable.dart';

/// Component Resource Model
class ComponentResourceModel extends Equatable {
  final int coins;
  final int stones;
  final int wood;

  const ComponentResourceModel({
    required this.coins,
    required this.stones,
    required this.wood,
  });

  factory ComponentResourceModel.fromJson(Map<String, dynamic> json) {
    return ComponentResourceModel(
      coins: (json['coins'] ?? 0) as int,
      stones: (json['stones'] ?? 0) as int,
      wood: (json['wood'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coins': coins,
      'stones': stones,
      'wood': wood,
    };
  }

  @override
  List<Object?> get props => [coins, stones, wood];
}

/// Component Material Model
class ComponentMaterialModel extends Equatable {
  final String itemId;
  final String name;
  final int quantity;
  final String iconName;
  final String colorHex;

  const ComponentMaterialModel({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.iconName,
    required this.colorHex,
  });

  factory ComponentMaterialModel.fromJson(Map<String, dynamic> json) {
    return ComponentMaterialModel(
      itemId: json['itemId'] ?? json['item_id'] ?? '',
      name: json['name'] ?? '',
      quantity: (json['quantity'] ?? 0) as int,
      iconName: json['iconName'] ?? json['icon_name'] ?? 'star',
      colorHex: json['colorHex'] ?? json['color_hex'] ?? '#808080',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'name': name,
      'quantity': quantity,
      'iconName': iconName,
      'colorHex': colorHex,
    };
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
  List<Object?> get props => [itemId, name, quantity, iconName, colorHex];
}

/// Component Model (resources + materials)
class ComponentModel extends Equatable {
  final ComponentResourceModel resources;
  final List<ComponentMaterialModel> materials;

  const ComponentModel({
    required this.resources,
    required this.materials,
  });

  factory ComponentModel.fromJson(Map<String, dynamic> json) {
    final componentData = json['components'] ?? json;
    
    final resources = ComponentResourceModel.fromJson(
      componentData['resources'] ?? {},
    );
    
    final materialsList = (componentData['materials'] as List<dynamic>?)
            ?.map((material) => ComponentMaterialModel.fromJson(material as Map<String, dynamic>))
            .toList() ??
        [];

    return ComponentModel(
      resources: resources,
      materials: materialsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resources': resources.toJson(),
      'materials': materials.map((m) => m.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [resources, materials];
}

