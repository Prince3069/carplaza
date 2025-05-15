import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/models/user_model.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static const String carsCollection = 'cars';
  static const String usersCollection = 'users';
  static const String carImagesFolder = 'car_images';

  Future<String?> addCar(Car car) async {
    try {
      debugPrint('Adding car: ${car.toMap()}');
      DocumentReference docRef =
          await _firestore.collection(carsCollection).add(car.toMap());
      debugPrint('Car added with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('Error adding car: $e');
      return null;
    }
  }

  Stream<List<Car>> get cars {
    return _firestore
        .collection(carsCollection)
        .orderBy('postedDate', descending: true)
        .snapshots()
        .handleError((error) {
      debugPrint('Error fetching cars: $error');
      return [];
    }).map((snapshot) => snapshot.docs
            .map((doc) => Car.fromMap(doc.id, doc.data()!))
            .toList());
  }

  Stream<List<Car>> getCarsBySeller(String sellerId) {
    return _firestore
        .collection(carsCollection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('postedDate', descending: true)
        .snapshots()
        .handleError((error) {
      debugPrint('Error fetching seller cars: $error');
      return [];
    }).map((snapshot) => snapshot.docs
            .map((doc) => Car.fromMap(doc.id, doc.data()!))
            .toList());
  }

  Future<List<String>> uploadCarImages(List<File> imageFiles) async {
    List<String> downloadUrls = [];
    debugPrint('Starting upload of ${imageFiles.length} images');

    try {
      for (final imageFile in imageFiles) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
        final ref = _storage.ref().child('$carImagesFolder/$fileName');

        debugPrint('Uploading: ${imageFile.path}');
        final uploadTask = await ref.putFile(imageFile);
        final downloadUrl = await uploadTask.ref.getDownloadURL();

        debugPrint('Uploaded: $downloadUrl');
        downloadUrls.add(downloadUrl);
      }
    } catch (e) {
      debugPrint('Image upload failed: $e');
      rethrow;
    }

    return downloadUrls;
  }

  Future<void> updateUserData(UserModel user) async {
    try {
      debugPrint('Updating user: ${user.id}');
      await _firestore
          .collection(usersCollection)
          .doc(user.id)
          .set(user.toMap());
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    }
  }

  Stream<UserModel?> getUserData(String userId) {
    // Note the nullable return
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .snapshots()
        .handleError((error) {
      debugPrint('Error fetching user: $error');
      return null; // Return null instead of empty snapshot
    }).map((doc) => doc.exists ? UserModel.fromMap(doc.data()!) : null);
  }

  Future<Car?> getCarById(String carId) async {
    try {
      final doc = await _firestore.collection(carsCollection).doc(carId).get();
      return doc.exists ? Car.fromMap(doc.id, doc.data()!) : null;
    } catch (e) {
      debugPrint('Error getting car: $e');
      return null;
    }
  }

  Future<void> deleteCar(String carId) async {
    try {
      await _firestore.collection(carsCollection).doc(carId).delete();
      debugPrint('Car deleted: $carId');
    } catch (e) {
      debugPrint('Error deleting car: $e');
      rethrow;
    }
  }
}
