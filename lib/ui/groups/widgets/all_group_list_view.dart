import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/group-provider.dart';
import '../../../repository/group_repository.dart';

class AllGroupsDiscovery extends ConsumerWidget {
  const AllGroupsDiscovery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allGroupsAsync = ref.watch(allGroupsProvider);
    final userId = ref.watch(authProvider).user!.id;

    return allGroupsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("Erreur")),
      data: (groups) {
        return ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return ListTile(
              title: Text(group['name']),
              trailing: ElevatedButton(
                onPressed: () async {
                  await GroupRepository().joinGroup(group['id'], userId);

                  ref.invalidate(allGroupsProvider);
                  ref.invalidate(myGroupsProvider(userId));

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Vous avez rejoint ${group['name']} !"))
                  );
                },
                child: const Text("Rejoindre"),
              ),
            );
          },
        );
      },
    );
  }
}