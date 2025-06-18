import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class SubscriptionService {
  static const String _subscriptionKey = 'subscription_data';
  
  // Singleton pattern
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  final AuthService _authService = AuthService();

  // Available subscription plans
  static const List<SubscriptionPlan> availablePlans = [
    SubscriptionPlan(
      id: 'monthly',
      name: 'الاشتراك الشهري',
      nameEn: 'Monthly Plan',
      description: 'خطة شهرية بميزات كاملة',
      price: 99.99,
      currency: 'EGP',
      duration: 'شهر',
      durationEn: 'Month',
      features: [
        'استشارات قانونية غير محدودة',
        'تحليل الوثائق المتقدم',
        'جميع القوالب القانونية',
        'دعم أولوية 24/7',
        'تصدير المحادثات',
        'بحث متقدم في القوانين',
      ],
      featuresEn: [
        'Unlimited legal consultations',
        'Advanced document analysis',
        'All legal templates',
        '24/7 priority support',
        'Chat export',
        'Advanced legal search',
      ],
      isPopular: true,
      discountPercentage: 0,
    ),
    SubscriptionPlan(
      id: 'quarterly',
      name: 'الاشتراك ربع السنوي',
      nameEn: 'Quarterly Plan',
      description: 'خطة ثلاثة أشهر مع خصم 15%',
      price: 254.99,
      originalPrice: 299.97,
      currency: 'EGP',
      duration: '3 أشهر',
      durationEn: '3 Months',
      features: [
        'جميع ميزات الخطة الشهرية',
        'خصم 15% على السعر',
        'تحديثات مجانية للقوانين',
        'استشارات هاتفية شهرية',
      ],
      featuresEn: [
        'All monthly plan features',
        '15% discount',
        'Free legal updates',
        'Monthly phone consultations',
      ],
      isPopular: false,
      discountPercentage: 15,
    ),
    SubscriptionPlan(
      id: 'yearly',
      name: 'الاشتراك السنوي',
      nameEn: 'Yearly Plan',
      description: 'خطة سنوية مع خصم 25%',
      price: 899.99,
      originalPrice: 1199.88,
      currency: 'EGP',
      duration: 'سنة',
      durationEn: 'Year',
      features: [
        'جميع ميزات الخطة الشهرية',
        'خصم 25% على السعر',
        'استشارة قانونية مجانية',
        'مراجعة عقود مجانية (2 سنوياً)',
        'دعم مخصص',
        'تقارير قانونية شهرية',
      ],
      featuresEn: [
        'All monthly plan features',
        '25% discount',
        'Free legal consultation',
        'Free contract reviews (2/year)',
        'Dedicated support',
        'Monthly legal reports',
      ],
      isPopular: false,
      discountPercentage: 25,
    ),
  ];

  /// Get user's current subscription
  Future<UserSubscription?> getCurrentSubscription() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final subscriptionData = prefs.getString(_subscriptionKey);
      
      if (subscriptionData != null) {
        final data = jsonDecode(subscriptionData);
        return UserSubscription.fromJson(data);
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting subscription: ${e.toString()}');
      return null;
    }
  }

  /// Subscribe to a plan
  Future<SubscriptionResult> subscribe(String planId, PaymentMethod paymentMethod) async {
    try {
      // Simulate payment processing delay
      await Future.delayed(const Duration(seconds: 3));

      final plan = availablePlans.firstWhere((p) => p.id == planId);
      
      // Mock payment processing
      final paymentResult = await _processPayment(plan, paymentMethod);
      
      if (!paymentResult.success) {
        return SubscriptionResult(
          success: false,
          message: paymentResult.message,
        );
      }

      // Create subscription
      final subscription = UserSubscription(
        planId: planId,
        planName: plan.name,
        startDate: DateTime.now(),
        endDate: _calculateEndDate(planId),
        isActive: true,
        paymentMethod: paymentMethod,
        amount: plan.price,
        currency: plan.currency,
        transactionId: paymentResult.transactionId!,
      );

      // Save subscription
      await _saveSubscription(subscription);      // Update user to premium
      await _authService.updateSubscriptionStatus('premium', expiry: subscription.endDate);

      return SubscriptionResult(
        success: true,
        message: 'تم تفعيل الاشتراك بنجاح',
        subscription: subscription,
      );
    } catch (e) {
      return SubscriptionResult(
        success: false,
        message: 'حدث خطأ أثناء معالجة الاشتراك: ${e.toString()}',
      );
    }
  }

  /// Cancel subscription
  Future<SubscriptionResult> cancelSubscription() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      final subscription = await getCurrentSubscription();
      if (subscription == null) {
        return SubscriptionResult(
          success: false,
          message: 'لا يوجد اشتراك نشط للإلغاء',
        );
      }

      // Update subscription status
      final updatedSubscription = subscription.copyWith(
        isActive: false,
        cancelDate: DateTime.now(),
      );

      await _saveSubscription(updatedSubscription);      // Update user to free
      await _authService.updateSubscriptionStatus('free');

      return SubscriptionResult(
        success: true,
        message: 'تم إلغاء الاشتراك بنجاح',
        subscription: updatedSubscription,
      );
    } catch (e) {
      return SubscriptionResult(
        success: false,
        message: 'حدث خطأ أثناء إلغاء الاشتراك: ${e.toString()}',
      );
    }
  }

  /// Check if subscription is expired
  Future<bool> isSubscriptionExpired() async {
    final subscription = await getCurrentSubscription();
    if (subscription == null || !subscription.isActive) return true;
    
    return DateTime.now().isAfter(subscription.endDate);
  }

  /// Check if user has active subscription
  Future<bool> hasActiveSubscription() async {
    final subscription = await getCurrentSubscription();
    if (subscription == null || !subscription.isActive) return false;
    
    return DateTime.now().isBefore(subscription.endDate);
  }

  /// Get days remaining in subscription
  Future<int> getDaysRemaining() async {
    final subscription = await getCurrentSubscription();
    if (subscription == null || !subscription.isActive) return 0;
    
    final remaining = subscription.endDate.difference(DateTime.now()).inDays;
    return remaining > 0 ? remaining : 0;
  }

  /// Restore purchases (for mobile app stores)
  Future<SubscriptionResult> restorePurchases() async {
    try {
      // Simulate API call to restore purchases
      await Future.delayed(const Duration(seconds: 2));

      // Mock restore result
      return SubscriptionResult(
        success: true,
        message: 'تم استرداد المشتريات بنجاح',
      );
    } catch (e) {
      return SubscriptionResult(
        success: false,
        message: 'حدث خطأ أثناء استرداد المشتريات: ${e.toString()}',
      );
    }
  }

  /// Private helper methods
  Future<PaymentResult> _processPayment(SubscriptionPlan plan, PaymentMethod paymentMethod) async {
    // Mock payment processing
    await Future.delayed(const Duration(seconds: 2));

    // Simulate payment success/failure
    final random = DateTime.now().millisecondsSinceEpoch % 10;
    if (random < 8) { // 80% success rate
      return PaymentResult(
        success: true,
        message: 'تم الدفع بنجاح',
        transactionId: 'TXN_${DateTime.now().millisecondsSinceEpoch}',
      );
    } else {
      return PaymentResult(
        success: false,
        message: 'فشل في معالجة الدفع. يرجى المحاولة مرة أخرى',
      );
    }
  }

  DateTime _calculateEndDate(String planId) {
    final now = DateTime.now();
    switch (planId) {
      case 'monthly':
        return now.add(const Duration(days: 30));
      case 'quarterly':
        return now.add(const Duration(days: 90));
      case 'yearly':
        return now.add(const Duration(days: 365));
      default:
        return now.add(const Duration(days: 30));
    }
  }

  Future<void> _saveSubscription(UserSubscription subscription) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_subscriptionKey, jsonEncode(subscription.toJson()));
  }
}

