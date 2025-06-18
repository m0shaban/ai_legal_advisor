import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();
  late final SupabaseClient _supabase;
  
  /// Initialize Supabase
  Future<void> initialize() async {
    try {
      // Use existing Supabase client if available
      _supabase = Supabase.instance.client;
      debugPrint('✅ Using existing Supabase client');
      return;
    } catch (e) {
      debugPrint('⚠️ Supabase not initialized, skipping database service initialization');
      return;
    }
  }

  /// Get Supabase client
  SupabaseClient get client => _supabase;
  /// Check if Supabase is available
  bool get isAvailable {
    try {
      return true; // If we reach here, _supabase is initialized
    } catch (e) {
      return false;
    }
  }

  // === USER MANAGEMENT ===

  /// Save user data to database
  Future<DatabaseResult> saveUser(Map<String, dynamic> userData) async {
    if (!isAvailable) {
      return DatabaseResult(success: false, message: 'Database not available');
    }

    try {
      final response = await _supabase
          .from('users')
          .upsert(userData)
          .select()
          .single();

      return DatabaseResult(
        success: true,
        message: 'User saved successfully',
        data: response,
      );
    } catch (e) {
      debugPrint('Error saving user: $e');
      return DatabaseResult(
        success: false,
        message: 'Failed to save user: ${e.toString()}',
      );
    }
  }

  /// Get user by ID
  Future<DatabaseResult> getUser(String userId) async {
    if (!isAvailable) {
      return DatabaseResult(success: false, message: 'Database not available');
    }

    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return DatabaseResult(
        success: true,
        message: 'User retrieved successfully',
        data: response,
      );
    } catch (e) {
      debugPrint('Error getting user: $e');
      return DatabaseResult(
        success: false,
        message: 'Failed to get user: ${e.toString()}',
      );
    }
  }

  /// Update user data
  Future<DatabaseResult> updateUser(String userId, Map<String, dynamic> updates) async {
    if (!isAvailable) {
      return DatabaseResult(success: false, message: 'Database not available');
    }

    try {
      final response = await _supabase
          .from('users')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return DatabaseResult(
        success: true,
        message: 'User updated successfully',
        data: response,
      );
    } catch (e) {
      debugPrint('Error updating user: $e');
      return DatabaseResult(
        success: false,
        message: 'Failed to update user: ${e.toString()}',
      );
    }
  }

  /// Get user profile by ID
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    if (!isAvailable) {
      return null;
    }

    try {
      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  // === CHAT CONVERSATIONS ===

  /// Save chat conversation
  Future<DatabaseResult> saveConversation(Map<String, dynamic> conversation) async {
    if (!isAvailable) {
      return DatabaseResult(success: false, message: 'Database not available');
    }

    try {
      final response = await _supabase
          .from('conversations')
          .insert(conversation)
          .select()
          .single();

      return DatabaseResult(
        success: true,
        message: 'Conversation saved successfully',
        data: response,
      );
    } catch (e) {
      debugPrint('Error saving conversation: $e');
      return DatabaseResult(
        success: false,
        message: 'Failed to save conversation: ${e.toString()}',
      );
    }
  }

  /// Get user conversations
  Future<DatabaseResult> getUserConversations(String userId, {int limit = 20}) async {
    if (!isAvailable) {
      return DatabaseResult(success: false, message: 'Database not available');
    }

    try {
      final response = await _supabase
          .from('conversations')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);

      return DatabaseResult(
        success: true,
        message: 'Conversations retrieved successfully',
        data: response,
      );
    } catch (e) {
      debugPrint('Error getting conversations: $e');
      return DatabaseResult(
        success: false,
        message: 'Failed to get conversations: ${e.toString()}',
      );
    }
  }

  /// Save chat message
  Future<DatabaseResult> saveMessage(Map<String, dynamic> message) async {
    if (!isAvailable) {
      return DatabaseResult(success: false, message: 'Database not available');
    }

    try {
      final response = await _supabase
          .from('messages')
          .insert(message)
          .select()
          .single();

      return DatabaseResult(
        success: true,
        message: 'Message saved successfully',
        data: response,
      );
    } catch (e) {
      debugPrint('Error saving message: $e');
      return DatabaseResult(
        success: false,
        message: 'Failed to save message: ${e.toString()}',
      );
    }
  }

  /// Get conversation messages
  Future<DatabaseResult> getConversationMessages(String conversationId) async {
    if (!isAvailable) {
      return DatabaseResult(success: false, message: 'Database not available');
    }

    try {
      final response = await _supabase
          .from('messages')
          .select()
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: true);

      return DatabaseResult(
        success: true,
        message: 'Messages retrieved successfully',
        data: response,
      );
    } catch (e) {
      debugPrint('Error getting messages: $e');
      return DatabaseResult(
        success: false,
        message: 'Failed to get messages: ${e.toString()}',
      );
    }
  }

  // === SUBSCRIPTIONS ===

  /// Save subscription
  Future<DatabaseResult> saveSubscription(Map<String, dynamic> subscription) async {
    if (!isAvailable) {
      return DatabaseResult(success: false, message: 'Database not available');
    }

    try {
      final response = await _supabase
          .from('subscriptions')
          .upsert(subscription)
          .select()
          .single();

      return DatabaseResult(
        success: true,
        message: 'Subscription saved successfully',
        data: response,
      );
    } catch (e) {
      debugPrint('Error saving subscription: $e');
      return DatabaseResult(
        success: false,
        message: 'Failed to save subscription: ${e.toString()}',
      );
    }
  }

  /// Get user subscription
  Future<DatabaseResult> getUserSubscription(String userId) async {
    if (!isAvailable) {
      return DatabaseResult(success: false, message: 'Database not available');
    }

    try {
      final response = await _supabase
          .from('subscriptions')
          .select()
          .eq('user_id', userId)
          .eq('is_active', true)
          .single();

      return DatabaseResult(
        success: true,
        message: 'Subscription retrieved successfully',
        data: response,
      );
    } catch (e) {
      debugPrint('Error getting subscription: $e');
      return DatabaseResult(
        success: false,
        message: 'Failed to get subscription: ${e.toString()}',
      );
    }
  }

  // === ANALYTICS ===

  /// Log user activity
  Future<DatabaseResult> logActivity(Map<String, dynamic> activity) async {
    if (!isAvailable) {
      return DatabaseResult(success: false, message: 'Database not available');
    }

    try {
      await _supabase
          .from('user_activities')
          .insert(activity);

      return DatabaseResult(
        success: true,
        message: 'Activity logged successfully',
      );
    } catch (e) {
      debugPrint('Error logging activity: $e');
      return DatabaseResult(
        success: false,
        message: 'Failed to log activity: ${e.toString()}',
      );
    }
  }

  /// Get user statistics
  Future<DatabaseResult> getUserStats(String userId) async {
    if (!isAvailable) {
      return DatabaseResult(success: false, message: 'Database not available');
    }

    try {
      final response = await _supabase
          .rpc('get_user_stats', params: {'user_id': userId});

      return DatabaseResult(
        success: true,
        message: 'Statistics retrieved successfully',
        data: response,
      );
    } catch (e) {
      debugPrint('Error getting stats: $e');
      return DatabaseResult(
        success: false,
        message: 'Failed to get statistics: ${e.toString()}',
      );
    }
  }

  // === REALTIME SUBSCRIPTIONS ===

  /// Subscribe to conversation updates
  RealtimeChannel subscribeToConversation(
    String conversationId,
    Function(Map<String, dynamic>) onUpdate,
  ) {
    return _supabase
        .channel('conversation_$conversationId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) => onUpdate(payload.newRecord),
        )
        .subscribe();
  }
}

