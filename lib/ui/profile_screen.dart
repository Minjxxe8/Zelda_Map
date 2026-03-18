import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'auth_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(title: const Text("Mon Profill")),
      body: Center(
        child: user == null
            ? const Text("Aucune session active")
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            Text("Pseudo : ${user.username}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Email : ${user.email}",
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await ref.read(authProvider).handleSignOut();

                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                  );
                }
              },
              child: const Text("Déconnexion"),
            ),

            TextButton(
              onPressed: () => _showDeleteDialog(context, ref),
              child: const Text("Supprimer définitivement mon compte",
                  style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}


void _showDeleteDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Supprimer le compte ?"),
      content: const Text("Cette action est irréversible. Toutes vos photos seront supprimées."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
        TextButton(
          onPressed: () async {
            final error = await ref.read(authProvider).handleDeleteAccount();
            if (context.mounted) {
              if (error == null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
              }
            }
          },
          child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}