/// Subscription plan model
class SubscriptionPlan {
  final String id;
  final String name;
  final String nameEn;
  final String description;
  final double price;
  final double? originalPrice;
  final String currency;
  final String duration;
  final String durationEn;
  final List<String> features;
  final List<String> featuresEn;
  final bool isPopular;
  final int discountPercentage;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.currency,
    required this.duration,
    required this.durationEn,
    required this.features,
    required this.featuresEn,
    this.isPopular = false,
    this.discountPercentage = 0,
  });
}

/// User subscription model
class UserSubscription {
  final String planId;
  final String planName;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final PaymentMethod paymentMethod;
  final double amount;
  final String currency;
  final String transactionId;
  final DateTime? cancelDate;

  UserSubscription({
    required this.planId,
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.paymentMethod,
    required this.amount,
    required this.currency,
    required this.transactionId,
    this.cancelDate,
  });

  UserSubscription copyWith({
    String? planId,
    String? planName,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    PaymentMethod? paymentMethod,
    double? amount,
    String? currency,
    String? transactionId,
    DateTime? cancelDate,
  }) {
    return UserSubscription(
      planId: planId ?? this.planId,
      planName: planName ?? this.planName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      transactionId: transactionId ?? this.transactionId,
      cancelDate: cancelDate ?? this.cancelDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'planName': planName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'paymentMethod': paymentMethod.toJson(),
      'amount': amount,
      'currency': currency,
      'transactionId': transactionId,
      'cancelDate': cancelDate?.toIso8601String(),
    };
  }

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      planId: json['planId'],
      planName: json['planName'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isActive: json['isActive'],
      paymentMethod: PaymentMethod.fromJson(json['paymentMethod']),
      amount: json['amount'].toDouble(),
      currency: json['currency'],
      transactionId: json['transactionId'],
      cancelDate: json['cancelDate'] != null ? DateTime.parse(json['cancelDate']) : null,
    );
  }
}

/// Payment method model
class PaymentMethod {
  final String type; // 'credit_card', 'debit_card', 'vodafone_cash', 'fawry'
  final String name;
  final String? cardNumber; // Last 4 digits
  final String? expiryDate;
  final String? holderName;

  PaymentMethod({
    required this.type,
    required this.name,
    this.cardNumber,
    this.expiryDate,
    this.holderName,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'holderName': holderName,
    };
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      type: json['type'],
      name: json['name'],
      cardNumber: json['cardNumber'],
      expiryDate: json['expiryDate'],
      holderName: json['holderName'],
    );
  }
}

/// Result classes
class SubscriptionResult {
  final bool success;
  final String message;
  final UserSubscription? subscription;

  SubscriptionResult({
    required this.success,
    required this.message,
    this.subscription,
  });
}

class PaymentResult {
  final bool success;
  final String message;
  final String? transactionId;

  PaymentResult({
    required this.success,
    required this.message,
    this.transactionId,
  });
}
