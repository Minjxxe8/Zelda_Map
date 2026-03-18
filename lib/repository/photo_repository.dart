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

  Future<List<String>> getUserPhotoUrls(String userId) async {
    final response = await _supabase
        .from('photos')
        .select('image_url')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((item) => item['image_url'] as String).toList();
  }
}