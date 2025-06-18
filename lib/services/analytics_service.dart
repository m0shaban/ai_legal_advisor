import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AnalyticsService {
  // Singleton pattern
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  late FirebaseAnalytics _analytics;
  late FirebaseCrashlytics _crashlytics;
  
  bool _isInitialized = false;

  /// Initialize Firebase Analytics and Crashlytics
  Future<void> initialize() async {
    try {
      // Initialize Firebase if not already initialized
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }

      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;

      // Set up Crashlytics
      FlutterError.onError = _crashlytics.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics.recordError(error, stack, fatal: true);
        return true;
      };

      _isInitialized = true;
      debugPrint('✅ Analytics and Crashlytics initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize Analytics: $e');
    }
  }

  /// Check if analytics is available
  bool get isAvailable => _isInitialized;

  // === USER ANALYTICS ===

  /// Set user properties
  Future<void> setUserProperties({
    required String userId,
    String? userType,
    bool? isPremium,
    String? subscriptionPlan,
  }) async {
    if (!_isInitialized) return;

    try {
      await _analytics.setUserId(id: userId);
      
      if (userType != null) {
        await _analytics.setUserProperty(name: 'user_type', value: userType);
      }
      
      if (isPremium != null) {
        await _analytics.setUserProperty(
          name: 'is_premium', 
          value: isPremium.toString(),
        );
      }
      
      if (subscriptionPlan != null) {
        await _analytics.setUserProperty(
          name: 'subscription_plan', 
          value: subscriptionPlan,
        );
      }

      debugPrint('📊 User properties set: $userId');
    } catch (e) {
      debugPrint('Error setting user properties: $e');
    }
  }

  // === SCREEN TRACKING ===

  /// Log screen view
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (!_isInitialized) return;

    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
      debugPrint('📱 Screen viewed: $screenName');
    } catch (e) {
      debugPrint('Error logging screen view: $e');
    }
  }

  // === USER ACTIONS ===

  /// Log user login
  Future<void> logLogin({
    required String method, // 'email', 'google', 'apple'
  }) async {
    if (!_isInitialized) return;

    try {
      await _analytics.logLogin(loginMethod: method);
      debugPrint('🔐 Login logged: $method');
    } catch (e) {
      debugPrint('Error logging login: $e');
    }
  }

  /// Log user signup
  Future<void> logSignUp({
    required String method,
  }) async {
    if (!_isInitialized) return;

    try {
      await _analytics.logSignUp(signUpMethod: method);
      debugPrint('👤 Signup logged: $method');
    } catch (e) {
      debugPrint('Error logging signup: $e');
    }
  }

  /// Log subscription purchase
  Future<void> logPurchase({
    required String planId,
    required double value,
    required String currency,
    String? transactionId,
  }) async {
    if (!_isInitialized) return;

    try {
      await _analytics.logPurchase(
        currency: currency,
        value: value,
        parameters: {
          'plan_id': planId,
          'transaction_id': transactionId ?? '',
        },
      );
      debugPrint('💰 Purchase logged: $planId - $value $currency');
    } catch (e) {
      debugPrint('Error logging purchase: $e');
    }
  }

  // === LEGAL CONSULTATION ANALYTICS ===

  /// Log legal consultation request
  Future<void> logLegalConsultation({
    required String consultationType,
    required String aiProvider, // 'nvidia', 'openai', 'mock'
    int? responseTime,
    bool? wasSuccessful,
  }) async {
    if (!_isInitialized) return;

    try {
      await _analytics.logEvent(
        name: 'legal_consultation',
        parameters: {
          'consultation_type': consultationType,
          'ai_provider': aiProvider,
          'response_time_ms': responseTime ?? 0,
          'was_successful': wasSuccessful ?? false,
        },
      );
      debugPrint('⚖️ Legal consultation logged: $consultationType');
    } catch (e) {
      debugPrint('Error logging consultation: $e');
    }
  }

  /// Log document analysis
  Future<void> logDocumentAnalysis({
    required String documentType,
    required int fileSizeKB,
    bool? wasSuccessful,
  }) async {
    if (!_isInitialized) return;

    try {
      await _analytics.logEvent(
        name: 'document_analysis',
        parameters: {
          'document_type': documentType,
          'file_size_kb': fileSizeKB,
          'was_successful': wasSuccessful ?? false,
        },
      );
      debugPrint('📄 Document analysis logged: $documentType');
    } catch (e) {
      debugPrint('Error logging document analysis: $e');
    }
  }

  /// Log search query
  Future<void> logSearch({
    required String searchTerm,
    required String searchType,
    int? resultsCount,
  }) async {
    if (!_isInitialized) return;

    try {
      await _analytics.logSearch(
        searchTerm: searchTerm,
        parameters: {
          'search_type': searchType,
          'results_count': resultsCount ?? 0,
        },
      );
      debugPrint('🔍 Search logged: $searchTerm');
    } catch (e) {
      debugPrint('Error logging search: $e');
    }
  }

  // === USER ENGAGEMENT ===

  /// Log time spent on feature
  Future<void> logTimeSpent({
    required String feature,
    required int secondsSpent,
  }) async {
    if (!_isInitialized) return;

    try {
      await _analytics.logEvent(
        name: 'time_spent',
        parameters: {
          'feature': feature,
          'seconds_spent': secondsSpent,
        },
      );
      debugPrint('⏱️ Time spent logged: $feature - ${secondsSpent}s');
    } catch (e) {
      debugPrint('Error logging time spent: $e');
    }
  }

  /// Log user feedback
  Future<void> logFeedback({
    required String feedbackType,
    required int rating, // 1-5
    String? comment,
  }) async {
    if (!_isInitialized) return;

    try {
      await _analytics.logEvent(
        name: 'user_feedback',
        parameters: {
          'feedback_type': feedbackType,
          'rating': rating,
          'has_comment': comment != null && comment.isNotEmpty,
        },
      );
      debugPrint('💬 Feedback logged: $feedbackType - $rating stars');
    } catch (e) {
      debugPrint('Error logging feedback: $e');
    }
  }

  // === ERROR TRACKING ===

  /// Record custom error
  Future<void> recordError({
    required dynamic exception,
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? context,
    bool fatal = false,
  }) async {
    if (!_isInitialized) return;

    try {
      // Set custom keys for context
      if (context != null) {
        for (final entry in context.entries) {
          await _crashlytics.setCustomKey(entry.key, entry.value);
        }
      }

      // Record the error
      await _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );

      debugPrint('🚨 Error recorded: ${exception.toString()}');
    } catch (e) {
      debugPrint('Error recording crash: $e');
    }
  }

  /// Log breadcrumb for debugging
  Future<void> logBreadcrumb(String message, [Map<String, dynamic>? data]) async {
    if (!_isInitialized) return;

    try {
      await _crashlytics.log(message);
      if (data != null) {
        for (final entry in data.entries) {
          await _crashlytics.setCustomKey(entry.key, entry.value);
        }
      }
      debugPrint('🍞 Breadcrumb: $message');
    } catch (e) {
      debugPrint('Error logging breadcrumb: $e');
    }
  }

  // === CUSTOM EVENTS ===
  /// Log custom event
  Future<void> logCustomEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) async {
    if (!_isInitialized) return;

    try {
      // Convert Map<String, dynamic> to Map<String, Object>
      final Map<String, Object>? convertedParams = parameters?.map(
        (key, value) => MapEntry(key, value as Object),
      );
      
      await _analytics.logEvent(
        name: eventName,
        parameters: convertedParams,
      );
      debugPrint('🎯 Custom event logged: $eventName');
    } catch (e) {
      debugPrint('Error logging custom event: $e');
    }
  }

  // === PERFORMANCE MONITORING ===

  /// Start performance trace
  Future<void> startTrace(String traceName) async {
    if (!_isInitialized) return;

    try {
      // Note: Performance monitoring requires firebase_performance package
      debugPrint('🚀 Performance trace started: $traceName');
    } catch (e) {
      debugPrint('Error starting trace: $e');
    }
  }

  /// Stop performance trace
  Future<void> stopTrace(String traceName) async {
    if (!_isInitialized) return;

    try {
      debugPrint('🏁 Performance trace stopped: $traceName');
    } catch (e) {
      debugPrint('Error stopping trace: $e');
    }
  }

  // === APP LIFECYCLE ===

  /// Log app open
  Future<void> logAppOpen() async {
    if (!_isInitialized) return;

    try {
      await _analytics.logAppOpen();
      debugPrint('📱 App open logged');
    } catch (e) {
      debugPrint('Error logging app open: $e');
    }
  }

  /// Enable/disable analytics collection
  Future<void> setAnalyticsEnabled(bool enabled) async {
    if (!_isInitialized) return;

    try {
      await _analytics.setAnalyticsCollectionEnabled(enabled);
      debugPrint('📊 Analytics collection: ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      debugPrint('Error setting analytics state: $e');
    }
  }

  /// Enable/disable crashlytics collection
  Future<void> setCrashlyticsEnabled(bool enabled) async {
    if (!_isInitialized) return;

    try {
      await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
      debugPrint('🚨 Crashlytics collection: ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      debugPrint('Error setting crashlytics state: $e');
    }
  }
}
