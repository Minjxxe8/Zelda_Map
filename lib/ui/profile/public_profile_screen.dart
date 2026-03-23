import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/photo_provider.dart';
import '../../repository/auth_repository.dart';
import '../widgets/app_page_app_bar.dart';
import 'widgets/photo_grid.dart';

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

    return Scaffold(
      appBar: AppPageAppBar(title: username),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(publicProfileProvider(userId));
          ref.invalidate(userPhotosProvider(userId));
          await ref.read(publicProfileProvider(userId).future);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              profileAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: CircularProgressIndicator(),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text('Erreur : $error'),
                ),
                data: (profile) {
                  final displayName = (profile?['username'] ?? username) as String;
                  final email = profile?['email'] as String?;

                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          displayName.isEmpty
                              ? '?'
                              : displayName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (email != null && email.isNotEmpty)
                        Text(
                          email,
                          style: const TextStyle(color: Colors.grey),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
              PhotoGrid(
                userId: userId,
                title: 'Photos de cet utilisateur',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
