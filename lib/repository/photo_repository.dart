import 'package:supabase_flutter/supabase_flutter.dart';

class PhotoRepository {
  final _supabase = Supabase.instance.client;

  Future<void> savePhotoData(String userId, String imageUrl) async {
    await _supabase.from('photos').insert({
      'user_id': userId,
      'image_url': imageUrl,
      'caption': 'Ma nouvelle photo !',
      'mode': 'classic',
    });
  }

  Future<List<Map<String, dynamic>>> getUserPhotos(String userId) async {
    final response = await _supabase
        .from('photos')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}