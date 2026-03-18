import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import '../repository/photo_repository.dart';
import '../services/storage_service.dart';

class PhotoProvider extends ChangeNotifier {
  final Ref ref;
  final _storage = StorageService();
  final _repo = PhotoRepository();

  PhotoProvider(this.ref);

  bool _isUploading = false;
  bool get isUploading => _isUploading;

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


final userPhotosProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
  final repo = PhotoRepository();
  return await repo.getUserPhotos(userId);
});

final photoProvider = ChangeNotifierProvider((ref) => PhotoProvider(ref));
