-- استعلام للتأكد من جداول قاعدة البيانات
-- نفذ هذا في Supabase SQL Editor للتأكد من الإعداد

-- 1. فحص الجداول الموجودة
SELECT 
    table_name 
FROM 
    information_schema.tables 
WHERE 
    table_schema = 'public' 
    AND table_name IN ('user_profiles', 'ai_conversations', 'user_query_usage');

-- 2. فحص هيكل جدول user_profiles
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM 
    information_schema.columns 
WHERE 
    table_schema = 'public' 
    AND table_name = 'user_profiles'
ORDER BY 
    ordinal_position;

-- 3. فحص المستخدمين الموجودين
SELECT 
    COUNT(*) as total_users
FROM 
    auth.users;

-- 4. فحص ملفات المستخدمين
SELECT 
    COUNT(*) as total_profiles,
    subscription_status,
    is_pro
FROM 
    user_profiles
GROUP BY 
    subscription_status, is_pro;

-- 5. فحص سياسات الأمان (RLS)
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM 
    pg_policies 
WHERE 
    tablename IN ('user_profiles', 'ai_conversations', 'user_query_usage');

-- 6. إنشاء مستخدم تجريبي (اختياري)
-- هذا سيساعد في الاختبار
/*
INSERT INTO auth.users (
    instance_id,
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    recovery_sent_at,
    last_sign_in_at,
    raw_app_meta_data,
    raw_user_meta_data,
    created_at,
    updated_at,
    confirmation_token,
    email_change,
    email_change_token_new,
    recovery_token
) VALUES (
    '00000000-0000-0000-0000-000000000000'::UUID,
    uuid_generate_v4(),
    'authenticated',
    'authenticated',
    'test@example.com',
    '$2a$10$dummy.hash.for.testing.purposes.only',
    NOW(),
    NULL,
    NULL,
    '{"provider":"email","providers":["email"]}',
    '{"name":"مستخدم تجريبي"}',
    NOW(),
    NOW(),
    '',
    '',
    '',
    ''
);
*/
