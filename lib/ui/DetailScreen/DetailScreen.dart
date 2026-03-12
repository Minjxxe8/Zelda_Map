import '/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailScreen extends ConsumerWidget {
  final String userId;
  const DetailScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Utilisation de .family pour récupérer l'utilisateur précis
    final userAsync = ref.watch(userDetailProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('Détails')),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Erreur : $err")),
        data: (user) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 40, child: Text(user.name[0])),
              const SizedBox(height: 20),
              Text(
                user.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(user.email),
            ],
          ),
        ),
      ),
    );
  }
}
