import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/logout_button_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/subscription_status_widget.dart';

class UserProfileSettings extends StatefulWidget {
  const UserProfileSettings({super.key});

  @override
  _UserProfileSettingsState createState() => _UserProfileSettingsState();
}

class _UserProfileSettingsState extends State<UserProfileSettings>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _authService = AuthService();
  final SubscriptionService _subscriptionService = SubscriptionService();
  
  bool _notificationsEnabled = true;
  bool _isDarkTheme = false;
  String _selectedLanguage = 'العربية';
  double _textSize = 16.0;

  // Get user data from AuthService
  Map<String, dynamic> get userData {
    final currentUser = _authService.currentUser.value;
    if (currentUser != null) {
      return currentUser;
    }
    // Fallback data if no user logged in
    return {
      "name": "مستخدم ضيف",
      "email": "guest@example.com",
      "avatar": "assets/images/profile.png",
      "subscriptionPlan": "Free",
      "renewalDate": "15/03/2024",
      "isPro": false,
    };
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProfileTab(),
                    _buildSettingsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.primaryColor,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      title: Text(
        'الملف الشخصي والإعدادات',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      elevation: 2,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.lightTheme.primaryColor,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        indicatorColor: AppTheme.lightTheme.primaryColor,
        indicatorWeight: 3,
        labelStyle: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.titleMedium,
        tabs: [
          Tab(
            text: 'الملف الشخصي',
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
          ),
          Tab(
            text: 'الإعدادات',
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeaderWidget(
            userData: userData,
            onEditPressed: () => _showEditProfileDialog(),
          ),
          SizedBox(height: 24),
          SubscriptionStatusWidget(
            userData: userData,
            onManagePressed: () => _showSubscriptionDialog(),
          ),
          SizedBox(height: 24),
          _buildConversationHistorySection(),
          SizedBox(height: 32),
          LogoutButtonWidget(
            onLogoutPressed: () => _showLogoutDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSectionWidget(
            title: 'إعدادات الحساب',
            children: [
              _buildSettingsTile(
                icon: 'edit',
                title: 'تعديل الملف الشخصي',
                onTap: () => _showEditProfileDialog(),
              ),
              _buildSettingsTile(
                icon: 'lock',
                title: 'تغيير كلمة المرور',
                onTap: () => _showChangePasswordDialog(),
              ),
              _buildSwitchTile(
                icon: 'notifications',
                title: 'تفضيلات الإشعارات',
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 24),
          SettingsSectionWidget(
            title: 'إعدادات التطبيق',
            children: [
              _buildSettingsTile(
                icon: 'language',
                title: 'اللغة',
                subtitle: _selectedLanguage,
                onTap: () => _showLanguageDialog(),
              ),
              _buildSwitchTile(
                icon: 'dark_mode',
                title: 'المظهر الداكن',
                value: _isDarkTheme,
                onChanged: (value) {
                  setState(() {
                    _isDarkTheme = value;
                  });
                },
              ),
              _buildSettingsTile(
                icon: 'text_fields',
                title: 'حجم النص',
                subtitle: 'متوسط',
                onTap: () => _showTextSizeDialog(),
              ),
            ],
          ),
          SizedBox(height: 24),
          SettingsSectionWidget(
            title: 'القانونية',
            children: [
              _buildSettingsTile(
                icon: 'description',
                title: 'شروط الخدمة',
                onTap: () => _openExternalLink('terms'),
                trailing: CustomIconWidget(
                  iconName: 'open_in_new',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              _buildSettingsTile(
                icon: 'privacy_tip',
                title: 'سياسة الخصوصية',
                onTap: () => _openExternalLink('privacy'),
                trailing: CustomIconWidget(
                  iconName: 'open_in_new',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              _buildSettingsTile(
                icon: 'warning',
                title: 'إخلاء مسؤولية الذكاء الاصطناعي',
                onTap: () => _showAIDisclaimerDialog(),
                trailing: CustomIconWidget(
                  iconName: 'open_in_new',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          SettingsSectionWidget(
            title: 'الدعم',
            children: [
              _buildSettingsTile(
                icon: 'help',
                title: 'مركز المساعدة',
                subtitle: 'الأسئلة الشائعة والدعم',
                onTap: () => _openExternalLink('help'),
              ),
              _buildSettingsTile(
                icon: 'contact_support',
                title: 'اتصل بالدعم',
                subtitle: 'تواصل مع فريق الدعم',
                onTap: () => _openExternalLink('contact'),
              ),
              _buildSettingsTile(
                icon: 'star',
                title: 'قيم التطبيق',
                subtitle: 'شاركنا رأيك في المتجر',
                onTap: () => _openExternalLink('rate'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConversationHistorySection() {
    return SettingsSectionWidget(
      title: 'سجل المحادثات',
      children: [
        _buildSettingsTile(
          icon: 'download',
          title: 'تصدير المحادثات',
          subtitle: 'حفظ المحادثات كملف PDF',
          onTap: () => _showExportDialog(),
        ),
        _buildSettingsTile(
          icon: 'delete',
          title: 'مسح السجل',
          subtitle: 'حذف جميع المحادثات',
          onTap: () => _showClearHistoryDialog(),
          textColor: AppTheme.lightTheme.colorScheme.error,
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required String icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: textColor ?? AppTheme.lightTheme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: trailing ??
          CustomIconWidget(
            iconName: 'chevron_left',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildSwitchTile({
    required String icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.lightTheme.primaryColor,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تعديل الملف الشخصي'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'الاسم',
                  hintText: userData['name'],
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  hintText: userData['email'],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم حفظ التغييرات')),
                );
              },
              child: Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تغيير كلمة المرور'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور الحالية',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور الجديدة',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'تأكيد كلمة المرور الجديدة',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم تغيير كلمة المرور')),
                );
              },
              child: Text('تغيير'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('اختر اللغة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('العربية'),
                value: 'العربية',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: Text('English'),
                value: 'English',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTextSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('حجم النص'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'نموذج النص العربي',
                style: TextStyle(fontSize: _textSize),
              ),
              SizedBox(height: 16),
              Slider(
                value: _textSize,
                min: 12.0,
                max: 24.0,
                divisions: 6,
                label: _textSize.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _textSize = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إغلاق'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubscriptionDialog() async {
    final hasSubscription = await _subscriptionService.hasActiveSubscription();
    
    if (hasSubscription) {
      // Show subscription management options
      showDialog(
        context: context,
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Row(
              children: [
                Icon(Icons.star, color: AppTheme.primaryColor),
                SizedBox(width: 2.w),
                Text('إدارة الاشتراك'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('أنت مشترك حالياً في الخطة المميزة'),
                SizedBox(height: 2.h),
                Text(
                  'يمكنك إلغاء الاشتراك أو تغيير الخطة',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إغلاق'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final result = await _subscriptionService.cancelSubscription();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result.message ?? 'تم إلغاء الاشتراك'),
                      backgroundColor: result.success ? Colors.green : Colors.red,
                    ),
                  );
                  setState(() {}); // Refresh UI
                },
                child: Text('إلغاء الاشتراك', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      );
    } else {
      // Navigate to subscription plans
      Navigator.pushNamed(context, AppRoutes.subscriptionPlansScreen);
    }
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تصدير المحادثات'),
          content: Text('هل تريد تصدير جميع محادثاتك كملف PDF؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('جاري تصدير المحادثات...')),
                );
              },
              child: Text('تصدير'),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('مسح السجل'),
          content: Text(
              'هل أنت متأكد من حذف جميع المحادثات؟ لا يمكن التراجع عن هذا الإجراء.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم حذف جميع المحادثات')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: Text('حذف'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAIDisclaimerDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('إخلاء مسؤولية الذكاء الاصطناعي'),
          content: SingleChildScrollView(
            child: Text(
              'هذا التطبيق يستخدم الذكاء الاصطناعي لتقديم المشورة القانونية العامة. المعلومات المقدمة لا تشكل استشارة قانونية رسمية ولا تحل محل استشارة محامٍ مؤهل. يُنصح بالتشاور مع محامٍ مختص للحصول على مشورة قانونية دقيقة.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('فهمت'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تسجيل الخروج'),
          content: Text('هل أنت متأكد من تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                
                // Perform logout
                final result = await _authService.logout();
                
                if (result.success) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.loginScreen,
                    (route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result.message ?? 'حدث خطأ أثناء تسجيل الخروج'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: Text('تسجيل الخروج'),
            ),
          ],
        ),
      ),
    );
  }

  void _openExternalLink(String type) {
    String message = '';
    switch (type) {
      case 'terms':
        message = 'فتح شروط الخدمة...';
        break;
      case 'privacy':
        message = 'فتح سياسة الخصوصية...';
        break;
      case 'help':
        message = 'فتح مركز المساعدة...';
        break;
      case 'contact':
        message = 'فتح صفحة التواصل...';
        break;
      case 'rate':
        message = 'فتح متجر التطبيقات...';
        break;
      case 'subscription':
        message = 'فتح إدارة الاشتراك...';
        break;
      default:
        message = 'فتح الرابط...';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
