import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show FutureProvider, Ref;
import 'package:flutter_riverpod/legacy.dart' show ChangeNotifierProvider;
import 'package:image_picker/image_picker.dart';
import 'auth_provider.dart';
import '../model/daily_post.dart';
import '../repository/photo_repository.dart';
import '../services/storage_service.dart';

class PhotoProvider extends ChangeNotifier {
  final Ref ref;
  final _storage = StorageService();
  final _repo = PhotoRepository();

  PhotoProvider(this.ref);

  bool _isUploading = false;
  bool get isUploading => _isUploading;
  final Set<String> _likeInProgress = {};

  bool isLiking(String photoId) => _likeInProgress.contains(photoId);

  Future<void> takeAndUploadPhoto(String userId, BuildContext context) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      String? caption = await _showCaptionDialog(context);

      _isUploading = true;
      notifyListeners();
      try {
        final url = await _storage.uploadPhoto(File(pickedFile.path), userId);

        await _repo.savePhotoData(userId, url, caption ?? "Ma nouvelle photo !");
        ref.invalidate(userPhotosProvider(userId));
        ref.invalidate(dailyFeedProvider);

      } catch (e) {
        print("ERREUR : $e");
      } finally {
        _isUploading = false;
        notifyListeners();
      }
    } else {
      print("Aucune photo sélectionnée.");
    }
  }

  Future<void> toggleLike(String photoId, String userId) async {
    if (_likeInProgress.contains(photoId)) {
      return;
    }

    _likeInProgress.add(photoId);
    notifyListeners();
    try {
      await _repo.togglePhotoLike(photoId, userId);
      ref.invalidate(dailyFeedProvider);
    } finally {
      _likeInProgress.remove(photoId);
      notifyListeners();
    }
  }
}

Future<String?> _showCaptionDialog(BuildContext context) {
  TextEditingController controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Ajouter une légende"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: "C'était un super moment..."),
        autofocus: true,
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Passer")),
        ElevatedButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text("Valider")),
      ],
    ),
  );
}

final dailyFeedProvider = FutureProvider<List<DailyPost>>((ref) async {
  final repo = PhotoRepository();
  final currentUserId = ref.watch(authProvider).user?.id;
  return repo.getTodaysPosts(currentUserId: currentUserId);
});

final userPhotosProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
  final repo = PhotoRepository();
  return await repo.getUserPhotos(userId);
});

final photoProvider = ChangeNotifierProvider((ref) => PhotoProvider(ref));
