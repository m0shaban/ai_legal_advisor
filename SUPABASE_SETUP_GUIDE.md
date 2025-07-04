# 🚀 خطوات تهيئة قاعدة البيانات في Supabase

## ✅ تم تحديث الإعدادات بنجاح!

### 📊 ما تم تحديثه:
- ✅ **مفاتيح Supabase** محدثة في `.env`
- ✅ **إعدادات Firebase** محدثة في `firebase_options.dart`
- ✅ **Package name** محدث ليتطابق مع Firebase: `com.robovai.ailegaladvisor`
- ✅ **SQL Script** جاهز لإنشاء قاعدة البيانات

---

## 🗄️ تشغيل SQL Script في Supabase

### الخطوة 1: افتح Supabase Dashboard
1. اذهب إلى [supabase.com](https://supabase.com/dashboard)
2. سجل دخولك إلى حسابك
3. اختر مشروع `yutcilbkwnccfewbdezd`

### الخطوة 2: افتح SQL Editor
1. من القائمة الجانبية، اختر **SQL Editor**
2. انقر على **New query**

### الخطوة 3: تشغيل الـ Script
1. انسخ محتوى ملف `supabase_database_setup.sql`
2. الصقه في SQL Editor
3. انقر على **Run** أو اضغط `Ctrl+Enter`

### الخطوة 4: التحقق من النجاح
إذا تم تشغيل الـ Script بنجاح، ستحصل على رسالة:
```
تم إنشاء قاعدة بيانات AI Legal Advisor بنجاح! 🎉
```

---

## 📋 الجداول التي سيتم إنشاؤها:

1. **users** - معلومات المستخدمين والاشتراكات
2. **chat_conversations** - المحادثات القانونية
3. **chat_messages** - الرسائل والردود
4. **document_analyses** - تحليل الوثائق القانونية
5. **subscriptions** - تفاصيل الاشتراكات والمدفوعات
6. **usage_analytics** - إحصائيات الاستخدام
7. **feedback** - تقييمات وملاحظات المستخدمين

---

## 🔒 ميزات الأمان المدمجة:

- ✅ **Row Level Security (RLS)** مفعل على جميع الجداول
- ✅ **سياسات أمان** تضمن أن كل مستخدم يرى بياناته فقط
- ✅ **Indexes محسنة** للأداء السريع
- ✅ **Triggers تلقائية** لتحديث الطوابع الزمنية

---

## 🧪 اختبار الاتصال

بعد تشغيل الـ Script، يمكنك اختبار التطبيق:

```bash
# تشغيل التطبيق على المحاكي
flutter run --debug

# أو على المتصفح
flutter run -d chrome
```

---

## 📝 ملاحظات مهمة:

1. **لا تشارك مفاتيح service_role** - هي للاستخدام الداخلي فقط
2. **استخدم anon key** في التطبيق للمستخدمين العاديين
3. **RLS مفعل** - لن يتمكن المستخدمون من رؤية بيانات بعضهم البعض
4. **قم بعمل backup دوري** لقاعدة البيانات

---

## 🔧 في حالة وجود مشاكل:

### خطأ في الصلاحيات:
```sql
-- تأكد من تفعيل RLS
ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;
```

### خطأ في UUID:
```sql
-- تأكد من تفعيل extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

### اختبار الاتصال:
```sql
-- اختبار بسيط
SELECT COUNT(*) FROM users;
```

---

## 🎉 بعد النجاح:

التطبيق الآن متصل بقاعدة بيانات حقيقية! يمكنك:
- ✅ تسجيل مستخدمين جدد
- ✅ إنشاء محادثات قانونية
- ✅ حفظ الرسائل والردود
- ✅ تحليل الوثائق القانونية
- ✅ تتبع الاشتراكات
- ✅ مراقبة الإحصائيات

**التطبيق جاهز للاستخدام الحقيقي! 🚀**
