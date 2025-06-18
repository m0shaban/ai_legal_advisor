import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../services/database_service.dart';
import '../../services/ai_service.dart';
import '../../services/analytics_service.dart';

class ServiceTestScreen extends StatefulWidget {
  const ServiceTestScreen({super.key});

  @override
  State<ServiceTestScreen> createState() => _ServiceTestScreenState();
}

class _ServiceTestScreenState extends State<ServiceTestScreen> {
  String _testResults = 'Testing services...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _testServices();
  }

  Future<void> _testServices() async {
    final results = StringBuffer();
    
    try {
      // Test environment variables
      results.writeln('🔧 Environment Variables:');
      results.writeln('SUPABASE_URL: ${dotenv.env['SUPABASE_URL']?.substring(0, 30)}...');
      results.writeln('SUPABASE_ANON_KEY: ${dotenv.env['SUPABASE_ANON_KEY']?.substring(0, 30)}...');
      results.writeln('NVIDIA_API_KEY: ${dotenv.env['NVIDIA_API_KEY']?.substring(0, 30)}...');
      results.writeln('');

      // Test Database Service
      results.writeln('📊 Database Service (Supabase):');
      try {
        final dbService = DatabaseService();
        await dbService.initialize();
        if (dbService.isAvailable) {
          results.writeln('✅ Supabase connection: Available');
            // Test simple query
          try {
            await dbService.client
                .from('users')
                .select('id')
                .limit(1);
            results.writeln('✅ Database query: Success');
          } catch (e) {
            results.writeln('⚠️ Database query: ${e.toString().substring(0, 50)}...');
          }
        } else {
          results.writeln('❌ Supabase connection: Not available');
        }
      } catch (e) {
        results.writeln('❌ Database Service: ${e.toString().substring(0, 50)}...');
      }
      results.writeln('');      // Test AI Service
      results.writeln('🤖 AI Service:');
      try {
        final aiService = AiService();
        aiService.initialize();
        results.writeln('✅ AI Service initialized');
        
        // Test simple query
        try {
          final response = await aiService.getLegalAdviceNvidia('Test message');
          results.writeln('✅ AI Query: ${response.content.substring(0, 30)}...');
        } catch (e) {
          results.writeln('⚠️ AI Query: ${e.toString().substring(0, 50)}...');
        }
      } catch (e) {
        results.writeln('❌ AI Service: ${e.toString().substring(0, 50)}...');
      }
      results.writeln('');
      
      // Test Analytics Service
      results.writeln('📈 Analytics Service:');
      try {
        final analyticsService = AnalyticsService();
        await analyticsService.initialize();
        results.writeln('✅ Analytics Service initialized');
        
        // Test log event
        try {
          await analyticsService.logCustomEvent(
            eventName: 'test_event',
            parameters: {'test': 'value'},
          );
          results.writeln('✅ Analytics Event: Logged');
        } catch (e) {
          results.writeln('⚠️ Analytics Event: ${e.toString().substring(0, 50)}...');
        }
      } catch (e) {
        results.writeln('❌ Analytics Service: ${e.toString().substring(0, 50)}...');
      }

    } catch (e) {
      results.writeln('❌ General Error: $e');
    }

    setState(() {
      _testResults = results.toString();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Tests'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Testing services...'),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Service Test Results:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        _testResults,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          _testServices();
                        },
                        child: const Text('Re-test Services'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
