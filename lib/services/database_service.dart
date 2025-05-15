import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Cars Collection
  final String carsCollection = 'cars';

  // Users Collection
  final String usersCollection = 'users';

  // Add a new car
  Future<String?> addCar(Car car) async {
    try {
      DocumentReference docRef =
          await _firestore.collection(carsCollection).add(car.toMap());
      return docRef.id;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Get all cars
  Stream<List<Car>> get cars {
    return _firestore
        .collection(carsCollection)
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Car.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get cars by seller
  Stream<List<Car>> getCarsBySeller(String sellerId) {
    return _firestore
        .collection(carsCollection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Car.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Upload car images
  Future<List<String>> uploadCarImages(List<String> imagePaths) async {
    List<String> downloadUrls = [];

    try {
      for (String path in imagePaths) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = _storage.ref().child('car_images/$fileName');
        await ref.putFile(path as File);
        String downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
    } catch (e) {
      print(e.toString());
    }

    return downloadUrls;
  }

  // Add or update user
  Future<void> updateUserData(UserModel user) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(user.id)
          .set(user.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  // Get user data
  Stream<UserModel> getUserData(String userId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>));
  }
}
