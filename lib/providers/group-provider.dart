import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final allGroupsProvider = FutureProvider((ref) async {
  return await Supabase.instance.client.from('groups').select();
});

final myGroupsProvider = FutureProvider.family((ref, String userId) async {
  final res = await Supabase.instance.client
      .from('group_members')
      .select('groups(*)')
      .eq('profile_id', userId);
  return List<Map<String, dynamic>>.from(res.map((e) => e['groups']));
});

final groupPhotosProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, groupId) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('photos')
      .select('*, profiles(username), group_votes(count)')
      .eq('group_id', groupId)
      .order('created_at', ascending: false);

  List<Map<String, dynamic>> photos = List<Map<String, dynamic>>.from(response);

  photos.sort((a, b) {
    int votesA = (a['group_votes'] as List).isNotEmpty ? a['group_votes'][0]['count'] : 0;
    int votesB = (b['group_votes'] as List).isNotEmpty ? b['group_votes'][0]['count'] : 0;
    return votesB.compareTo(votesA);
  });

  return photos;
});

final groupMembersProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, groupId) async {
  final supabase = Supabase.instance.client;
  final response = await supabase
      .from('group_members')
      .select('profiles(id, username, email)')
      .eq('group_id', groupId);

  return List<Map<String, dynamic>>.from(response.map((e) => e['profiles']));
});

