// FIREBASE STORAGE SERVICE
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadCarImage(XFile imageFile) async {
    try {
      final ref = _storage
          .ref()
          .child('car_images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = await ref.putData(await imageFile.readAsBytes());
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error uploading car image: $e");
      rethrow;
    }
  }

  Future<String> uploadProfileImage({
    required String userId,
    required XFile imageFile,
  }) async {
    try {
      final ref = _storage.ref().child('profile_images/$userId');
      final uploadTask = await ref.putData(await imageFile.readAsBytes());
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error uploading profile image: $e");
      rethrow;
    }
  }

  Future<void> deleteImage(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (e) {
      debugPrint("Error deleting image: $e");
      rethrow;
    }
  }
}
