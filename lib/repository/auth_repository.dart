import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final _supabase = Supabase.instance.client;

  Future<AuthResponse> login(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp(String email, String password, String username) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<void> deleteAccount() async {
    final userId = _supabase.auth.currentUser?.id;

    if (userId != null) {
      await _supabase.from('profiles').delete().eq('id', userId);
      await _supabase.auth.signOut();
    }
  }

  Future<Map<String, dynamic>?> getProfileById(String userId) async {
    return await _supabase
        .from('profiles')
        .select('id, username, email')
        .eq('id', userId)
        .maybeSingle();
  }
}
