import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zelda_map/ui/profile/widgets/delete_account_btn.dart';
import 'package:zelda_map/ui/profile/widgets/logout_btn.dart';
import 'package:zelda_map/ui/profile/widgets/profile_showcase.dart';
import 'package:zelda_map/ui/widgets/app_page_app_bar.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/photo_provider.dart';

class ProfileScreen extends ConsumerWidget {
  final bool embedded;

  const ProfileScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final photosAsync = user == null ? null : ref.watch(userPhotosProvider(user.id));
    final likesGivenAsync =
        user == null ? null : ref.watch(userLikesGivenCountProvider(user.id));

    final body = user == null
        ? const Center(child: Text("Aucune session active"))
        : RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userPhotosProvider(user.id));
              ref.invalidate(userLikesGivenCountProvider(user.id));
              await ref.read(userPhotosProvider(user.id).future);
            },
            child: photosAsync!.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Erreur : $error')),
              data: (photos) => likesGivenAsync!.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Erreur : $error')),
                data: (likesGiven) => ProfileShowcase(
                  username: user.username,
                  email: user.email,
                  photos: photos,
                  isOwnProfile: true,
                  likesGiven: likesGiven,
                  footer: const Column(
                    children: [
                      LogoutButton(),
                      DeleteAccountButton(),
                    ],
                  ),
                ),
              ),
            ),
          );

    if (embedded) {
      return body;
    }

    return Scaffold(
      appBar: const AppPageAppBar(title: 'Profil'),
      body: body,
    );
  }
}
