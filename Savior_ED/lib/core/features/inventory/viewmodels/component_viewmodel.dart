import 'package:flutter/foundation.dart';
import '../../../services/api_service.dart';
import '../models/component_model.dart';

class ComponentViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;
  ComponentModel? _components;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ComponentModel? get components => _components;
  ComponentResourceModel? get resources => _components?.resources;
  List<ComponentMaterialModel> get materials => _components?.materials ?? [];

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Get user's components
  Future<void> getComponents() async {
    try {
      setLoading(true);
      setError(null);

      final response = await _apiService.get('/api/components');

      if (response.data['success'] == true) {
        _components = ComponentModel.fromJson(response.data);
        setLoading(false);
        notifyListeners();
      } else {
        setError(response.data['message'] ?? 'Failed to load components');
        setLoading(false);
      }
    } catch (e) {
      setError(e.toString());
      setLoading(false);
    }
  }

  /// Craft an item from components
  Future<Map<String, dynamic>?> craftItem(String itemId, {int quantity = 1}) async {
    try {
      setLoading(true);
      setError(null);

      final response = await _apiService.post(
        '/api/components/craft',
        data: {
          'itemId': itemId,
          'quantity': quantity,
        },
      );

      if (response.data['success'] == true) {
        // Refresh components after crafting
        await getComponents();
        setLoading(false);
        return {
          'success': true,
          'craftedItem': response.data['craftedItem'],
          'consumedComponents': response.data['consumedComponents'],
        };
      } else {
        setError(response.data['message'] ?? 'Failed to craft item');
        setLoading(false);
        return null;
      }
    } catch (e) {
      setError(e.toString());
      setLoading(false);
      return null;
    }
  }

  /// Refresh components
  Future<void> refresh() async {
    await getComponents();
  }
}

