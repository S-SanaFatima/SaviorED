import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../consts/app_consts.dart';

/// API Service for handling HTTP requests
class ApiService {
  late final Dio _dio;
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConsts.baseUrl,
        connectTimeout: AppConsts.apiTimeout,
        receiveTimeout: AppConsts.apiTimeout,
        sendTimeout: AppConsts.apiTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) {
          return status != null && status < 500; // Accept all status codes < 500
        },
      ),
    );
    
    // Enable logging in debug mode
    if (true) { // Always log for now to debug
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
      ));
    }

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Log request details
          print('🚀 API Request: ${options.method} ${options.baseUrl}${options.path}');
          print('📦 Request Data: ${options.data}');
          print('🔗 Full URL: ${options.uri}');
          
          // Add auth token if available
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(AppConsts.tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ API Response: ${response.statusCode} ${response.requestOptions.path}');
          print('📦 Response Data: ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          // Log error details
          print('❌ API Error: ${error.type}');
          print('🔗 URL: ${error.requestOptions.uri}');
          print('📦 Error Data: ${error.response?.data}');
          print('💬 Error Message: ${error.message}');
          
          // Handle errors globally with better error messages
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            error = DioException(
              requestOptions: error.requestOptions,
              type: error.type,
              error: 'Connection timeout. Please check your internet connection.',
            );
          } else if (error.type == DioExceptionType.connectionError) {
            error = DioException(
              requestOptions: error.requestOptions,
              type: error.type,
              error: 'Connection refused. Please check if the server is running and accessible.',
            );
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }
}

