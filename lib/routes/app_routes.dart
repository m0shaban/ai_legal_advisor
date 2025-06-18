// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_carousel/onboarding_carousel.dart';
import '../presentation/user_profile_settings/user_profile_settings.dart';
import '../presentation/chat_home_screen/chat_home_screen.dart';
import '../presentation/document_upload_analysis/document_upload_analysis.dart';
import '../presentation/ai_chat_conversation/ai_chat_conversation.dart';
import '../presentation/legal_templates_library/legal_templates_library.dart';
import '../presentation/authentication/login_screen.dart';
import '../presentation/authentication/register_screen.dart';
import '../presentation/authentication/forgot_password_screen.dart';
import '../presentation/subscription/subscription_plans_screen.dart';
import '../presentation/subscription/payment_screen.dart';
import '../presentation/service_test/service_test_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String onboardingCarousel = '/onboarding-carousel';
  static const String loginScreen = '/login-screen';
  static const String registerScreen = '/register-screen';
  static const String forgotPasswordScreen = '/forgot-password-screen';
  static const String chatHomeScreen = '/chat-home-screen';
  static const String aiChatConversation = '/ai-chat-conversation';
  static const String documentUploadAnalysis = '/document-upload-analysis';
  static const String legalTemplatesLibrary = '/legal-templates-library';
  static const String userProfileSettings = '/user-profile-settings';
  static const String subscriptionPlansScreen = '/subscription-plans-screen';
  static const String paymentScreen = '/payment-screen';
  static const String serviceTestScreen = '/service-test-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => SplashScreen(),
    splashScreen: (context) => SplashScreen(),
    onboardingCarousel: (context) => OnboardingCarousel(),
    loginScreen: (context) => LoginScreen(),
    registerScreen: (context) => RegisterScreen(),
    forgotPasswordScreen: (context) => ForgotPasswordScreen(),
    chatHomeScreen: (context) => ChatHomeScreen(),
    aiChatConversation: (context) => AiChatConversation(),
    documentUploadAnalysis: (context) => DocumentUploadAnalysis(),
    legalTemplatesLibrary: (context) => LegalTemplatesLibrary(),
    userProfileSettings: (context) => UserProfileSettings(),
    subscriptionPlansScreen: (context) => SubscriptionPlansScreen(),
    paymentScreen: (context) => PaymentScreen(),
    serviceTestScreen: (context) => ServiceTestScreen(),
  };
}
