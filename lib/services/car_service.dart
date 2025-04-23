// File: lib/services/car_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:car_plaza/models/car.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class CarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid _uuid = const Uuid();

  // Get featured cars
  Future<List<Car>> getFeaturedCars() async {
    try {
      // For testing/demo purposes, return dummy data
      return List.generate(
        5,
        (index) => Car(
          id: 'featured_$index',
          title: 'Featured Car ${index + 1}',
          price: 25000 + (index * 5000),
          location: 'New York',
          imageUrl: 'https://via.placeholder.com/300',
          isFeatured: true,
          make: 'Toyota',
          model: 'Camry',
          year: '2022',
        ),
      );

      // In a real app, you would use:
      // final snapshot = await _firestore
      //     .collection('cars')
      //     .where('isFeatured', isEqualTo: true)
      //     .limit(5)
      //     .get();

      // return snapshot.docs
      //     .map((doc) => Car.fromMap(doc.data(), doc.id))
      //     .toList();
    } catch (e) {
      throw Exception('Failed to get featured cars: $e');
    }
  }

  // Get recent cars
  Future<List<Car>> getRecentCars() async {
    try {
      // For testing/demo purposes, return dummy data
      return List.generate(
        10,
        (index) => Car(
          id: 'car_$index',
          title: 'Toyota Camry 2022',
          price: 25000 + (index * 1000),
          location: 'New York',
          imageUrl: 'https://via.placeholder.com/300',
          make: 'Toyota',
          model: 'Camry',
          year: '2022',
        ),
      );

      // In a real app, you would use:
      // final snapshot = await _firestore
      //     .collection('cars')
      //     .orderBy('createdAt', descending: true)
      //     .limit(10)
      //     .get();

      // return snapshot.docs
      //     .map((doc) => Car.fromMap(doc.data(), doc.id))
      //     .toList();
    } catch (e) {
      throw Exception('Failed to get recent cars: $e');
    }
  }

  // Get cars by category
  Future<List<Car>> getCarsByCategory(String category) async {
    try {
      // For testing/demo purposes, return dummy data
      return List.generate(
        8,
        (index) => Car(
          id: '${category.toLowerCase()}_$index',
          title: '$category Car ${index + 1}',
          price: 20000 + (index * 1500),
          location: 'New York',
          imageUrl: 'https://via.placeholder.com/300',
          make: category,
          model: 'Model ${index + 1}',
          year: '2022',
        ),
      );

      // In a real app, you would use:
      // final snapshot = await _firestore
      //     .collection('cars')
      //     .where('make', isEqualTo: category)
      //     .get();

      // return snapshot.docs
      //     .map((doc) => Car.fromMap(doc.data(), doc.id))
      //     .toList();
    } catch (e) {
      throw Exception('Failed to get cars by category: $e');
    }
  }

  // Search cars
  Future<List<Car>> searchCars(String query) async {
    try {
      // For testing/demo purposes, return dummy data
      return List.generate(
        5,
        (index) => Car(
          id: 'search_$index',
          title: 'Toyota Camry 2022',
          price: 25000 + (index * 1000),
          location: 'New York',
          imageUrl: 'https://via.placeholder.com/300',
          make: 'Toyota',
          model: 'Camry',
          year: '2022',
        ),
      );

      // In a real app, you would use Firebase Cloud Functions or a more complex query
      // This is a simplified version
      // final snapshot = await _firestore
      //     .collection('cars')
      //     .orderBy('title')
      //     .startAt([query])
      //     .endAt([query + '\uf8ff'])
      //     .get();

      // return snapshot.docs
      //     .map((doc) => Car.fromMap(doc.data(), doc.id))
      //     .toList();
    } catch (e) {
      throw Exception('Failed to search cars: $e');
    }
  }

  // Add a new car listing
  Future<void> addCar(Car car, List<File> images) async {
    try {
      final String userId = _auth.currentUser?.uid ?? 'test_user';
      final String carId = _uuid.v4();

      // Upload images
      List<String> imageUrls = [];
      for (var image in images) {
        final ref = _storage.ref().child('cars/$carId/${_uuid.v4()}');
        final uploadTask = await ref.putFile(image);
        final url = await uploadTask.ref.getDownloadURL();
        imageUrls.add(url);
      }

      // Create car with updated data
      final newCar = Car(
        id: carId,
        title: car.title,
        price: car.price,
        location: car.location,
        imageUrl: imageUrls.isNotEmpty ? imageUrls[0] : '',
        description: car.description,
        make: car.make,
        model: car.model,
        year: car.year,
        sellerId: userId,
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      // await _firestore.collection('cars').doc(carId).set(newCar.toMap());

      // For testing purposes, we'll just simulate a delay
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw Exception('Failed to add car: $e');
    }
  }

  // Get cars by user
  Future<List<Car>> getMyListings() async {
    try {
      final String userId = _auth.currentUser?.uid ?? 'test_user';

      // For testing/demo purposes, return dummy data
      return List.generate(
        3,
        (index) => Car(
          id: 'my_car_$index',
          title: 'My Car ${index + 1}',
          price: 25000 + (index * 1000),
          location: 'New York',
          imageUrl: 'https://via.placeholder.com/300',
          sellerId: userId,
        ),
      );

      // In a real app, you would use:
      // final snapshot = await _firestore
      //     .collection('cars')
      //     .where('sellerId', isEqualTo: userId)
      //     .get();

      // return snapshot.docs
      //     .map((doc) => Car.fromMap(doc.data(), doc.id))
      //     .toList();
    } catch (e) {
      throw Exception('Failed to get my listings: $e');
    }
  }
}
