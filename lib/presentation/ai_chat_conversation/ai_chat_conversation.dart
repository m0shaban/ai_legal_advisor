import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/ai_response_bubble_widget.dart';
import './widgets/chat_input_widget.dart';
import './widgets/message_bubble_widget.dart';
import './widgets/typing_indicator_widget.dart';

class AiChatConversation extends StatefulWidget {
  const AiChatConversation({super.key});

  @override
  _AiChatConversationState createState() => _AiChatConversationState();
}

class _AiChatConversationState extends State<AiChatConversation>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  // Services
  final AiService _aiService = AiService();
  
  bool _isTyping = false;
  bool _isLoading = false;
  int _freeQueriesUsed = 3;
  final int _maxFreeQueries = 5;
  final bool _isPremiumUser = false;

  // Mock conversation data
  final List<Map<String, dynamic>> _messages = [
    {
      "id": "1",
      "type": "user",
      "content": "ما هي حقوقي كمستأجر في مصر؟",
      "timestamp": DateTime.now().subtract(Duration(minutes: 10)),
      "isUser": true,
    },
    {
      "id": "2",
      "type": "ai",
      "content": "حقوق المستأجر في مصر محمية بموجب القانون المدني المصري",
      "quickSummary":
          "المستأجر له حقوق أساسية في الانتفاع بالعين المؤجرة وحمايته من الطرد التعسفي",
      "detailedExplanation":
          """حقوق المستأجر في مصر تشمل: • **الحق في الانتفاع بالعين المؤجرة**: يحق للمستأجر استخدام العقار المؤجر وفقاً للغرض المتفق عليه • **الحماية من الطرد التعسفي**: لا يجوز للمؤجر طرد المستأجر إلا بحكم قضائي • **الحق في التجديد**: في عقود الإيجار القديمة، يحق للمستأجر تجديد العقد • **الحق في الصيانة**: المؤجر ملزم بصيانة العقار والحفاظ على صلاحيته للسكن • **الحق في الخصوصية**: لا يجوز للمؤجر دخول العقار دون إذن المستأجر""",
      "legalBasis":
          "القانون المدني المصري - المواد 563-610، قانون إيجار الأماكن رقم 4 لسنة 1996",
      "timestamp": DateTime.now().subtract(Duration(minutes: 9)),
      "isUser": false,
      "isFavorite": false,
    },
    {
      "id": "3",
      "type": "user",
      "content": "هل يمكن للمؤجر زيادة الإيجار؟",
      "timestamp": DateTime.now().subtract(Duration(minutes: 5)),
      "isUser": true,
    },
    {
      "id": "4",
      "type": "ai",
      "content": "زيادة الإيجار تخضع لقواعد قانونية محددة حسب نوع العقد",
      "quickSummary":
          "زيادة الإيجار مسموحة في العقود الجديدة بالاتفاق، وفي العقود القديمة وفقاً للقانون",
      "detailedExplanation":
          """قواعد زيادة الإيجار في مصر: **للعقود الجديدة (بعد 1996):** • يحق للمؤجر والمستأجر الاتفاق على زيادة الإيجار • الزيادة تتم بموجب اتفاق مكتوب • يمكن ربط الزيادة بمعدل التضخم أو نسبة محددة **للعقود القديمة (قبل 1996):** • الزيادة محددة بنسب قانونية • تطبق الزيادة التدريجية وفقاً للقانون • لا يجوز زيادة الإيجار بشكل تعسفي **الإجراءات القانونية:** • يجب إخطار المستأجر كتابياً قبل 30 يوماً • في حالة الرفض، يمكن اللجوء للمحكمة • المحكمة تقدر الزيادة العادلة""",
      "legalBasis":
          "قانون إيجار الأماكن رقم 4 لسنة 1996، القانون المدني المصري المادة 563",
      "timestamp": DateTime.now().subtract(Duration(minutes: 4)),
      "isUser": false,
      "isFavorite": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    // Check free query limit
    if (!_isPremiumUser && _freeQueriesUsed >= _maxFreeQueries) {
      _showSubscriptionDialog();
      return;
    }

    final messageText = _messageController.text.trim();
    _messageController.clear();

    // Add user message
    setState(() {
      _messages.add({
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "type": "user",
        "content": messageText,
        "timestamp": DateTime.now(),
        "isUser": true,
      });
      _isTyping = true;
      _isLoading = true;
      if (!_isPremiumUser) _freeQueriesUsed++;
    });

    _scrollToBottom();

    try {
      // Get AI response using NVIDIA API (with fallback to OpenAI)
      final aiResponse = await _aiService.getLegalAdviceNvidia(messageText);

      // Add AI response
      setState(() {
        _messages.add({
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "type": "ai",
          "content": aiResponse.content,
          "quickSummary": aiResponse.quickSummary,
          "detailedExplanation": aiResponse.detailedExplanation,
          "legalBasis": aiResponse.legalBasis,
          "timestamp": aiResponse.timestamp,
          "isUser": false,
          "isFavorite": false,
        });
        _isTyping = false;
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to mock response if API fails
      setState(() {
        _messages.add({
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "type": "ai",
          "content": "هذا رد تجريبي من المساعد القانوني الذكي",
          "quickSummary": "ملخص سريع للاستشارة القانونية المطلوبة",
          "detailedExplanation": """شرح تفصيلي للموضوع القانوني:

• **النقطة الأولى**: تفسير قانوني مفصل
• **النقطة الثانية**: الإجراءات المطلوبة
• **النقطة الثالثة**: النصائح العملية

يرجى ملاحظة أن هذه استشارة قانونية أولية ولا تغني عن استشارة محامٍ مختص.""",
          "legalBasis": "القانون المدني المصري، قانون المرافعات المدنية والتجارية",
          "timestamp": DateTime.now(),
          "isUser": false,
          "isFavorite": false,
        });
        _isTyping = false;
        _isLoading = false;
      });
    }

    _scrollToBottom();

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'انتهت استشاراتك المجانية',
          style: AppTheme.lightTheme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'star',
              color: AppTheme.getAccentColor(true),
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'لقد استخدمت $_maxFreeQueries استشارات مجانية هذا الشهر',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'اشترك الآن للحصول على استشارات غير محدودة',
              style: AppTheme.lightTheme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('لاحقاً'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to subscription screen
            },
            child: Text('اشترك الآن'),
          ),
        ],
      ),
    );
  }

  void _onMessageLongPress(Map<String, dynamic> message) {
    if (message['isUser']) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'copy',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('نسخ النص'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message['content']));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم نسخ النص')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('مشاركة'),
              onTap: () {
                Navigator.pop(context);
                // Implement share functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName:
                    message['isFavorite'] ? 'favorite' : 'favorite_border',
                color: message['isFavorite']
                    ? Colors.red
                    : AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text(
                  message['isFavorite'] ? 'إزالة من المفضلة' : 'إضافة للمفضلة'),
              onTap: () {
                setState(() {
                  message['isFavorite'] = !message['isFavorite'];
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshConversation() async {
    // Simulate loading conversation history
    await Future.delayed(Duration(seconds: 1));
    // In real app, load more messages from API
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.lightTheme.primaryColor,
          elevation: 2,
          leading: IconButton(
            icon: CustomIconWidget(
              iconName: 'arrow_forward',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'المساعد القانوني الذكي',
                style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
              ),
              if (!_isPremiumUser)
                Text(
                  'الاستشارات المتبقية: ${_maxFreeQueries - _freeQueriesUsed}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary
                        .withValues(alpha: 0.8),
                  ),
                ),
            ],
          ),
          actions: [
            if (!_isPremiumUser)
              TextButton(
                onPressed: () {
                  // Navigate to subscription
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: AppTheme.getAccentColor(true),
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'ترقية',
                      style: TextStyle(
                        color: AppTheme.getAccentColor(true),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            IconButton(
              icon: CustomIconWidget(
                iconName: 'more_vert',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
              onPressed: () {
                // Show menu
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Chat messages
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshConversation,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isTyping) {
                        return TypingIndicatorWidget();
                      }

                      final message = _messages[index];
                      return GestureDetector(
                        onLongPress: () => _onMessageLongPress(message),
                        child: message['isUser']
                            ? MessageBubbleWidget(
                                message: message['content'],
                                timestamp: message['timestamp'],
                                isUser: true,
                              )
                            : AiResponseBubbleWidget(
                                content: message['content'],
                                quickSummary: message['quickSummary'],
                                detailedExplanation:
                                    message['detailedExplanation'],
                                legalBasis: message['legalBasis'],
                                timestamp: message['timestamp'],
                                isFavorite: message['isFavorite'] ?? false,
                                onFavoriteToggle: () {
                                  setState(() {
                                    message['isFavorite'] =
                                        !(message['isFavorite'] ?? false);
                                  });
                                },
                              ),
                      );
                    },
                  ),
                ),
              ),

              // Chat input
              ChatInputWidget(
                controller: _messageController,
                focusNode: _messageFocusNode,
                onSend: _sendMessage,
                onAttachment: () {
                  Navigator.pushNamed(context, '/document-upload-analysis');
                },
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
