import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final _supabase = Supabase.instance.client;

  Future<String> uploadPhoto(File file, String userId) async {
    final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';

    await _supabase.storage.from('photos_copine').upload(fileName, file);

    final String publicUrl = _supabase.storage.from('photos_copine').getPublicUrl(fileName);

    return publicUrl;
  }
}