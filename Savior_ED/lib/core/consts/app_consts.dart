/// Application-wide constants
class AppConsts {
  // App Info
  static const String appName = 'Savior ED';
  
  // API
  static const String baseUrl = 'https://saviored-backend-production.up.railway.app';
  static const Duration apiTimeout = Duration(seconds: 60); // Increased for Railway cold starts
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Private constructor to prevent instantiation
  AppConsts._();
}

