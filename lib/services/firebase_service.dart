import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_plaza/models/car_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

// Add this method to fetch all cars
  Future<List<Car>> fetchAllCars() async {
    try {
      final snapshot = await _firestore
          .collection('cars')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => Car.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch all cars: $e');
    }
  }

  // Upload car to Firestore
  Future<void> uploadCar({
    required String title,
    required String description,
    required double price,
    required String brand,
    required String model,
    required int year,
    required String location,
    required List<String> imageUrls,
  }) async {
    try {
      await _firestore.collection('cars').add({
        'title': title,
        'description': description,
        'price': price,
        'brand': brand,
        'model': model,
        'year': year,
        'location': location,
        'imageUrls': imageUrls,
        'createdAt': FieldValue.serverTimestamp(),
        'isFeatured': false,
        'views': 0,
      });
    } catch (e) {
      throw Exception('Failed to upload car: $e');
    }
  }

  // Upload image to Firebase Storage
  Future<String> uploadImage(String path, Uint8List imageBytes) async {
    try {
      final ref = _storage.ref().child('car_images/$path');
      await ref.putData(imageBytes);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Fetch featured cars
  Future<List<Car>> fetchFeaturedCars() async {
    try {
      final snapshot = await _firestore
          .collection('cars')
          .where('isFeatured', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(5)
          .get();
      return snapshot.docs.map((doc) => Car.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch featured cars: $e');
    }
  }

  // Fetch recent cars
  Future<List<Car>> fetchRecentCars() async {
    try {
      final snapshot = await _firestore
          .collection('cars')
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();
      return snapshot.docs.map((doc) => Car.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch recent cars: $e');
    }
  }

  // Search cars
  Future<List<Car>> searchCars(String query) async {
    try {
      final snapshot = await _firestore
          .collection('cars')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: query + 'z')
          .get();
      return snapshot.docs.map((doc) => Car.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to search cars: $e');
    }
  }
}
