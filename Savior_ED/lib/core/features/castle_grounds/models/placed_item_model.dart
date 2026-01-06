import 'package:equatable/equatable.dart';

class PlacedItemModel extends Equatable {
  final String id;
  final String itemType; // 'wall', 'tower', 'tree', etc.
  final int gridX;
  final int gridY;
  final int bitmask; // Used for wall auto-linking

  const PlacedItemModel({
    required this.id,
    required this.itemType,
    required this.gridX,
    required this.gridY,
    this.bitmask = 0,
  });

  factory PlacedItemModel.fromJson(Map<String, dynamic> json) {
    return PlacedItemModel(
      id: json['id'] ?? '',
      itemType: json['itemType'] ?? 'wall',
      gridX: json['gridX'] ?? 0,
      gridY: json['gridY'] ?? 0,
      bitmask: json['bitmask'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemType': itemType,
      'gridX': gridX,
      'gridY': gridY,
      'bitmask': bitmask,
    };
  }

  PlacedItemModel copyWith({
    String? id,
    String? itemType,
    int? gridX,
    int? gridY,
    int? bitmask,
  }) {
    return PlacedItemModel(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      gridX: gridX ?? this.gridX,
      gridY: gridY ?? this.gridY,
      bitmask: bitmask ?? this.bitmask,
    );
  }

  @override
  List<Object?> get props => [id, itemType, gridX, gridY, bitmask];
}
