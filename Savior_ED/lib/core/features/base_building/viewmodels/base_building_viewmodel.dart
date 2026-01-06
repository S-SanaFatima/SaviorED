import 'package:flutter/foundation.dart';
import '../../../services/api_service.dart';
import '../models/placed_item_model.dart';

class BaseBuildingViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;
  List<PlacedItemModel> _placedItems = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<PlacedItemModel> get placedItems => _placedItems;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Load base layout from backend
  Future<void> loadBase() async {
    try {
      setLoading(true);
      setError(null);

      // TODO: Replace with actual API endpoint when backend is ready
      // For now, use local storage or mock data
      final response = await _apiService.get('/api/base/my-base');

      if (response.data['success'] == true) {
        final items = (response.data['placedItems'] as List? ?? [])
            .map((json) => PlacedItemModel.fromJson(json))
            .toList();
        _placedItems = items;
        setLoading(false);
        notifyListeners();
      } else {
        // If no base exists, start with empty list
        _placedItems = [];
        setLoading(false);
        notifyListeners();
      }
    } catch (e) {
      // If API fails, start with empty list (for development)
      print('⚠️ Failed to load base: $e');
      _placedItems = [];
      setLoading(false);
      notifyListeners();
    }
  }

  /// Place an item on the base
  Future<void> placeItem({
    required String itemType,
    required String itemId,
    required int gridX,
    required int gridY,
    double rotation = 0,
  }) async {
    try {
      final newItem = PlacedItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        itemType: itemType,
        itemId: itemId,
        gridX: gridX,
        gridY: gridY,
        rotation: rotation,
        placedAt: DateTime.now(),
      );

      // Add to local list immediately
      _placedItems = [..._placedItems, newItem];
      notifyListeners();

      // Save to backend
      try {
        await _apiService.post('/api/base/place-item', data: newItem.toJson());
      } catch (e) {
        print('⚠️ Failed to save item to backend: $e');
        // Keep item in local list even if backend fails
      }
    } catch (e) {
      setError('Failed to place item: $e');
    }
  }

  /// Remove an item from the base
  Future<void> removeItem(String itemId) async {
    try {
      _placedItems = _placedItems.where((item) => item.id != itemId).toList();
      notifyListeners();

      // Remove from backend
      try {
        await _apiService.delete('/api/base/remove-item/$itemId');
      } catch (e) {
        print('⚠️ Failed to remove item from backend: $e');
      }
    } catch (e) {
      setError('Failed to remove item: $e');
    }
  }

  /// Update item position or rotation
  Future<void> updateItem({
    required String itemId,
    int? gridX,
    int? gridY,
    double? rotation,
  }) async {
    try {
      _placedItems = _placedItems.map((item) {
        if (item.id == itemId) {
          return item.copyWith(
            gridX: gridX ?? item.gridX,
            gridY: gridY ?? item.gridY,
            rotation: rotation ?? item.rotation,
          );
        }
        return item;
      }).toList();
      notifyListeners();

      // Update backend
      try {
        final updatedItem = _placedItems.firstWhere((item) => item.id == itemId);
        await _apiService.put(
          '/api/base/update-item/$itemId',
          data: updatedItem.toJson(),
        );
      } catch (e) {
        print('⚠️ Failed to update item in backend: $e');
      }
    } catch (e) {
      setError('Failed to update item: $e');
    }
  }
}

