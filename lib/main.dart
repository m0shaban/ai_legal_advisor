import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/custom_error_widget.dart';
import 'core/app_export.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Load environment variables
    await dotenv.load();
    debugPrint('✅ Environment variables loaded');
    
    // Initialize Supabase only once
    try {
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
        debug: true,
      );
      debugPrint('✅ Supabase initialized successfully');
    } catch (e) {
      // If already initialized, just log that it's already done
      if (e.toString().contains('already initialized')) {
        debugPrint('✅ Supabase already initialized');
      } else {
        debugPrint('❌ Supabase initialization failed: $e');
      }
    }
    
    // Initialize Firebase (conditionally)
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      debugPrint('Firebase initialization failed (OK for development): $e');
    }
    
    // Initialize services
    await DatabaseService().initialize();
    await AuthService().initialize();
    AiService().initialize();
    
    // Initialize analytics service
    try {
      await AnalyticsService().initialize();
    } catch (e) {
      debugPrint('Analytics service initialization failed: $e');
    }
    
  } catch (e) {
    debugPrint('Initialization error: $e');
  }
  
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(
      errorDetails: details,
    );
  };
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  ]).then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'ai_legal_advisor',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.initial,
      );
    });
  }
}
