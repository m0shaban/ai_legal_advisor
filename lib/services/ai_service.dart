import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiService {
  // Singleton pattern
  static final AiService _instance = AiService._internal();
  factory AiService() => _instance;
  AiService._internal();

  late final Dio _dio;
  
  // API Keys from environment
  final String? _nvidiaApiKey = dotenv.env['NVIDIA_API_KEY'];
  final String? _openaiApiKey = dotenv.env['OPENAI_API_KEY'];
  final String? _geminiApiKey = dotenv.env['GEMINI_API_KEY'];
  
  // API Endpoints
  static const String _nvidiaBaseUrl = 'https://integrate.api.nvidia.com/v1';
  static const String _openaiBaseUrl = 'https://api.openai.com/v1';
  
  void initialize() {
    _dio = Dio();
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    
    // Add interceptors for logging in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }
  }  /// Get legal advice using NVIDIA API (Primary)
  Future<AiResponse> getLegalAdviceNvidia(String query, {String? context}) async {
    if (_nvidiaApiKey == null || _nvidiaApiKey.isEmpty || _nvidiaApiKey.contains('real-key-here')) {
      debugPrint('⚠️ NVIDIA API key not configured - using mock response');
      return _getMockResponse(query);
    }

    try {
      final messages = [
        {
          "role": "system", 
          "content": """أنت مستشار قانوني ذكي متخصص في القانون المصري والعربي. قدم استشارات قانونية دقيقة ومفصلة باللغة العربية.

يجب أن تتضمن إجابتك:
1. ملخص سريع للحالة
2. شرح مفصل للوضع القانوني
3. الأساس القانوني (أرقام المواد والقوانين)
4. نصائح عملية للتطبيق

تأكد من أن المشورة مبنية على القوانين الحديثة وتتضمن تحذيرات مناسبة."""
        },
        {"role": "user", "content": query}
      ];

      if (context != null && context.isNotEmpty) {
        messages.insert(1, {"role": "assistant", "content": "السياق: $context"});
      }

      final response = await _dio.post(
        '$_nvidiaBaseUrl/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_nvidiaApiKey',
            'Content-Type': 'application/json',
          },
        ),        data: {
          'model': 'nvidia/llama-3.1-nemotron-ultra-253b-v1',
          'messages': messages,
          'temperature': 0.6,
          'top_p': 0.95,
          'max_tokens': 4096,
          'frequency_penalty': 0,
          'presence_penalty': 0,
          'stream': false,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final content = data['choices'][0]['message']['content'];
        return _parseAiResponse(content, 'nvidia');
      } else {
        throw AiException('NVIDIA API Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('NVIDIA API Error: $e');
      // Fallback to OpenAI if NVIDIA fails
      return await getLegalAdviceOpenAI(query, context: context);
    }
  }
  /// Get legal advice using OpenAI API (Fallback)
  Future<AiResponse> getLegalAdviceOpenAI(String query, {String? context}) async {
    if (_openaiApiKey == null || _openaiApiKey.isEmpty || _openaiApiKey == 'your-openai-api-key-here') {
      return _getMockResponse(query);
    }

    try {
      final messages = [
        {
          "role": "system", 
          "content": """أنت مستشار قانوني خبير في القانون المصري والعربي. قدم استشارات قانونية دقيقة ومهنية باللغة العربية.

Format your response as JSON with these fields:
{
  "quickSummary": "ملخص سريع للاستشارة",
  "detailedExplanation": "شرح مفصل للوضع القانوني مع الخطوات والإجراءات",
  "legalBasis": "الأساس القانوني مع أرقام المواد والقوانين المرجعية",
  "practicalAdvice": "نصائح عملية وخطوات للتنفيذ"
}"""
        },
        {"role": "user", "content": query}
      ];

      final response = await _dio.post(
        '$_openaiBaseUrl/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_openaiApiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': 'gpt-3.5-turbo',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 2000,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final content = data['choices'][0]['message']['content'];
        return _parseAiResponse(content, 'openai');
      } else {
        throw AiException('OpenAI API Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('OpenAI API Error: $e');
      return _getMockResponse(query);
    }
  }

  /// Parse AI response and extract structured data
  AiResponse _parseAiResponse(String content, String provider) {
    try {
      // Try to parse as JSON first (for OpenAI structured responses)
      if (content.trim().startsWith('{')) {
        final jsonData = jsonDecode(content);
        return AiResponse(
          content: content,
          quickSummary: jsonData['quickSummary'] ?? _extractQuickSummary(content),
          detailedExplanation: jsonData['detailedExplanation'] ?? _extractDetailedExplanation(content),
          legalBasis: jsonData['legalBasis'] ?? _extractLegalBasis(content),
          practicalAdvice: jsonData['practicalAdvice'],
          provider: provider,
          timestamp: DateTime.now(),
        );
      }
    } catch (e) {
      // If JSON parsing fails, extract manually
    }

    // Manual extraction for unstructured responses
    return AiResponse(
      content: content,
      quickSummary: _extractQuickSummary(content),
      detailedExplanation: _extractDetailedExplanation(content),
      legalBasis: _extractLegalBasis(content),
      practicalAdvice: _extractPracticalAdvice(content),
      provider: provider,
      timestamp: DateTime.now(),
    );
  }

  /// Extract quick summary from response
  String _extractQuickSummary(String content) {
    final lines = content.split('\n');
    if (lines.isNotEmpty) {
      return lines.first.replaceAll(RegExp(r'^[#*\-\s]+'), '').trim();
    }
    return content.length > 100 ? '${content.substring(0, 97)}...' : content;
  }

  /// Extract detailed explanation from response
  String _extractDetailedExplanation(String content) {
    final lines = content.split('\n').where((line) => line.trim().isNotEmpty).toList();
    if (lines.length > 1) {
      return lines.skip(1).take(lines.length - 2).join('\n').trim();
    }
    return content;
  }

  /// Extract legal basis from response
  String _extractLegalBasis(String content) {
    final regex = RegExp(r'(قانون|مادة|المادة|القانون)\s+[^\n]*', caseSensitive: false);
    final matches = regex.allMatches(content);
    if (matches.isNotEmpty) {
      return matches.map((m) => m.group(0)).join(', ');
    }
    return 'القانون المدني المصري، قانون المرافعات المدنية والتجارية';
  }

  /// Extract practical advice from response
  String? _extractPracticalAdvice(String content) {
    final lines = content.split('\n');
    final adviceKeywords = ['نصيحة', 'توصية', 'يُنصح', 'يجب', 'من المهم'];
    
    for (final line in lines) {
      if (adviceKeywords.any((keyword) => line.contains(keyword))) {
        return line.trim();
      }
    }
    return null;
  }

  /// Generate mock response for testing/fallback
  AiResponse _getMockResponse(String query) {
    final responses = [
      {
        'quickSummary': 'استشارة قانونية حول الموضوع المطروح',
        'detailedExplanation': '''بناءً على القانون المصري، يحق لك اتخاذ الإجراءات القانونية المناسبة. يجب عليك أولاً:

1. جمع الأدلة والمستندات المطلوبة
2. استشارة محامٍ مختص للحصول على المشورة التفصيلية
3. تقديم الطلب للجهة المختصة خلال المدة القانونية المحددة

هذه الاستشارة تعتبر إرشاداً أولياً ولا تغني عن استشارة محامٍ مختص.''',
        'legalBasis': 'القانون المدني المصري - المواد 163-170، قانون المرافعات المدنية والتجارية',
        'practicalAdvice': 'يُنصح بالتوثيق الدقيق لجميع المراسلات والاتفاقيات'
      },
      {
        'quickSummary': 'توضيح الحقوق والواجبات القانونية',
        'detailedExplanation': '''وفقاً للتشريع المصري، تتمتع بحقوق محددة في هذه الحالة:

• الحق في الحصول على المعلومات الكاملة
• الحق في الاعتراض على القرارات غير المبررة
• الحق في اللجوء للقضاء في حالة النزاع

كما تقع عليك واجبات منها الالتزام بالمواعيد المحددة قانوناً والتعامل بحسن نية.''',
        'legalBasis': 'قانون حماية المستهلك رقم 181 لسنة 2018، القانون المدني المصري',
        'practicalAdvice': 'احتفظ بنسخ من جميع المستندات والمراسلات'
      }
    ];

    final selectedResponse = responses[DateTime.now().millisecondsSinceEpoch % responses.length];
    
    return AiResponse(
      content: '''${selectedResponse['quickSummary']}

${selectedResponse['detailedExplanation']}

الأساس القانوني: ${selectedResponse['legalBasis']}

${selectedResponse['practicalAdvice']}''',
      quickSummary: selectedResponse['quickSummary']!,
      detailedExplanation: selectedResponse['detailedExplanation']!,
      legalBasis: selectedResponse['legalBasis']!,
      practicalAdvice: selectedResponse['practicalAdvice'],
      provider: 'mock',
      timestamp: DateTime.now(),
    );
  }
  /// Get available AI providers
  List<String> getAvailableProviders() {
    final providers = <String>[];
    
    if (_nvidiaApiKey != null && _nvidiaApiKey.isNotEmpty && _nvidiaApiKey != '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') {
      providers.add('nvidia');
    }
    
    if (_openaiApiKey != null && _openaiApiKey.isNotEmpty && _openaiApiKey != 'your-openai-api-key-here') {
      providers.add('openai');
    }
    
    if (_geminiApiKey != null && _geminiApiKey.isNotEmpty && _geminiApiKey != 'your-gemini-api-key-here') {
      providers.add('gemini');
    }
    
    providers.add('mock'); // Always available for testing
    
    return providers;
  }
  /// Check API health
  Future<bool> checkApiHealth(String provider) async {
    try {
      switch (provider) {
        case 'nvidia':
          if (_nvidiaApiKey == null || _nvidiaApiKey.isEmpty) return false;
          final response = await _dio.get(
            '$_nvidiaBaseUrl/models',
            options: Options(
              headers: {'Authorization': 'Bearer $_nvidiaApiKey'},
              receiveTimeout: const Duration(seconds: 5),
            ),
          );
          return response.statusCode == 200;
          
        case 'openai':
          if (_openaiApiKey == null || _openaiApiKey.isEmpty) return false;
          final response = await _dio.get(
            '$_openaiBaseUrl/models',
            options: Options(
              headers: {'Authorization': 'Bearer $_openaiApiKey'},
              receiveTimeout: const Duration(seconds: 5),
            ),
          );
          return response.statusCode == 200;
          
        default:
          return true; // Mock is always healthy
      }
    } catch (e) {
      debugPrint('API Health Check Failed for $provider: $e');
      return false;
    }
  }
}

/// AI Response Model
class AiResponse {
  final String content;
  final String quickSummary;
  final String detailedExplanation;
  final String legalBasis;
  final String? practicalAdvice;
  final String provider;
  final DateTime timestamp;

  AiResponse({
    required this.content,
    required this.quickSummary,
    required this.detailedExplanation,
    required this.legalBasis,
    this.practicalAdvice,
    required this.provider,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'quickSummary': quickSummary,
      'detailedExplanation': detailedExplanation,
      'legalBasis': legalBasis,
      'practicalAdvice': practicalAdvice,
      'provider': provider,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      content: json['content'],
      quickSummary: json['quickSummary'],
      detailedExplanation: json['detailedExplanation'],
      legalBasis: json['legalBasis'],
      practicalAdvice: json['practicalAdvice'],
      provider: json['provider'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

/// AI Exception Class
class AiException implements Exception {
  final String message;
  AiException(this.message);
  
  @override
  String toString() => 'AiException: $message';
}
