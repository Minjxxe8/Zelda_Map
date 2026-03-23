import 'package:supabase_flutter/supabase_flutter.dart';

class GroupRepository {
  final _supabase = Supabase.instance.client;

  Future<void> createGroup(String name, String userId) async {
    final res = await _supabase.from('groups').insert({'name': name, 'created_by': userId}).select().single();
    await joinGroup(res['id'], userId);
  }

  Future<void> joinGroup(String groupId, String userId) async {
    await _supabase.from('group_members').insert({'group_id': groupId, 'profile_id': userId});
  }

  Future<bool> canPostToday(String userId, String groupId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];

    final res = await _supabase
        .from('photos')
        .select()
        .eq('user_id', userId)
        .eq('group_id', groupId)
        .gte('created_at', today);

    return (res as List).isEmpty;
  }
}