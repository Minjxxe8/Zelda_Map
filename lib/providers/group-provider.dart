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