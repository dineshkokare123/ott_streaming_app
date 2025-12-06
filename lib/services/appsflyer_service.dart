import 'dart:io';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppsFlyerService extends ChangeNotifier {
  late AppsflyerSdk _appsflyerSdk;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  AppsFlyerService() {
    _init();
  }

  Future<void> _init() async {
    final devKey = dotenv.env['APPSFLYER_DEV_KEY'] ?? '';
    final appId = dotenv.env['APPSFLYER_APP_ID'] ?? '';

    if (devKey.isEmpty) {
      debugPrint('AppsFlyer: Dev Key is missing.');
      return;
    }

    final AppsFlyerOptions options = AppsFlyerOptions(
      afDevKey: devKey,
      appId: Platform.isIOS ? appId : '', // App ID is only needed for iOS
      showDebug: kDebugMode,
      timeToWaitForATTUserAuthorization: 50, // for iOS 14+
    );

    _appsflyerSdk = AppsflyerSdk(options);

    try {
      await _appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true,
      );

      _isInitialized = true;
      debugPrint('AppsFlyer: Initialized successfully.');
      notifyListeners();
    } catch (e) {
      debugPrint('AppsFlyer: Initialization failed: $e');
    }
  }

  Future<void> logEvent(
    String eventName,
    Map<String, dynamic>? eventValues,
  ) async {
    if (!_isInitialized) {
      debugPrint('AppsFlyer: SDK not initialized. Event skipped: $eventName');
      return;
    }

    try {
      final bool result =
          await _appsflyerSdk.logEvent(eventName, eventValues) ?? false;
      debugPrint('AppsFlyer: Logged "$eventName" -> Success: $result');
    } catch (e) {
      debugPrint('AppsFlyer: Error logging event: $e');
    }
  }

  // Pre-defined Standard Events
  Future<void> trackLogin(String method) async {
    await logEvent('af_login', {'method': method});
  }

  Future<void> trackContentView(
    String contentId,
    String contentType,
    String title,
  ) async {
    await logEvent('af_content_view', {
      'af_content_id': contentId,
      'af_content_type': contentType,
      'af_description': title,
    });
  }

  Future<void> trackSubscription(
    String planId,
    double price,
    String currency,
  ) async {
    await logEvent('af_subscribe', {
      'af_revenue': price,
      'af_currency': currency,
      'af_content_id': planId,
    });
  }

  Future<void> trackAddToCart(
    String contentId,
    String currency,
    double price,
  ) async {
    await logEvent('af_add_to_cart', {
      'af_content_id': contentId,
      'af_currency': currency,
      'af_revenue': price,
    });
  }
}
