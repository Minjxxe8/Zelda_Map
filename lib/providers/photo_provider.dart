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

  Future<void> takeAndUploadPhoto(String userId) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      print("📸 Photo prise ! Chemin : ${pickedFile.path}");
      _isUploading = true;
      notifyListeners();
      try {
        final url = await _storage.uploadPhoto(File(pickedFile.path), userId);

        await _repo.savePhotoData(userId, url);
        ref.invalidate(userPhotosProvider(userId));

      } catch (e) {
        print("ERREUR : $e");
      } finally {
        _isUploading = false;
        notifyListeners();
      }
    } else {
      print("🚫 Aucune photo sélectionnée.");
    }
  }
}


final userPhotosProvider = FutureProvider.family<List<String>, String>((ref, userId) async {
  final repo = PhotoRepository();
  return await repo.getUserPhotoUrls(userId);
});

final photoProvider = ChangeNotifierProvider((ref) => PhotoProvider(ref));
