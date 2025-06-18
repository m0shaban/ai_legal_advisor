# 🔧 دليل إصلاح مشكلة قاعدة البيانات

## ❓ المشكلة
المستخدمين الجدد لا يظهرون في قاعدة بيانات Supabase عند التسجيل.

## 🔍 خطوات التشخيص

### 1. فحص إعدادات Supabase
تأكد من أن ملف `.env` يحتوي على البيانات الصحيحة:
```env
SUPABASE_URL=https://yutcilbkwnccfewbdezd.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 2. تنفيذ SQL Scripts
في Supabase Dashboard → SQL Editor، نفذ الملفات التالية بالترتيب:
1. `database_setup_users.sql` - إنشاء الجداول
2. `database_check.sql` - فحص الإعداد

### 3. فحص Logs التطبيق
عند تشغيل التطبيق، ابحث عن هذه الرسائل في Debug Console:
- `✅ Database service initialized successfully`
- `🔍 Checking database availability: true`
- `📡 Attempting Supabase registration for: [email]`
- `✅ User created in Supabase: [user_id]`

## 🛠️ الحلول المحتملة

### الحل 1: فحص Row Level Security (RLS)
```sql
-- في Supabase SQL Editor
-- تعطيل RLS مؤقتاً للاختبار
ALTER TABLE user_profiles DISABLE ROW LEVEL SECURITY;

-- إعادة تفعيله بعد الاختبار
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
```

### الحل 2: إضافة سياسة للتسجيل
```sql
-- السماح بإنشاء ملفات جديدة
CREATE POLICY "Allow user profile creation" ON user_profiles
    FOR INSERT WITH CHECK (true);
```

### الحل 3: فحص Auth Settings
في Supabase Dashboard → Authentication → Settings:
- تأكد من تفعيل "Enable email confirmations"
- تأكد من إعداد "Site URL" بشكل صحيح

### الحل 4: استخدام Service Role Key
للاختبار فقط، يمكن استخدام Service Role Key:
```dart
// في database_service.dart (مؤقتاً)
final String? _supabaseServiceKey = dotenv.env['SUPABASE_SERVICE_ROLE_KEY'];
```

## 🧪 اختبار سريع

### طريقة 1: اختبار يدوي
1. شغل التطبيق
2. سجل حساب جديد بإيميل وهمي
3. افحص Debug Console للرسائل
4. افحص Supabase Dashboard → Authentication → Users

### طريقة 2: SQL مباشر
```sql
-- إنشاء مستخدم مباشرة في قاعدة البيانات
INSERT INTO user_profiles (
    user_id, 
    name, 
    phone, 
    avatar,
    is_pro,
    max_free_queries,
    subscription_status
) VALUES (
    gen_random_uuid(),
    'مستخدم تجريبي',
    '+201234567890',
    'assets/images/profile.png',
    false,
    5,
    'free'
);
```

## 📞 معلومات إضافية

### Debug Commands للمطور:
```dart
// إضافة في AuthService للتشخيص
debugPrint('Supabase URL: ${_db._supabaseUrl}');
debugPrint('Database Available: ${_db.isAvailable}');
debugPrint('Auth State: ${_db.client.auth.currentUser}');
```

### فحص Supabase Logs:
1. Supabase Dashboard → Logs
2. ابحث عن API calls للجداول
3. فحص أي أخطاء في realtime

## ✅ النتيجة المتوقعة
بعد تطبيق الحلول:
- المستخدمين الجدد يظهرون في `auth.users`
- ملفات المستخدمين تُنشأ في `user_profiles`
- Debug console يظهر رسائل النجاح
- لا توجد أخطاء في Supabase Logs

---

**💡 نصيحة:** ابدأ بالحل الأبسط (فحص RLS) ثم انتقل للحلول الأكثر تعقيداً.
