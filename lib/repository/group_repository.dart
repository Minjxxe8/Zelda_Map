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

  Future<List<Map<String, dynamic>>> getAvailableGroupsForToday(String userId) async {
    // 1. On récupère tous les groupes de l'utilisateur
    final myGroups = await getMyGroups(userId);

    List<Map<String, dynamic>> availableGroups = [];

    for (var group in myGroups) {
      final canPost = await canPostInGroup(userId, group['id']);
      if (canPost) {
        availableGroups.add(group);
      }
    }

    return availableGroups;
  }

  Future<bool> canPostInGroup(String userId, String groupId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).toIso8601String();

    final response = await _supabase
        .from('photos')
        .select()
        .eq('user_id', userId)
        .eq('group_id', groupId)
        .gte('created_at', startOfDay);

    return (response as List).isEmpty;
  }

  Future<List<Map<String, dynamic>>> getMyGroups(String userId) async {
    final response = await _supabase
        .from('group_members')
        .select('groups(*)')
        .eq('profile_id', userId);

    return List<Map<String, dynamic>>.from(response.map((e) => e['groups']));
  }

  Future<bool> canVoteToday(String userId, String groupId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).toIso8601String();

    final res = await _supabase
        .from('group_votes')
        .select()
        .eq('voter_id', userId)
        .eq('group_id', groupId)
        .gte('created_at', startOfDay);

    return (res as List).isEmpty;
  }

  Future<void> voteForPhoto(String userId, String groupId, String photoId) async {
    await _supabase.from('group_votes').insert({
      'voter_id': userId,
      'group_id': groupId,
      'photo_id': photoId,
    });
  }
}
