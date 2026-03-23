import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/group-provider.dart';

void showMembersSheet(BuildContext context, WidgetRef ref, String groupId) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final membersAsync = ref.watch(groupMembersProvider(groupId));

      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 5,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))
            ),
            const SizedBox(height: 20),
            const Text("Membres du groupe", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            membersAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text("Erreur : $err"),
              data: (members) => ListView.builder(
                shrinkWrap: true,
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent.withOpacity(0.1),
                      child: Text(member['username'][0].toUpperCase()),
                    ),
                    title: Text(member['username']),
                    subtitle: Text(member['email']),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}