import '/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On écoute le provider de la liste
    final usersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Annuaire"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            // onPressed: () => ref.refresh(allUsersProvider),
            onPressed: () => ref.invalidate(allUsersProvider),
          ),
        ],
      ),
      body: usersAsync.when(
        data: (users) => ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text(user.email),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/users/${user.id}'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Erreur: $err")),
      ),
    );
  }
}
