import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/conversation_history_widget.dart';
import './widgets/message_input_widget.dart';
import './widgets/query_counter_widget.dart';
import './widgets/topic_suggestion_chips_widget.dart';
import './widgets/welcome_message_widget.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  _ChatHomeScreenState createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SubscriptionService _subscriptionService = SubscriptionService();
  
  bool _isMessageEmpty = true;
  int _freeQueriesRemaining = 5;
  bool _isRefreshing = false;

  // Mock conversation data
  final List<Map<String, dynamic>> _conversations = [
    {
      "id": 1,
      "type": "user",
      "message": "ما هي حقوقي كموظف في حالة الفصل التعسفي؟",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
    },
    {
      "id": 2,
      "type": "ai",
      "message":
          "بناءً على قانون العمل المصري، لديك عدة حقوق في حالة الفصل التعسفي",
      "quickSummary": "الحق في التعويض والإشعار المسبق",
      "detailedExplanation":
          "وفقاً لقانون العمل رقم 12 لسنة 2003، يحق للموظف المفصول تعسفياً الحصول على تعويض يعادل راتب شهرين عن كل سنة خدمة، بالإضافة إلى مكافأة نهاية الخدمة والإجازات المستحقة.",
      "legalBasis": "المادة 122 من قانون العمل المصري رقم 12 لسنة 2003",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
    },
    {
      "id": 3,
      "type": "user",
      "message": "كيف يمكنني تأسيس شركة محدودة المسؤولية؟",
      "timestamp": DateTime.now().subtract(Duration(hours: 5)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _messageController.addListener(_onMessageChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onMessageChanged() {
    setState(() {
      _isMessageEmpty = _messageController.text.trim().isEmpty;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate loading recent conversations
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Check subscription status for free users
    final hasSubscription = await _subscriptionService.hasActiveSubscription();
    
    if (!hasSubscription && _freeQueriesRemaining <= 0) {
      _showSubscriptionDialog();
      return;
    }

    setState(() {
      _conversations.insert(0, {
        "id": _conversations.length + 1,
        "type": "user",
        "message": message,
        "timestamp": DateTime.now(),
      });
      
      if (!hasSubscription) {
        _freeQueriesRemaining--;
      }
      
      _messageController.clear();
      _isMessageEmpty = true;
    });

    // Navigate to AI chat conversation
    Navigator.pushNamed(context, '/ai-chat-conversation');
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.star, color: AppTheme.primaryColor),
              SizedBox(width: 2.w),
              Text(
                'ترقية اشتراكك',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'لقد استنفدت استفساراتك المجانية اليوم.',
                style: TextStyle(fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Text(
                'قم بترقية اشتراكك للحصول على استفسارات غير محدودة!',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('لاحقاً'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, AppRoutes.subscriptionPlansScreen);
              },
              child: Text('ترقية الآن'),
            ),
          ],
        );
      },
    );
  }

  void _onTabChanged(int index) {
    switch (index) {
      case 0:
        // Already on Chat tab
        break;
      case 1:
        Navigator.pushNamed(context, '/document-upload-analysis');
        break;
      case 2:
        Navigator.pushNamed(context, '/legal-templates-library');
        break;
      case 3:
        Navigator.pushNamed(context, '/user-profile-settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.getShadowColor(true),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, '/user-profile-settings'),
                          child: CustomIconWidget(
                            iconName: 'settings',
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            size: 6.w,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        // Service Test Button (development)
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.serviceTestScreen),
                          child: Container(
                            padding: EdgeInsets.all(1.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.bug_report,
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 5.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'المستشار القانوني الذكي',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Premium subscription button
                    FutureBuilder<bool>(
                      future: _subscriptionService.hasActiveSubscription(),
                      builder: (context, snapshot) {
                        final hasSubscription = snapshot.data ?? false;
                        if (hasSubscription) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.accentLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 12.sp,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'Premium',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, AppRoutes.subscriptionPlansScreen),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppTheme.accentLight, Colors.orange],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.accentLight.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.upgrade,
                                    color: Colors.white,
                                    size: 14.sp,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'ترقية',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                color: AppTheme.lightTheme.scaffoldBackgroundColor,
                child: TabBar(
                  controller: _tabController,
                  onTap: _onTabChanged,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'chat',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Text('محادثة'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'description',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Text('وثائق'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'library_books',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Text('قوالب'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'person',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Text('الملف الشخصي'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 3.h),

                        // Welcome Message
                        WelcomeMessageWidget(),

                        SizedBox(height: 3.h),

                        // Topic Suggestion Chips
                        TopicSuggestionChipsWidget(
                          onTopicSelected: (topic) {
                            _messageController.text = topic;
                            _onMessageChanged();
                          },
                        ),

                        SizedBox(height: 3.h),

                        // Query Counter for Free Users
                        QueryCounterWidget(
                          queriesRemaining: _freeQueriesRemaining,
                          onUpgradePressed: () {
                            // Handle upgrade to premium
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('ترقية إلى النسخة المدفوعة قريباً'),
                                backgroundColor: AppTheme.getAccentColor(true),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 3.h),

                        // Conversation History
                        ConversationHistoryWidget(
                          conversations: _conversations,
                          onMessageLongPress: (message) {
                            _showMessageOptions(context, message);
                          },
                        ),

                        SizedBox(height: 10.h), // Space for input field
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Message Input Field
        bottomNavigationBar: MessageInputWidget(
          controller: _messageController,
          isMessageEmpty: _isMessageEmpty,
          canSendMessage: _freeQueriesRemaining > 0,
          onSendPressed: _sendMessage,
          onMicPressed: () {
            // Handle voice input
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('ميزة التسجيل الصوتي قريباً'),
              ),
            );
          },
        ),

        // Floating Action Button for Document Upload
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/document-upload-analysis');
          },
          backgroundColor: AppTheme.getAccentColor(true),
          child: CustomIconWidget(
            iconName: 'upload_file',
            color: Colors.black,
            size: 6.w,
          ),
        ),
      ),
    );
  }

  void _showMessageOptions(BuildContext context, String message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'copy',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
              title: Text('نسخ النص'),
              onTap: () {
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
                size: 5.w,
              ),
              title: Text('مشاركة'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('مشاركة النص')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
