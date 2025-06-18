# AI Legal Advisor - مستشار قانوني ذكي

تطبيق Flutter متطور للاستشارات القانونية الذكية مع نظام المصادقة والاشتراك المتكامل.

## الميزات الجديدة المضافة

### 🔐 نظام المصادقة (Authentication)
- **شاشة تسجيل الدخول** مع تسجيل اجتماعي وتذكر بيانات الدخول
- **شاشة التسجيل** مع التحقق من صحة البيانات
- **شاشة استعادة كلمة المرور** مع إرسال رابط الاستعادة
- **خدمة المصادقة المتكاملة** مع التخزين المحلي وإدارة حالة المستخدم

### 💎 نظام الاشتراك والدفع (Subscription & Paywall)
- **شاشة خطط الاشتراك** مع عرض الخطط والمزايا
- **شاشة الدفع المتقدمة** مع دعم طرق دفع متعددة
- **خدمة الاشتراك** مع إدارة الخطط والدفع
- **تكامل مع حدود الاستفسارات** للمستخدمين المجانيين

### 🎨 الواجهات والويدجتات
- **ويدجتات مصادقة**: AuthHeaderWidget, SocialLoginWidget
- **ويدجتات اشتراك**: PlanCardWidget, SubscriptionBenefitsWidget
- **ويدجتات دفع**: PaymentMethodCard, OrderSummaryCard
- **تصميم متجاوب** يدعم اللغة العربية

## بنية المشروع

```
lib/
├── main.dart                           # نقطة دخول التطبيق
├── routes/
│   └── app_routes.dart                 # نظام التوجيه المحدث
├── services/
│   ├── auth_service.dart              # خدمة المصادقة
│   └── subscription_service.dart      # خدمة الاشتراك
├── presentation/
│   ├── authentication/                # شاشات المصادقة
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── forgot_password_screen.dart
│   │   └── widgets/
│   │       ├── auth_header_widget.dart
│   │       └── social_login_widget.dart
│   ├── subscription/                  # شاشات الاشتراك
│   │   ├── subscription_plans_screen.dart
│   │   ├── payment_screen.dart
│   │   └── widgets/
│   │       ├── plan_card_widget.dart
│   │       ├── subscription_benefits_widget.dart
│   │       ├── payment_method_card.dart
│   │       └── order_summary_card.dart
│   ├── splash_screen/                 # شاشة البداية (محدثة)
│   ├── chat_home_screen/              # الشاشة الرئيسية (محدثة)
│   └── user_profile_settings/         # إعدادات المستخدم (محدثة)
└── theme/
    └── app_theme.dart                 # نظام الألوان المحدث
```

## المسارات الجديدة

```dart
// مسارات المصادقة
AppRoutes.loginScreen               // شاشة تسجيل الدخول
AppRoutes.registerScreen            // شاشة التسجيل
AppRoutes.forgotPasswordScreen      // شاشة استعادة كلمة المرور

// مسارات الاشتراك والدفع
AppRoutes.subscriptionPlansScreen   // شاشة خطط الاشتراك
AppRoutes.paymentScreen            // شاشة الدفع
```

## الخدمات المتاحة

### AuthService
```dart
// تهيئة الخدمة
await AuthService().initialize();

// تسجيل الدخول
final result = await AuthService().login(email, password);

// التسجيل
final result = await AuthService().register(name, email, password);

// استعادة كلمة المرور
final result = await AuthService().resetPassword(email);

// تسجيل الخروج
final result = await AuthService().logout();

// التحقق من حالة الدخول
bool isLoggedIn = AuthService().isLoggedIn.value;
```

### SubscriptionService
```dart
// التحقق من الاشتراك النشط
bool hasSubscription = await SubscriptionService().hasActiveSubscription();

// الحصول على الخطط المتاحة
List<SubscriptionPlan> plans = SubscriptionService.availablePlans;

// تفعيل اشتراك
final result = await SubscriptionService().activateSubscription(planId);

// إلغاء اشتراك
final result = await SubscriptionService().cancelSubscription();

// استرداد المشتريات
final result = await SubscriptionService().restorePurchases();
```

## التدفق المحدث للتطبيق

1. **شاشة البداية (Splash)**: تتحقق من حالة المصادقة
2. **التوجيه التلقائي**:
   - إذا كانت أول مرة → Onboarding
   - إذا لم يسجل دخول → Login Screen
   - إذا سجل دخول → Chat Home Screen
3. **الشاشة الرئيسية**: تتحقق من حدود الاستفسارات وتوجه للاشتراك عند الحاجة
4. **إدارة المستخدم**: خيارات الاشتراك وتسجيل الخروج

## التشغيل

```bash
# تثبيت المكتبات
flutter pub get

# تشغيل التطبيق
flutter run

# بناء للإصدار
flutter build apk --release
```

## اللغات المدعومة

- العربية (الافتراضية)
- الإنجليزية

## طرق الدفع المدعومة

- بطاقات الائتمان (Visa, Mastercard, American Express)
- بطاقات الخصم المحلية
- فودافون كاش
- فوري

## خطط الاشتراك

### 🆓 الخطة المجانية
- 5 استفسارات يومية
- دعم أساسي
- الوصول للمكتبة الأساسية

### 💎 الخطة الشهرية ($9.99)
- استفسارات غير محدودة
- تحليل الوثائق المتقدم
- مكتبة النماذج الكاملة
- دعم أولوية

### 🔥 الخطة السنوية ($99.99)
- جميع مزايا الخطة الشهرية
- خصم 17%
- تحديثات قانونية مستمرة
- استشارات متخصصة

### ⭐ الخطة المدى الحياة ($299.99)
- جميع المزايا السابقة
- دفعة واحدة
- دعم مدى الحياة
- ميزات حصرية

## الأمان والخصوصية

- تشفير البيانات محلياً
- حماية معلومات الدفع
- عدم تخزين بيانات حساسة
- التوافق مع معايير الأمان

## الدعم الفني

للحصول على المساعدة أو الإبلاغ عن مشاكل، يرجى التواصل من خلال:
- البريد الإلكتروني: support@ailegaladvisor.com
- الموقع الإلكتروني: www.ailegaladvisor.com

---

تم تطوير هذا التطبيق باستخدام Flutter مع التركيز على تجربة المستخدم العربي والميزات المتقدمة للاستشارات القانونية الذكية.
