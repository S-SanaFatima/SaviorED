import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../../services/api_service.dart';
import '../../authentication/models/user_model.dart';

/// Profile ViewModel for managing user profile data
class ProfileViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;
  
  // User profile data
  String? _userId;
  String? _email;
  String? _name;
  String? _avatar;
  int _level = 1;
  int _experiencePoints = 0;
  double _totalFocusHours = 0.0;
  int _totalCoins = 0;
  int _totalSessions = 0;
  int _completedSessions = 0;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get userId => _userId;
  String? get email => _email;
  String? get name => _name;
  String? get avatar => _avatar;
  int get level => _level;
  int get experiencePoints => _experiencePoints;
  double get totalFocusHours => _totalFocusHours;
  int get totalCoins => _totalCoins;
  int get totalSessions => _totalSessions;
  int get completedSessions => _completedSessions;

  /// Calculate XP needed for current level
  int get xpForCurrentLevel {
    // Formula: XP for level N = (N - 1)^2 * 100
    if (_level <= 1) return 0;
    return (_level - 1) * (_level - 1) * 100;
  }

  /// Calculate XP needed for next level
  int get xpForNextLevel {
    // Formula: XP for level N = (N)^2 * 100
    return _level * _level * 100;
  }

  /// Calculate XP progress in current level
  int get currentLevelXP {
    return _experiencePoints - xpForCurrentLevel;
  }

  /// Calculate XP needed to next level
  int get xpNeededForNextLevel {
    return xpForNextLevel - _experiencePoints;
  }

  /// Calculate progress percentage to next level (0.0 to 1.0)
  double get levelProgress {
    final xpRange = xpForNextLevel - xpForCurrentLevel;
    if (xpRange <= 0) return 1.0;
    final progress = currentLevelXP / xpRange;
    return progress.clamp(0.0, 1.0);
  }

  /// Get percentage as string (0% to 100%)
  String get levelProgressPercent {
    return '${(levelProgress * 100).toStringAsFixed(1)}%';
  }

  /// Load user profile from backend
  Future<bool> loadProfile() async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _apiService.get('/api/users/profile');

      if (response.data['success'] == true) {
        final userData = response.data['user'];
        
        _userId = userData['id']?.toString() ?? userData['_id']?.toString();
        _email = userData['email'] ?? '';
        _name = userData['name'];
        _avatar = userData['avatar'];
        _level = (userData['level'] ?? 1) as int;
        _experiencePoints = (userData['experiencePoints'] ?? 0) as int;
        _totalFocusHours = (userData['totalFocusHours'] ?? 0.0) is int 
            ? (userData['totalFocusHours'] as int).toDouble()
            : (userData['totalFocusHours'] ?? 0.0) as double;
        _totalCoins = (userData['totalCoins'] ?? 0) as int;
        _totalSessions = (userData['totalSessions'] ?? 0) as int;
        _completedSessions = (userData['completedSessions'] ?? 0) as int;

        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response.data['message'] ?? 'Failed to load profile');
        _setLoading(false);
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      String errorMessage;
      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? 
            'Failed to load profile. Please try again.';
      } else {
        errorMessage = 'Network error. Please check your connection.';
      }
      _setError(errorMessage);
      _setLoading(false);
      notifyListeners();
      return false;
    } catch (e) {
      _setError('An error occurred: ${e.toString()}');
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Update user profile (name, avatar)
  Future<bool> updateProfile({String? name, String? avatar}) async {
    try {
      _setLoading(true);
      _setError(null);

      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (avatar != null) data['avatar'] = avatar;

      final response = await _apiService.put('/api/users/profile', data: data);

      if (response.data['success'] == true) {
        final userData = response.data['user'];
        _name = userData['name'];
        _avatar = userData['avatar'];
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response.data['message'] ?? 'Failed to update profile');
        _setLoading(false);
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      String errorMessage;
      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? 
            'Failed to update profile. Please try again.';
      } else {
        errorMessage = 'Network error. Please check your connection.';
      }
      _setError(errorMessage);
      _setLoading(false);
      notifyListeners();
      return false;
    } catch (e) {
      _setError('An error occurred: ${e.toString()}');
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Refresh profile data
  Future<void> refresh() async {
    await loadProfile();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }
}

