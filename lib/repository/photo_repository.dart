import '../model/daily_post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PhotoRepository {
  final _supabase = Supabase.instance.client;

  Future<void> savePhotoData(String userId, String imageUrl, String caption) async {
    await _supabase.from('photos').insert({
      'user_id': userId,
      'image_url': imageUrl,
      'caption': caption,
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

  Future<void> updatePhotoCaption(String photoId, String newCaption) async {
    await _supabase
        .from('photos')
        .update({'caption': newCaption})
        .eq('id', photoId);
  }

  Future<List<DailyPost>> getTodaysPosts({String? currentUserId}) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final startOfNextDay = startOfDay.add(const Duration(days: 1));

    final photosResponse = await _supabase
        .from('photos')
        .select('id, user_id, image_url, caption, created_at')
        .gte('created_at', startOfDay.toUtc().toIso8601String())
        .lt('created_at', startOfNextDay.toUtc().toIso8601String())
        .order('created_at', ascending: false);

    final photos = List<Map<String, dynamic>>.from(photosResponse);
    if (photos.isEmpty) {
      return const [];
    }

    final userIds = photos
        .map((photo) => photo['user_id'] as String?)
        .whereType<String>()
        .toSet()
        .toList();
    final photoIds = photos
        .map((photo) => photo['id'] as String?)
        .whereType<String>()
        .toList();

    final profilesResponse = await _supabase
        .from('profiles')
        .select('id, username')
        .inFilter('id', userIds);

    final profiles = {
      for (final profile in List<Map<String, dynamic>>.from(profilesResponse))
        profile['id'] as String: (profile['username'] ?? 'Inconnu') as String,
    };

    final likesResponse = await _supabase
        .from('photo_likes')
        .select('photo, user')
        .inFilter('photo', photoIds);

    final likes = List<Map<String, dynamic>>.from(likesResponse);
    final likesPerPhoto = <String, int>{};
    final likedByCurrentUser = <String>{};

    for (final like in likes) {
      final photoId = like['photo'] as String?;
      final userId = like['user'] as String?;
      if (photoId == null) {
        continue;
      }
      likesPerPhoto[photoId] = (likesPerPhoto[photoId] ?? 0) + 1;
      if (currentUserId != null && userId == currentUserId) {
        likedByCurrentUser.add(photoId);
      }
    }

    return photos.map((photo) {
      final photoId = photo['id'] as String;
      final ownerId = photo['user_id'] as String;
      return DailyPost(
        id: photoId,
        userId: ownerId,
        username: profiles[ownerId] ?? 'Inconnu',
        imageUrl: photo['image_url'] as String,
        caption: photo['caption'] as String?,
        postedAt: DateTime.parse(photo['created_at'] as String).toLocal(),
        likesCount: likesPerPhoto[photoId] ?? 0,
        isLikedByCurrentUser: likedByCurrentUser.contains(photoId),
      );
    }).toList();
  }

  Future<void> togglePhotoLike(String photoId, String userId) async {
    final existingLike = await _supabase
        .from('photo_likes')
        .select('photo')
        .eq('photo', photoId)
        .eq('user', userId)
        .maybeSingle();

    if (existingLike != null) {
      await _supabase
          .from('photo_likes')
          .delete()
          .eq('photo', photoId)
          .eq('user', userId);
      return;
    }

    await _supabase.from('photo_likes').insert({
      'photo': photoId,
      'user': userId,
    });
  }
}
