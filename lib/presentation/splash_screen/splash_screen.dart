import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/background_pattern_widget.dart';
import './widgets/loading_dots_widget.dart';

// lib/presentation/splash_screen/splash_screen.dart

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _handleInitialization();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
  }

  Future<void> _handleInitialization() async {
    try {
      // Simulate app initialization tasks
      await Future.wait([
        _preloadAssets(),
        _checkUserAuthentication(),
        _loadAppSettings(),
        Future.delayed(
            const Duration(milliseconds: 2500)), // Minimum display time
      ]);

      // Navigate to appropriate screen
      await _navigateToNextScreen();
    } catch (e) {
      // Handle initialization errors gracefully
      debugPrint('Splash initialization error: $e');
      await _navigateToNextScreen();
    }
  }

  Future<void> _preloadAssets() async {
    // Preload critical assets
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _checkUserAuthentication() async {
    // Initialize auth service
    await _authService.initialize();
  }

  Future<void> _loadAppSettings() async {
    // Load app settings and preferences
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> _navigateToNextScreen() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    // Add fade out animation before navigation
    await _fadeController.reverse();

    if (!mounted) return;

    if (isFirstTime) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboardingCarousel);
    } else {
      // Check authentication status before navigating to main screen
      if (_authService.isLoggedIn.value) {
        Navigator.pushReplacementNamed(context, AppRoutes.chatHomeScreen);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryLight,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.primaryLight,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Stack(
          children: [
            // Background pattern
            const BackgroundPatternWidget(),

            // Service Test Button (development only)
            Positioned(
              top: 50,
              right: 20,
              child: GestureDetector(
                onLongPress: () {
                  Navigator.pushNamed(context, AppRoutes.serviceTestScreen);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.settings,
                    color: Colors.white.withOpacity(0.3),
                    size: 20,
                  ),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      children: [
                        // Logo section
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: AnimatedBuilder(
                              animation: _scaleAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _scaleAnimation.value,
                                  child: const AnimatedLogoWidget(),
                                );
                              },
                            ),
                          ),
                        ),

                        // App name section
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // English app name
                              Text(
                                'AI Legal Advisor',
                                style: GoogleFonts.inter(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(height: 0.5.h),

                              // Arabic app name
                              Text(
                                'مستشار قانوني ذكي',
                                style: GoogleFonts.tajawal(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentLight,
                                  letterSpacing: 0.8,
                                ),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                              ),

                              SizedBox(height: 1.h),

                              // Tagline
                              Text(
                                'Professional Legal Guidance Powered by AI',
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white70,
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        // Loading section
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const LoadingDotsWidget(),
                              SizedBox(height: 1.h),
                              Text(
                                'Loading...',
                                style: GoogleFonts.inter(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white60,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 1.h),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
