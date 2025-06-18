# دليل التشغيل السريع - تطبيق المستشار القانوني الذكي

## 🚀 بناء وتشغيل التطبيق

### المتطلبات المسبقة
- Flutter 3.32.4 أو أحدث
- Android Studio مع Android SDK
- Dart 3.6.0 أو أحدث

### إعداد البيئة
1. **نسخ ملف البيئة**:
   ```bash
   cp .env.example .env
   ```

2. **تحديث متغيرات البيئة في `.env`**:
   ```env
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key
   NVIDIA_API_KEY=your-nvidia-api-key
   OPENAI_API_KEY=your-openai-fallback-key
   ```

### أوامر التطوير

#### تنظيف وتجهيز المشروع
```bash
flutter clean
flutter pub get
```

#### تشغيل التطبيق للتطوير
```bash
# تشغيل على المحاكي/الجهاز
flutter run

# تشغيل على الويب
flutter run -d chrome

# تشغيل في وضع التطوير مع Hot Reload
flutter run --debug
```

#### بناء التطبيق للإنتاج
```bash
# بناء APK للإنتاج
flutter build apk --release

# بناء App Bundle (موصى به لـ Play Store)
flutter build appbundle --release

# بناء للويب
flutter build web --release
```

## 🔧 إعداد الخدمات الخارجية

### Supabase (قاعدة البيانات)
1. إنشاء مشروع جديد في [Supabase](https://supabase.com)
2. تنفيذ SQL Script من `supabase_database_setup.sql`
3. نسخ URL و Anon Key إلى `.env`

### Firebase (Analytics & Crashlytics)
1. إنشاء مشروع في [Firebase Console](https://console.firebase.google.com)
2. إضافة تطبيق Android بـ package name: `com.robovai.ailegaladvisor`
3. تحميل `google-services.json` ووضعه في `android/app/`
4. تفعيل Analytics و Crashlytics

### NVIDIA API (الذكاء الاصطناعي)
1. التسجيل في [NVIDIA NGC](https://ngc.nvidia.com)
2. إنشاء API Key
3. تحديث `NVIDIA_API_KEY` في `.env`

## 🛠️ أوامر مفيدة للتطوير

### تحليل الكود
```bash
# فحص جودة الكود
flutter analyze

# تنسيق الكود
dart format .

# اختبار التطبيق
flutter test
```

### إدارة التبعيات
```bash
# تحديث التبعيات
flutter pub upgrade

# فحص التبعيات القديمة
flutter pub outdated

# إصلاح مشاكل التبعيات
flutter pub deps
```

### استكشاف الأخطاء
```bash
# تشغيل مع تفاصيل أكثر
flutter run --verbose

# مراقبة الـ logs
flutter logs

# فحص الأجهزة المتصلة
flutter devices

# فحص حالة Flutter
flutter doctor -v
```

## 📱 اختبار التطبيق

### الوظائف الأساسية للاختبار
- [ ] تسجيل الدخول/إنشاء حساب
- [ ] تحميل وتحليل المستندات القانونية
- [ ] الدردشة مع الذكاء الاصطناعي
- [ ] عرض تاريخ المحادثات
- [ ] إعدادات التطبيق
- [ ] وضع الـ Dark/Light Mode

### اختبار الأداء
```bash
# قياس أداء التطبيق
flutter run --profile

# تتبع استخدام الذاكرة
flutter run --observatory-port=8888
```

## 🚢 النشر والتوزيع

### إعداد التوقيع
1. إنشاء مفتاح التوقيع:
   ```bash
   keytool -genkey -v -keystore release-key.keystore -alias key -keyalg RSA -keysize 2048 -validity 10000
   ```

2. إعداد ملف `android/key.properties`:
   ```properties
   storePassword=your-store-password
   keyPassword=your-key-password
   keyAlias=key
   storeFile=../release-key.keystore
   ```

### النشر على Google Play Store
1. بناء App Bundle:
   ```bash
   flutter build appbundle --release
   ```

2. رفع الملف إلى Play Console

### النشر على الويب
1. بناء للويب:
   ```bash
   flutter build web --release
   ```

2. رفع محتويات مجلد `build/web/` إلى الخادم

## 🔍 مراقبة التطبيق

### Firebase Analytics
- راقب استخدام التطبيق في Firebase Console
- اعرض إحصائيات المستخدمين والجلسات

### Crashlytics
- راقب الأخطاء والتحطم في Firebase Console
- راجع stack traces للمشاكل

### Supabase
- راقب استخدام قاعدة البيانات في Supabase Dashboard
- اعرض logs للـ API calls

## 📞 الدعم والمساعدة

### الوثائق المفيدة
- [Flutter Documentation](https://docs.flutter.dev)
- [Supabase Documentation](https://supabase.com/docs)
- [Firebase Documentation](https://firebase.google.com/docs)

### حل المشاكل الشائعة
- **مشكلة في البناء**: تشغيل `flutter clean && flutter pub get`
- **مشكلة في Gradle**: التأكد من Java 11+ وAndroid SDK مُحدث
- **مشكلة في Firebase**: التأكد من `google-services.json` في المكان الصحيح

---

**تم إعداد هذا الدليل لمساعدة المطورين على تشغيل وصيانة التطبيق بسهولة.**
