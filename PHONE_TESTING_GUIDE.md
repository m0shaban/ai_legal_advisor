# دليل اختبار التطبيق على الهاتف

## خطوات التحضير

### 1. تفعيل وضع المطور في الهاتف
1. اذهب إلى **الإعدادات** > **حول الهاتف**
2. اضغط على **رقم البناء** 7 مرات متتالية
3. ستظهر رسالة "أصبحت الآن مطوراً"

### 2. تفعيل تصحيح USB
1. اذهب إلى **الإعدادات** > **خيارات المطور**
2. فعّل **تصحيح USB** (USB Debugging)

### 3. ربط الهاتف بالكمبيوتر
1. استخدم كابل USB أصلي
2. اختر **نقل الملفات** عند ظهور الخيارات
3. وافق على **السماح بتصحيح USB** إذا ظهر طلب

## أوامر الاختبار

### تحقق من الأجهزة المتصلة
```bash
flutter devices
```

### تشغيل التطبيق على الهاتف (التطوير)
```bash
flutter run
```

### تشغيل التطبيق مع معلومات مفصلة
```bash
flutter run --verbose
```

### بناء وتثبيت APK للتطوير
```bash
flutter build apk --debug
flutter install
```

### عرض السجلات المباشرة
```bash
flutter logs
```

## اختبار الخدمات

### الوصول لشاشة اختبار الخدمات
1. **من شاشة البداية**: اضغط لفترة طويلة على الرمز في الزاوية اليمنى العلوية
2. **من الشاشة الرئيسية**: اضغط على رمز التبليغ عن الأخطاء بجانب الإعدادات

### ما يجب اختباره
- ✅ **اتصال Supabase**: يجب أن يظهر "Available"
- ✅ **NVIDIA AI**: يجب أن يعيد استجابة نصية
- ✅ **Firebase Analytics**: يجب أن يسجل الأحداث
- ✅ **متغيرات البيئة**: يجب أن تظهر المفاتيح الصحيحة

## استكشاف الأخطاء

### إذا لم يتعرف على الهاتف
```bash
adb devices
adb kill-server
adb start-server
flutter devices
```

### إذا ظهرت أخطاء البناء
```bash
flutter clean
flutter pub get
flutter build apk --debug
```

### إذا لم تعمل الخدمات
1. تحقق من ملف `.env` - يجب أن تكون المفاتيح صحيحة
2. تحقق من الاتصال بالإنترنت
3. راجع السجلات في شاشة اختبار الخدمات

## مسارات الملفات المهمة

- **APK للتطوير**: `build/app/outputs/apk/debug/app-debug.apk`
- **APK للإنتاج**: `build/app/outputs/apk/release/app-release.apk`
- **ملف البيئة**: `.env`
- **شاشة اختبار الخدمات**: `lib/presentation/service_test/service_test_screen.dart`

## إعدادات Firebase

إذا كانت هناك مشاكل مع Firebase:
1. تحقق من `android/app/google-services.json`
2. تحقق من `lib/firebase_options.dart`
3. تأكد من إضافة SHA-1 fingerprint في Firebase Console

## إعدادات Supabase

إذا كانت هناك مشاكل مع Supabase:
1. تحقق من URL و Anon Key في `.env`
2. تأكد من إنشاء الجداول باستخدام `supabase_database_setup.sql`
3. تحقق من RLS Policies في Supabase Dashboard

## نصائح الأداء

- استخدم **Debug Mode** للتطوير والاختبار
- استخدم **Release Mode** للإنتاج النهائي
- راقب استهلاك الذاكرة والمعالج
- اختبر على أجهزة مختلفة (أندرويد مختلفة)

## الأخطاء الشائعة

### خطأ: "Cleartext HTTP traffic not permitted"
- تأكد من استخدام HTTPS في جميع API calls
- تحقق من `android/app/src/main/AndroidManifest.xml`

### خطأ: "Firebase initialization failed"
- تحقق من `google-services.json`
- تأكد من أن SHA-1 مضاف في Firebase Console

### خطأ: "Supabase connection failed"
- تحقق من صحة URL و API Key
- تأكد من الاتصال بالإنترنت
