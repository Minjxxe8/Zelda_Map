import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/photo_provider.dart';
import 'photo_grid_tile.dart';

class PhotoGrid extends ConsumerWidget {
  final String userId;
  final String title;

  const PhotoGrid({
    super.key,
    required this.userId,
    this.title = "Mes Photos",
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsync = ref.watch(userPhotosProvider(userId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        photosAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Erreur : $err")),
          data: (photos) {
            if (photos.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text("Aucune photo pour le moment"),

              );
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: photos.length,
              itemBuilder: (_, index) => PhotoGridTile(photo: photos[index]),
            );
          },
        ),
      ],
    );
  }
}
