import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/photo_provider.dart';
import '../feed/widgets/app_colors.dart';


class PhotoCaptureScreen extends ConsumerWidget {
  const PhotoCaptureScreen({super.key});

  static const _tabletBreakpoint = 768.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    if (user == null) {
      return const Center(
        child: Text('Connecte-toi pour prendre une photo.'),
      );
    }

    final isUploading = ref.watch(photoProvider).isUploading;
    final isTablet = MediaQuery.sizeOf(context).width >= _tabletBreakpoint;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 40 : 24),
        child: SizedBox(
          width: isTablet ? 460 : double.infinity,
          height: isTablet ? 280 : 220,
          child: FilledButton.icon(
            onPressed: isUploading
                ? null
                : () => ref
                    .read(photoProvider)
                    .takeAndUploadPhoto(user.id, context),
            icon: isUploading
                ? const SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  )
                : Icon(Icons.photo_camera, size: isTablet ? 56 : 42),
            label: Text(
              isUploading ? 'Ouverture...' : 'Ouvrir la camera',
              style: TextStyle(
                fontSize: isTablet ? 28 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: kAccent,
              foregroundColor: kAccentDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
