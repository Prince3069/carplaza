import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class WebAnalytics {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> trackEvent(
      String event, Map<String, Object?> params) async {
    if (kIsWeb) {
      await _analytics.logEvent(
        name: event,
        parameters: params,
      );
      await _sendToCustomAnalytics(event, params);
    }
  }

  static Future<void> _sendToCustomAnalytics(
      String event, Map<String, Object?> params) async {
    try {
      final data = {
        'event': event,
        ...params,
        'timestamp': DateTime.now().toIso8601String(),
      };
      // Implement your custom analytics logic here
      debugPrint('Analytics data: $data');
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  static Future<void> trackPageView(String pageName) async {
    if (kIsWeb) {
      await _analytics.logScreenView(screenName: pageName);
    }
  }
}
