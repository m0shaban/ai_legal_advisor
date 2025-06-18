-- إنشاء جدول ملفات المستخدمين في Supabase
-- يجب تشغيل هذا في Supabase SQL Editor

-- إنشاء جدول user_profiles
CREATE TABLE IF NOT EXISTS user_profiles (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    avatar TEXT,
    is_pro BOOLEAN DEFAULT FALSE,
    is_admin BOOLEAN DEFAULT FALSE,
    free_queries_used INTEGER DEFAULT 0,
    max_free_queries INTEGER DEFAULT 5,
    subscription_status VARCHAR(50) DEFAULT 'free',
    subscription_expiry TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- إنشاء index لتحسين الأداء
CREATE INDEX IF NOT EXISTS idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_profiles_subscription ON user_profiles(subscription_status);

-- إنشاء trigger لتحديث updated_at تلقائياً
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- إنشاء جدول محادثات الذكاء الاصطناعي
CREATE TABLE IF NOT EXISTS ai_conversations (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    title VARCHAR(500) NOT NULL,
    messages JSONB NOT NULL DEFAULT '[]',
    ai_provider VARCHAR(50) DEFAULT 'nvidia',
    total_tokens INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- إنشاء index للمحادثات
CREATE INDEX IF NOT EXISTS idx_ai_conversations_user_id ON ai_conversations(user_id);
CREATE INDEX IF NOT EXISTS idx_ai_conversations_created_at ON ai_conversations(created_at DESC);

-- إنشاء trigger للمحادثات
CREATE TRIGGER update_ai_conversations_updated_at
    BEFORE UPDATE ON ai_conversations
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- إنشاء جدول استخدام الاستعلامات
CREATE TABLE IF NOT EXISTS user_query_usage (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    query_type VARCHAR(50) NOT NULL,
    ai_provider VARCHAR(50) NOT NULL,
    tokens_used INTEGER DEFAULT 0,
    success BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- إنشاء index لاستخدام الاستعلامات
CREATE INDEX IF NOT EXISTS idx_query_usage_user_id ON user_query_usage(user_id);
CREATE INDEX IF NOT EXISTS idx_query_usage_date ON user_query_usage(created_at DESC);

-- إعداد Row Level Security (RLS)
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_query_usage ENABLE ROW LEVEL SECURITY;

-- سياسة الأمان للمستخدمين - يمكن للمستخدم رؤية بياناته فقط
CREATE POLICY "Users can view their own profile" ON user_profiles
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own profile" ON user_profiles
    FOR UPDATE USING (auth.uid() = user_id);

-- سياسة المحادثات
CREATE POLICY "Users can view their own conversations" ON ai_conversations
    FOR ALL USING (auth.uid() = user_id);

-- سياسة استخدام الاستعلامات
CREATE POLICY "Users can view their own usage" ON user_query_usage
    FOR ALL USING (auth.uid() = user_id);

-- دالة لإنشاء ملف مستخدم تلقائياً عند التسجيل
CREATE OR REPLACE FUNCTION create_user_profile()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO user_profiles (user_id, name, max_free_queries)
    VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'name', 'مستخدم جديد'), 5);
    RETURN NEW;
END;
$$ language 'plpgsql';

-- trigger لإنشاء ملف المستخدم تلقائياً
CREATE TRIGGER create_user_profile_trigger
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION create_user_profile();

-- إدراج بيانات المدير (اختياري)
INSERT INTO user_profiles (
    user_id, 
    name, 
    phone, 
    is_pro, 
    is_admin, 
    max_free_queries, 
    subscription_status
) VALUES (
    '00000000-0000-0000-0000-000000000001'::UUID, 
    'المدير العام', 
    '+201000000000', 
    TRUE, 
    TRUE, 
    999999, 
    'premium'
) ON CONFLICT (user_id) DO NOTHING;
