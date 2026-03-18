import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/photo_provider.dart';

class PhotoUploadButton extends ConsumerWidget {
  final String userId;
  const PhotoUploadButton({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUploading = ref.watch(photoProvider).isUploading;

    if (isUploading) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      );
    }

    return ElevatedButton.icon(
      icon: const Icon(Icons.camera_alt),
      label: const Text("Prendre une photo"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      onPressed: () => ref.read(photoProvider).takeAndUploadPhoto(userId, context),
    );
  }
}