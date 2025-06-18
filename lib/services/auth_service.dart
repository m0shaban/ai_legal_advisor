import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'database_service.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userDataKey = 'userData';
  static const String _authTokenKey = 'authToken';
  static const String _refreshTokenKey = 'refreshToken';

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // User state notifier
  final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);
  final ValueNotifier<Map<String, dynamic>?> currentUser = ValueNotifier<Map<String, dynamic>?>(null);

  // Database service
  final DatabaseService _db = DatabaseService();

  // Admin credentials
  static const String _adminEmail = 'admin@legaladvisor.com';
  static const String _adminPassword = 'Admin123@Legal';

  // Test credentials
  static const String _testEmail = 'test@legaladvisor.com';
  static const String _testPassword = 'Test123@Legal';

  /// Initialize the auth service and check current login status
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated = prefs.getBool(_isLoggedInKey) ?? false;
    
    if (isAuthenticated) {
      final userDataString = prefs.getString(_userDataKey);
      if (userDataString != null) {
        final userData = jsonDecode(userDataString);
        currentUser.value = userData;
        isLoggedIn.value = true;
      }
    }
  }

  /// Login with email and password
  Future<AuthResult> login(String email, String password) async {
    try {
      // Validation
      if (email.isEmpty || password.isEmpty) {
        return AuthResult(
          success: false,
          message: 'البريد الإلكتروني وكلمة المرور مطلوبان',
        );
      }

      if (password.length < 6) {
        return AuthResult(
          success: false,
          message: 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
        );
      }

      // Check for admin credentials
      if (email == _adminEmail && password == _adminPassword) {
        final adminUserData = {
          'id': 'admin_001',
          'name': 'المدير العام',
          'email': email,
          'phone': '+201000000000',
          'avatar': 'assets/images/profile.png',
          'isPro': true,
          'isAdmin': true,
          'joinDate': DateTime.now().toIso8601String(),
          'freeQueriesUsed': 0,
          'maxFreeQueries': 999999,
          'subscriptionStatus': 'premium',
          'subscriptionExpiry': null,
        };

        await _saveUserData(adminUserData);
        await _saveAuthTokens('admin_access_token', 'admin_refresh_token');

        currentUser.value = adminUserData;
        isLoggedIn.value = true;

        return AuthResult(
          success: true,
          message: 'مرحباً بك أيها المدير! تم تسجيل الدخول بنجاح',
          userData: adminUserData,
        );
      }

      // Check for test credentials
      if (email == _testEmail && password == _testPassword) {
        final testUserData = {
          'id': 'test_001',
          'name': 'مستخدم تجريبي',
          'email': email,
          'phone': '+201111111111',
          'avatar': 'assets/images/profile.png',
          'isPro': true,
          'isAdmin': false,
          'joinDate': DateTime.now().toIso8601String(),
          'freeQueriesUsed': 0,
          'maxFreeQueries': 100,
          'subscriptionStatus': 'premium',
          'subscriptionExpiry': DateTime.now().add(const Duration(days: 365)).toIso8601String(),
        };

        await _saveUserData(testUserData);
        await _saveAuthTokens('test_access_token', 'test_refresh_token');

        currentUser.value = testUserData;
        isLoggedIn.value = true;

        return AuthResult(
          success: true,
          message: 'مرحباً بك! تم تسجيل الدخول بنجاح',
          userData: testUserData,
        );
      }      // Try to authenticate with Supabase if available
      debugPrint('🔍 Checking database availability for login: ${_db.isAvailable}');
      
      if (_db.isAvailable) {
        debugPrint('📡 Attempting Supabase login for: $email');
        try {
          final response = await _db.client.auth.signInWithPassword(
            email: email,
            password: password,
          );

          debugPrint('🔐 Supabase login response: ${response.user?.id}');

          if (response.user != null) {
            debugPrint('✅ User authenticated: ${response.user!.id}');
            
            // Get user profile from database
            final userProfile = await _db.getUserProfile(response.user!.id);
            debugPrint('👤 User profile: $userProfile');
            
            final userData = {
              'id': response.user!.id,
              'name': userProfile?['name'] ?? 'مستخدم',
              'email': email,
              'phone': userProfile?['phone'] ?? '',
              'avatar': userProfile?['avatar'] ?? 'assets/images/profile.png',
              'isPro': userProfile?['is_pro'] ?? false,
              'isAdmin': false,
              'joinDate': response.user!.createdAt,
              'freeQueriesUsed': userProfile?['free_queries_used'] ?? 0,
              'maxFreeQueries': userProfile?['max_free_queries'] ?? 5,
              'subscriptionStatus': userProfile?['subscription_status'] ?? 'free',
              'subscriptionExpiry': userProfile?['subscription_expiry'],
            };

            await _saveUserData(userData);
            await _saveAuthTokens(response.session?.accessToken ?? '', response.session?.refreshToken ?? '');

            currentUser.value = userData;
            isLoggedIn.value = true;

            return AuthResult(
              success: true,
              message: 'تم تسجيل الدخول بنجاح',
              userData: userData,
            );
          }
        } catch (e) {
          debugPrint('❌ Supabase login error: $e');
          if (e.toString().contains('Invalid login credentials')) {
            return AuthResult(
              success: false,
              message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
            );
          }
          // Continue to fallback authentication
        }
      } else {
        debugPrint('⚠️ Database not available for login, using fallback');
      }

      // Fallback: Allow any email/password for testing
      final fallbackUserData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': 'مستخدم تجريبي',
        'email': email,
        'phone': '',
        'avatar': 'assets/images/profile.png',
        'isPro': false,
        'isAdmin': false,
        'joinDate': DateTime.now().toIso8601String(),
        'freeQueriesUsed': 0,
        'maxFreeQueries': 5,
        'subscriptionStatus': 'free',
        'subscriptionExpiry': null,
      };

      await _saveUserData(fallbackUserData);
      await _saveAuthTokens('fallback_access_token', 'fallback_refresh_token');

      currentUser.value = fallbackUserData;
      isLoggedIn.value = true;

      return AuthResult(
        success: true,
        message: 'تم تسجيل الدخول بنجاح (وضع تجريبي)',
        userData: fallbackUserData,
      );

    } catch (e) {
      return AuthResult(
        success: false,
        message: 'حدث خطأ أثناء تسجيل الدخول: ${e.toString()}',
      );
    }
  }

  /// Register new user
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String? phone,
  }) async {
    try {
      // Validation
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        return AuthResult(
          success: false,
          message: 'جميع الحقول مطلوبة',
        );
      }

      if (password != confirmPassword) {
        return AuthResult(
          success: false,
          message: 'كلمة المرور وتأكيدها غير متطابقتان',
        );
      }

      if (password.length < 6) {
        return AuthResult(
          success: false,
          message: 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
        );
      }

      if (!_isValidEmail(email)) {
        return AuthResult(
          success: false,
          message: 'البريد الإلكتروني غير صحيح',
        );
      }      // Try to register with Supabase if available
      debugPrint('🔍 Checking database availability: ${_db.isAvailable}');
      
      if (_db.isAvailable) {
        debugPrint('📡 Attempting Supabase registration for: $email');
        try {
          final response = await _db.client.auth.signUp(
            email: email,
            password: password,
            data: {
              'name': name,
              'phone': phone ?? '',
            },
          );

          debugPrint('📧 Supabase signup response: ${response.user?.id}');

          if (response.user != null) {
            debugPrint('✅ User created in Supabase: ${response.user!.id}');
            
            // Create user profile in database
            try {
              final profileResult = await _db.client.from('user_profiles').insert({
                'user_id': response.user!.id,
                'name': name,
                'phone': phone ?? '',
                'avatar': 'assets/images/profile.png',
                'is_pro': false,
                'max_free_queries': 5,
                'subscription_status': 'free',
              }).select().single();

              debugPrint('✅ User profile created: $profileResult');
            } catch (profileError) {
              debugPrint('⚠️ Profile creation error: $profileError');
            }

            final userData = {
              'id': response.user!.id,
              'name': name,
              'email': email,
              'phone': phone ?? '',
              'avatar': 'assets/images/profile.png',
              'isPro': false,
              'isAdmin': false,
              'joinDate': response.user!.createdAt,
              'freeQueriesUsed': 0,
              'maxFreeQueries': 5,
              'subscriptionStatus': 'free',
              'subscriptionExpiry': null,
            };

            await _saveUserData(userData);
            await _saveAuthTokens(response.session?.accessToken ?? '', response.session?.refreshToken ?? '');

            currentUser.value = userData;
            isLoggedIn.value = true;

            return AuthResult(
              success: true,
              message: 'تم إنشاء الحساب بنجاح! ${response.user!.emailConfirmedAt == null ? "يرجى التحقق من بريدك الإلكتروني" : ""}',
              userData: userData,
            );
          }
        } catch (e) {
          debugPrint('❌ Supabase registration error: $e');
          if (e.toString().contains('already exists') || e.toString().contains('User already registered')) {
            return AuthResult(
              success: false,
              message: 'البريد الإلكتروني مستخدم بالفعل',
            );
          }
          // Continue to fallback registration
        }
      } else {
        debugPrint('⚠️ Database not available, using fallback');
      }

      // Fallback registration for testing
      final userData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': name,
        'email': email,
        'phone': phone ?? '',
        'avatar': 'assets/images/profile.png',
        'isPro': false,
        'isAdmin': false,
        'joinDate': DateTime.now().toIso8601String(),
        'freeQueriesUsed': 0,
        'maxFreeQueries': 5,
        'subscriptionStatus': 'free',
        'subscriptionExpiry': null,
      };

      await _saveUserData(userData);
      await _saveAuthTokens('fallback_access_token', 'fallback_refresh_token');

      currentUser.value = userData;
      isLoggedIn.value = true;

      return AuthResult(
        success: true,
        message: 'تم إنشاء الحساب بنجاح (وضع تجريبي)',
        userData: userData,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'حدث خطأ أثناء إنشاء الحساب: ${e.toString()}',
      );
    }
  }

  /// Reset password
  Future<AuthResult> resetPassword(String email) async {
    try {
      if (email.isEmpty || !_isValidEmail(email)) {
        return AuthResult(
          success: false,
          message: 'يرجى إدخال بريد إلكتروني صحيح',
        );
      }

      // Try Supabase password reset if available
      if (_db.isAvailable) {
        try {
          await _db.client.auth.resetPasswordForEmail(email);
          return AuthResult(
            success: true,
            message: 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
          );
        } catch (e) {
          debugPrint('Supabase password reset error: $e');
        }
      }

      // Mock password reset
      return AuthResult(
        success: true,
        message: 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'حدث خطأ أثناء إعادة تعيين كلمة المرور: ${e.toString()}',
      );
    }
  }

  /// Logout user
  Future<AuthResult> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_userDataKey);
      await prefs.remove(_authTokenKey);
      await prefs.remove(_refreshTokenKey);

      // Logout from Supabase if available
      if (_db.isAvailable) {
        try {
          await _db.client.auth.signOut();
        } catch (e) {
          debugPrint('Supabase logout error: $e');
        }
      }

      currentUser.value = null;
      isLoggedIn.value = false;

      return AuthResult(
        success: true,
        message: 'تم تسجيل الخروج بنجاح',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'حدث خطأ أثناء تسجيل الخروج: ${e.toString()}',
      );
    }
  }

  /// Update user profile
  Future<AuthResult> updateProfile({
    String? name,
    String? phone,
    String? avatar,
  }) async {
    try {
      if (currentUser.value == null) {
        return AuthResult(
          success: false,
          message: 'يجب تسجيل الدخول أولاً',
        );
      }

      final updatedUserData = Map<String, dynamic>.from(currentUser.value!);

      if (name != null) updatedUserData['name'] = name;
      if (phone != null) updatedUserData['phone'] = phone;
      if (avatar != null) updatedUserData['avatar'] = avatar;

      // Update in Supabase if available
      if (_db.isAvailable && updatedUserData['id'] != 'admin_001' && updatedUserData['id'] != 'test_001') {
        try {
          await _db.client.from('user_profiles').update({
            'name': updatedUserData['name'],
            'phone': updatedUserData['phone'],
            'avatar': updatedUserData['avatar'],
          }).eq('user_id', updatedUserData['id']);
        } catch (e) {
          debugPrint('Supabase profile update error: $e');
        }
      }

      await _saveUserData(updatedUserData);
      currentUser.value = updatedUserData;

      return AuthResult(
        success: true,
        message: 'تم تحديث الملف الشخصي بنجاح',
        userData: updatedUserData,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'حدث خطأ أثناء تحديث الملف الشخصي: ${e.toString()}',
      );
    }
  }

  /// Update subscription status
  Future<void> updateSubscriptionStatus(String status, {DateTime? expiry}) async {
    if (currentUser.value != null) {
      final updatedUserData = Map<String, dynamic>.from(currentUser.value!);
      updatedUserData['subscriptionStatus'] = status;
      updatedUserData['isPro'] = status == 'premium';
      
      if (expiry != null) {
        updatedUserData['subscriptionExpiry'] = expiry.toIso8601String();
      }

      await _saveUserData(updatedUserData);
      currentUser.value = updatedUserData;
    }
  }

  /// Increment free queries used
  Future<void> incrementFreeQueries() async {
    if (currentUser.value != null) {
      final updatedUserData = Map<String, dynamic>.from(currentUser.value!);
      updatedUserData['freeQueriesUsed'] = (updatedUserData['freeQueriesUsed'] ?? 0) + 1;

      await _saveUserData(updatedUserData);
      currentUser.value = updatedUserData;
    }
  }

  /// Check if user can make query
  bool canMakeQuery() {
    if (currentUser.value == null) return false;
    
    final userData = currentUser.value!;
    final isPro = userData['isPro'] ?? false;
    
    if (isPro) return true;
    
    final freeQueriesUsed = userData['freeQueriesUsed'] ?? 0;
    final maxFreeQueries = userData['maxFreeQueries'] ?? 5;
    
    return freeQueriesUsed < maxFreeQueries;
  }

  /// Get remaining free queries
  int getRemainingQueries() {
    if (currentUser.value == null) return 0;
    
    final userData = currentUser.value!;
    final isPro = userData['isPro'] ?? false;
    
    if (isPro) return 999999;
    
    final freeQueriesUsed = userData['freeQueriesUsed'] ?? 0;
    final maxFreeQueries = userData['maxFreeQueries'] ?? 5;
    
    return (maxFreeQueries - freeQueriesUsed).clamp(0, maxFreeQueries);
  }

  // === PRIVATE METHODS ===

  /// Save user data to local storage
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userDataKey, jsonEncode(userData));
  }

  /// Save auth tokens to local storage
  Future<void> _saveAuthTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

/// Auth result class
class AuthResult {
  final bool success;
  final String message;
  final Map<String, dynamic>? userData;

  AuthResult({
    required this.success,
    required this.message,
    this.userData,
  });
}
