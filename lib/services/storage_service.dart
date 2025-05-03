import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:car_plaza/utils/constants.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage(String userId, XFile image) async {
    try {
      final ref = _storage.ref('${AppConstants.profileImagesPath}/$userId');
      final uploadTask = await ref.putFile(File(image.path));
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  Future<List<String>> uploadCarImages(String carId, List<XFile> images) async {
    try {
      List<String> downloadUrls = [];
      for (int i = 0; i < images.length; i++) {
        final ref = _storage.ref('${AppConstants.carImagesPath}/$carId/$i');
        final uploadTask = await ref.putFile(File(images[i].path));
        final downloadUrl = await uploadTask.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
      return downloadUrls;
    } catch (e) {
      throw Exception('Failed to upload car images: $e');
    }
  }

  Future<void> deleteCarImages(String carId) async {
    try {
      final ref = _storage.ref('${AppConstants.carImagesPath}/$carId');
      final listResult = await ref.listAll();
      await Future.wait(listResult.items.map((item) => item.delete()));
    } catch (e) {
      throw Exception('Failed to delete car images: $e');
    }
  }
}
