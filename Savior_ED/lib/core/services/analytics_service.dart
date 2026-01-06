import 'package:firebase_analytics/firebase_analytics.dart';

/// Service for Firebase Analytics tracking
class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: _analytics);

  /// Get the analytics instance
  static FirebaseAnalytics get analytics => _analytics;

  /// Log a custom event
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
      print('📊 Analytics: $name ${parameters != null ? parameters.toString() : ''}');
    } catch (e) {
      print('❌ Analytics error: $e');
    }
  }

  /// Log user login
  static Future<void> logLogin({String? loginMethod}) async {
    await logEvent(
      name: 'login',
      parameters: {
        if (loginMethod != null) 'method': loginMethod,
      },
    );
  }

  /// Log user signup
  static Future<void> logSignUp({String? signUpMethod}) async {
    await logEvent(
      name: 'sign_up',
      parameters: {
        if (signUpMethod != null) 'method': signUpMethod,
      },
    );
  }

  /// Log focus session started
  static Future<void> logFocusSessionStart({int? durationMinutes}) async {
    await logEvent(
      name: 'focus_session_start',
      parameters: {
        if (durationMinutes != null) 'duration_minutes': durationMinutes,
      },
    );
  }

  /// Log focus session completed
  static Future<void> logFocusSessionComplete({
    int? durationSeconds,
    int? coinsEarned,
    int? xpEarned,
  }) async {
    await logEvent(
      name: 'focus_session_complete',
      parameters: {
        if (durationSeconds != null) 'duration_seconds': durationSeconds,
        if (coinsEarned != null) 'coins_earned': coinsEarned,
        if (xpEarned != null) 'xp_earned': xpEarned,
      },
    );
  }

  /// Log treasure chest opened
  static Future<void> logTreasureChestOpened() async {
    await logEvent(name: 'treasure_chest_opened');
  }

  /// Log inventory item viewed
  static Future<void> logInventoryItemViewed({String? itemName, String? category}) async {
    await logEvent(
      name: 'inventory_item_viewed',
      parameters: {
        if (itemName != null) 'item_name': itemName,
        if (category != null) 'category': category,
      },
    );
  }

  /// Log screen view
  static Future<void> logScreenView({required String screenName}) async {
    try {
      await _analytics.logScreenView(screenName: screenName);
      print('📊 Screen view: $screenName');
    } catch (e) {
      print('❌ Analytics error: $e');
    }
  }

  /// Set user property
  static Future<void> setUserProperty({required String name, String? value}) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      print('❌ Analytics error: $e');
    }
  }

  /// Set user ID
  static Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (e) {
      print('❌ Analytics error: $e');
    }
  }
}

