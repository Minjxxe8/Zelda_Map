import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auth_provider.dart';
import '../../auth_screen.dart';

class DeleteAccountButton extends ConsumerWidget {
  const DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      icon: const Icon(Icons.delete_forever, color: Colors.red),
      label: const Text("Supprimer mon compte",
          style: TextStyle(color: Colors.red)),
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Supprimer le compte"),
            content: const Text(
                "Cette action est irréversible. Toutes tes données seront supprimées."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Annuler"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Supprimer",
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );

        if (confirm != true || !context.mounted) return;

        await ref.read(authProvider).handleDeleteAccount();

        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AuthScreen()),
          );
        }
      },
    );
  }
}