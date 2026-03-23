import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/group-provider.dart';
import 'group_feed_screen.dart';

class MyGroupsList extends ConsumerWidget {
  const MyGroupsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authProvider).user!.id;
    final myGroupsAsync = ref.watch(myGroupsProvider(userId));

    return myGroupsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("Erreur : $e")),
      data: (groups) {
        if (groups.isEmpty) {
          return const Center(child: Text("Tu n'as rejoint aucun groupe."));
        }
        return ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.group)),
                title: Text(group['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("Voir le fil d'actualité"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupFeedScreen(group: group),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}