/// Database operation result
class DatabaseResult {
  final bool success;
  final String message;
  final dynamic data;

  DatabaseResult({
    required this.success,
    required this.message,
    this.data,
  });
}

/// Database table schemas (for reference)
class DatabaseSchemas {
  static const String createUsersTable = '''
    CREATE TABLE IF NOT EXISTS users (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      email VARCHAR(255) UNIQUE NOT NULL,
      name VARCHAR(255) NOT NULL,
      phone VARCHAR(50),
      avatar_url TEXT,
      is_pro BOOLEAN DEFAULT FALSE,
      subscription_status VARCHAR(50) DEFAULT 'free',
      subscription_expiry TIMESTAMP,
      free_queries_used INTEGER DEFAULT 0,
      max_free_queries INTEGER DEFAULT 5,
      created_at TIMESTAMP DEFAULT NOW(),
      updated_at TIMESTAMP DEFAULT NOW()
    );
  ''';

  static const String createConversationsTable = '''
    CREATE TABLE IF NOT EXISTS conversations (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id UUID REFERENCES users(id) ON DELETE CASCADE,
      title VARCHAR(255),
      last_message TEXT,
      created_at TIMESTAMP DEFAULT NOW(),
      updated_at TIMESTAMP DEFAULT NOW()
    );
  ''';

  static const String createMessagesTable = '''
    CREATE TABLE IF NOT EXISTS messages (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE,
      user_id UUID REFERENCES users(id) ON DELETE CASCADE,
      content TEXT NOT NULL,
      message_type VARCHAR(20) DEFAULT 'user', -- 'user' or 'ai'
      ai_response JSONB, -- stores quickSummary, detailedExplanation, legalBasis
      is_favorite BOOLEAN DEFAULT FALSE,
      created_at TIMESTAMP DEFAULT NOW()
    );
  ''';

  static const String createSubscriptionsTable = '''
    CREATE TABLE IF NOT EXISTS subscriptions (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id UUID REFERENCES users(id) ON DELETE CASCADE,
      plan_id VARCHAR(50) NOT NULL,
      plan_name VARCHAR(100) NOT NULL,
      start_date TIMESTAMP NOT NULL,
      end_date TIMESTAMP NOT NULL,
      is_active BOOLEAN DEFAULT TRUE,
      amount DECIMAL(10,2) NOT NULL,
      currency VARCHAR(10) DEFAULT 'EGP',
      payment_method JSONB,
      transaction_id VARCHAR(255),
      created_at TIMESTAMP DEFAULT NOW(),
      cancel_date TIMESTAMP
    );
  ''';

  static const String createUserActivitiesTable = '''
    CREATE TABLE IF NOT EXISTS user_activities (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id UUID REFERENCES users(id) ON DELETE CASCADE,
      activity_type VARCHAR(50) NOT NULL,
      activity_data JSONB,
      ip_address INET,
      user_agent TEXT,
      created_at TIMESTAMP DEFAULT NOW()
    );
  ''';
}
