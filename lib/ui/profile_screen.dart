import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/photo_provider.dart';
import 'auth_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final photoState = ref.watch(photoProvider);
    final user = authState.user;

    final photosAsync = user != null
        ? ref.watch(userPhotosProvider(user.id))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Profil"),
        centerTitle: true,
      ),
      body: user == null
          ? const Center(child: Text("Aucune session active"))
          : RefreshIndicator(
        onRefresh: () => ref.refresh(userPhotosProvider(user.id).future),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(user.username,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(user.email,
                  style: const TextStyle(color: Colors.grey)),

              const SizedBox(height: 30),
              const Divider(),

              if (photoState.isUploading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Prendre une photo"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => ref.read(photoProvider).takeAndUploadPhoto(user.id),
                ),

              const SizedBox(height: 30),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Mes Photos",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 15),

              photosAsync!.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text("Erreur : $err")),
                data: (urls) {
                  if (urls.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("Aucune photo pour le moment 📸"),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: urls.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          urls[index],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(color: Colors.grey[200]);
                          },
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 50),

              TextButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text("Se déconnecter", style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  await ref.read(authProvider).handleSignOut();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const AuthScreen()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}