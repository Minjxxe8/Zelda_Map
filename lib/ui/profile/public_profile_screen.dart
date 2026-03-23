import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/photo_provider.dart';
import '../../repository/auth_repository.dart';
import '../widgets/app_page_app_bar.dart';
import 'widgets/profile_showcase.dart';

final publicProfileProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
  return AuthRepository().getProfileById(userId);
});

class PublicProfileScreen extends ConsumerWidget {
  final String userId;
  final String username;

  const PublicProfileScreen({
    super.key,
    required this.userId,
    required this.username,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(publicProfileProvider(userId));
    final photosAsync = ref.watch(userPhotosProvider(userId));
    final likesGivenAsync = ref.watch(userLikesGivenCountProvider(userId));

    return Scaffold(
      appBar: AppPageAppBar(title: username),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(publicProfileProvider(userId));
          ref.invalidate(userPhotosProvider(userId));
          ref.invalidate(userLikesGivenCountProvider(userId));
          await ref.read(publicProfileProvider(userId).future);
        },
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Erreur : $error')),
          data: (profile) => photosAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Erreur : $error')),
            data: (photos) => likesGivenAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Erreur : $error')),
              data: (likesGiven) => ProfileShowcase(
                username: (profile?['username'] ?? username) as String,
                email: profile?['email'] as String?,
                photos: photos,
                isOwnProfile: false,
                likesGiven: likesGiven,
                primaryActionLabel: 'Suivre',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
