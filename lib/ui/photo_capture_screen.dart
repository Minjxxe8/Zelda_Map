import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'profile/widgets/photo_grid.dart';
import 'profile/widgets/photo_upload_btn.dart';

class PhotoCaptureScreen extends ConsumerWidget {
  const PhotoCaptureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    if (user == null) {
      return const Center(
        child: Text('Connecte-toi pour prendre une photo.'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Capture un moment',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Prends une photo depuis la camera puis ajoute-la a ta collection.',
              ),
              const SizedBox(height: 16),
              PhotoUploadButton(userId: user.id),
            ],
          ),
        ),
        const SizedBox(height: 24),
        PhotoGrid(userId: user.id),
      ],
    );
  }
}
