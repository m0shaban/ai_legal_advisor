# حلول المشاكل الشائعة عند تشغيل التطبيق على الهاتف

## 🔧 المشاكل الأساسية

### 1. التطبيق لا يفتح أو يتوقف فوراً

**الأسباب المحتملة:**
- مشكلة في تهيئة Firebase
- مشكلة في ملف `.env`
- مشكلة في الصلاحيات

**الحلول:**
```bash
# تحقق من السجلات
flutter logs

# أعد بناء التطبيق
flutter clean
flutter pub get
flutter build apk --debug

# جرب التشغيل المباشر مع verbose
flutter run --verbose
```

### 2. خطأ "Cleartext HTTP traffic not permitted"

**الحل:** تحديث `android/app/src/main/AndroidManifest.xml`
```xml
<application
    android:usesCleartextTraffic="true"
    android:networkSecurityConfig="@xml/network_security_config"
    ...>
```

**أنشئ ملف:** `android/app/src/main/res/xml/network_security_config.xml`
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">localhost</domain>
        <domain includeSubdomains="true">10.0.2.2</domain>
        <domain includeSubdomains="true">yutcilbkwnccfewbdezd.supabase.co</domain>
    </domain-config>
</network-security-config>
```

### 3. مشكلة "Firebase initialization failed"

**تحقق من:**
1. وجود ملف `google-services.json` في `android/app/`
2. صحة `lib/firebase_options.dart`
3. SHA-1 fingerprint في Firebase Console

**احصل على SHA-1:**
```bash
cd android
./gradlew signingReport
```

### 4. مشكلة "Supabase connection failed"

**تحقق من ملف `.env`:**
```env
SUPABASE_URL=https://yutcilbkwnccfewbdezd.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**تأكد من:**
- URL صحيح وبدون / في النهاية
- Anon Key صحيح ولم ينته صلاحيته
- RLS Policies مفعلة في Supabase

### 5. NVIDIA API لا يعمل

**تحقق من:**
```env
NVIDIA_API_KEY=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
```

**اختبر API مباشرة:**
```bash
curl -X POST "https://integrate.api.nvidia.com/v1/chat/completions" \
-H "Authorization: Bearer nvapi-YOUR_KEY" \
-H "Content-Type: application/json" \
-d '{"model":"meta/llama-3.1-8b-instruct","messages":[{"role":"user","content":"Hello"}]}'
```

## 🚀 أوامر الإصلاح السريع

### تنظيف شامل
```bash
flutter clean
rm -rf ~/.gradle/caches
cd android && ./gradlew clean && cd ..
flutter pub get
```

### إعادة إنشاء المشروع
```bash
flutter create --org com.example --project-name ai_legal_advisor .
# ثم أعد نسخ ملفاتك
```

### تحديث Gradle
```bash
cd android
./gradlew wrapper --gradle-version 8.10
```

## 📱 اختبار الخدمات

### 1. اختبار مباشر من التطبيق
- اضغط مطولاً على رمز الإعدادات في شاشة البداية
- أو اضغط على رمز التبليغ عن الأخطاء في الشاشة الرئيسية
- ستفتح شاشة اختبار الخدمات

### 2. اختبار من السجلات
```bash
flutter logs | grep -E "(Supabase|Firebase|NVIDIA|Error)"
```

### 3. اختبار الشبكة
```bash
# اختبر ping لـ Supabase
ping yutcilbkwnccfewbdezd.supabase.co

# اختبر NVIDIA API
curl -I https://integrate.api.nvidia.com/
```

## 🔍 تشخيص متقدم

### عرض جميع السجلات
```bash
# Android logs
adb logcat | grep flutter

# Flutter logs مع التفاصيل
flutter logs --verbose
```

### فحص ملفات APK
```bash
# عرض محتويات APK
unzip -l build/app/outputs/flutter-apk/app-debug.apk | grep -E "(assets|\.env)"
```

### اختبار البناء على منصات مختلفة
```bash
# Web (للتأكد من الكود)
flutter run -d chrome

# Windows (إذا كان متاحاً)
flutter run -d windows
```

## 📋 قائمة التحقق

- [ ] الهاتف في Developer Mode
- [ ] USB Debugging مفعل
- [ ] الكابل يعمل بشكل صحيح
- [ ] `flutter devices` يُظهر الهاتف
- [ ] ملف `.env` موجود ويحتوي على المفاتيح
- [ ] `google-services.json` موجود
- [ ] `firebase_options.dart` محدث
- [ ] الإنترنت يعمل على الهاتف
- [ ] لا توجد تطبيقات أخرى تستخدم نفس المنافذ

## 🆘 إذا لم تعمل الحلول

1. **أرسل السجلات:**
```bash
flutter logs > logs.txt
```

2. **معلومات النظام:**
```bash
flutter doctor -v > doctor.txt
```

3. **معلومات البناء:**
```bash
flutter build apk --debug --verbose > build_log.txt 2>&1
```

4. **اختبر على جهاز Android مختلف** (إن أمكن)

5. **استخدم المحاكي للاختبار الأولي:**
```bash
flutter emulators
flutter emulators --launch <emulator_id>
flutter run
```

## 💡 نصائح الأداء

- استخدم **Profile mode** لاختبار الأداء: `flutter run --profile`
- راقب الذاكرة: Flutter Inspector في VS Code
- اختبر على شبكات مختلفة (WiFi, 4G, 3G)
- اختبر في حالات مختلفة (background, foreground, startup)
