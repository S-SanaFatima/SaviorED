import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../../services/api_service.dart';
import '../models/inventory_item_model.dart';

class InventoryViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;
  InventoryModel? _inventory;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  InventoryModel? get inventory => _inventory;
  List<InventoryItemModel> get items => _inventory?.items ?? [];

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Get user's inventory
  Future<void> getInventory({String? category, String? rarity, String? search}) async {
    try {
      setLoading(true);
      setError(null);
      notifyListeners();

      final queryParams = <String, dynamic>{};
      if (category != null && category.isNotEmpty) queryParams['category'] = category;
      if (rarity != null && rarity.isNotEmpty) queryParams['rarity'] = rarity;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      print('📦 Loading inventory...');
      final response = await _apiService.get(
        '/api/inventory',
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      print('✅ Inventory response received: ${response.statusCode}');
      print('📦 Response data: ${response.data}');

      if (response.data['success'] == true) {
        _inventory = InventoryModel.fromJson(response.data);
        setLoading(false);
        setError(null);
        notifyListeners();
        print('✅ Inventory loaded: ${_inventory?.items.length ?? 0} items');
      } else {
        final errorMsg = response.data['message'] ?? 'Failed to load inventory';
        setError(errorMsg);
        setLoading(false);
        notifyListeners();
        print('❌ Inventory load failed: $errorMsg');
      }
    } on DioException catch (e) {
      print('❌ Inventory DioException: ${e.type}');
      print('❌ Error message: ${e.message}');
      print('❌ Response: ${e.response?.data}');
      print('❌ Status code: ${e.response?.statusCode}');
      
      String errorMsg = 'Failed to load inventory';
      if (e.response != null) {
        errorMsg = e.response!.data['message'] ?? 'Server error: ${e.response!.statusCode}';
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout) {
        errorMsg = 'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMsg = 'Cannot connect to server. Please check if the backend is running.';
      } else {
        errorMsg = e.message ?? 'Unknown error occurred';
      }
      
      setError(errorMsg);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      print('❌ Inventory error: $e');
      setError(e.toString());
      setLoading(false);
      notifyListeners();
    }
  }

  /// Get item details
  Future<InventoryItemModel?> getItemDetails(String itemId) async {
    try {
      setLoading(true);
      setError(null);

      final response = await _apiService.get('/api/inventory/items/$itemId');

      if (response.data['success'] == true) {
        final item = InventoryItemModel.fromJson(response.data['item']);
        setLoading(false);
        return item;
      } else {
        setError(response.data['message'] ?? 'Failed to load item details');
        setLoading(false);
        return null;
      }
    } catch (e) {
      setError(e.toString());
      setLoading(false);
      return null;
    }
  }

  /// Use an item
  Future<bool> useItem(String itemId, {int quantity = 1}) async {
    try {
      setLoading(true);
      setError(null);

      final response = await _apiService.post(
        '/api/inventory/items/$itemId/use',
        data: {'quantity': quantity},
      );

      if (response.data['success'] == true) {
        // Refresh inventory after using item
        await getInventory();
        setLoading(false);
        return true;
      } else {
        setError(response.data['message'] ?? 'Failed to use item');
        setLoading(false);
        return false;
      }
    } catch (e) {
      setError(e.toString());
      setLoading(false);
      return false;
    }
  }

  /// Discard items from inventory
  Future<bool> discardItem(String itemId, {int? quantity}) async {
    try {
      setLoading(true);
      setError(null);

      final response = await _apiService.delete(
        '/api/inventory/items/$itemId',
        data: quantity != null ? {'quantity': quantity} : null,
      );

      if (response.data['success'] == true) {
        // Refresh inventory after discarding item
        await getInventory();
        setLoading(false);
        return true;
      } else {
        setError(response.data['message'] ?? 'Failed to discard item');
        setLoading(false);
        return false;
      }
    } catch (e) {
      setError(e.toString());
      setLoading(false);
      return false;
    }
  }

  /// Refresh inventory
  Future<void> refresh({String? category, String? rarity, String? search}) async {
    await getInventory(category: category, rarity: rarity, search: search);
  }

  /// Filter items by category
  List<InventoryItemModel> getItemsByCategory(String category) {
    if (category == 'all') return items;
    return items.where((item) => item.category == category).toList();
  }

  /// Filter items by rarity
  List<InventoryItemModel> getItemsByRarity(String rarity) {
    if (rarity == 'all') return items;
    return items.where((item) => item.rarity == rarity).toList();
  }

  /// Search items by name
  List<InventoryItemModel> searchItems(String query) {
    if (query.isEmpty) return items;
    final lowerQuery = query.toLowerCase();
    return items
        .where((item) =>
            item.name.toLowerCase().contains(lowerQuery) ||
            item.description.toLowerCase().contains(lowerQuery))
        .toList();
  }
}

