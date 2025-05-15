// TODO Implement this library.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/car_model.dart';
import '../models/user_model.dart';

class FirebaseService {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // Collections
  static const String carsCollection = 'cars';
  static const String usersCollection = 'users';
  static const String carImagesFolder = 'car_images';

  // Auth Methods ==============================================

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result.user;
    } catch (e) {
      print('Sign in anonymously error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      throw e;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc =
            await _firestore.collection(usersCollection).doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  // Car Methods ===============================================

  Future<String?> addCar(Car car) async {
    try {
      DocumentReference docRef =
          await _firestore.collection(carsCollection).add(car.toMap());
      return docRef.id;
    } catch (e) {
      print('Add car error: $e');
      return null;
    }
  }

  Future<void> updateCar(Car car) async {
    try {
      await _firestore
          .collection(carsCollection)
          .doc(car.id)
          .update(car.toMap());
    } catch (e) {
      print('Update car error: $e');
      throw e;
    }
  }

  Future<void> deleteCar(String carId) async {
    try {
      await _firestore.collection(carsCollection).doc(carId).delete();
    } catch (e) {
      print('Delete car error: $e');
      throw e;
    }
  }

  Stream<List<Car>> getAllCars() {
    return _firestore
        .collection(carsCollection)
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                Car.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<Car>> getCarsBySeller(String sellerId) {
    return _firestore
        .collection(carsCollection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                Car.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<Car?> getCarById(String carId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(carsCollection).doc(carId).get();
      if (doc.exists) {
        return Car.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Get car by ID error: $e');
      return null;
    }
  }

  // Image Handling Methods =====================================

  Future<List<String>> uploadCarImages(List<XFile> imageFiles) async {
    List<String> downloadUrls = [];

    try {
      for (XFile file in imageFiles) {
        String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
        Reference ref = _storage.ref().child('$carImagesFolder/$fileName');
        await ref.putFile(File(file.path));
        String downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
    } catch (e) {
      print('Upload images error: $e');
      throw e;
    }

    return downloadUrls;
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print('Delete image error: $e');
      throw e;
    }
  }

  // User Methods ==============================================

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(user.id)
          .set(user.toMap());
    } catch (e) {
      print('Create user error: $e');
      throw e;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(user.id)
          .update(user.toMap());
    } catch (e) {
      print('Update user error: $e');
      throw e;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(usersCollection).doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Get user error: $e');
      return null;
    }
  }

  Stream<UserModel> getUserStream(String userId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>));
  }

  // Search Methods ============================================

  Stream<List<Car>> searchCars({
    String? query,
    String? brand,
    String? location,
    double? minPrice,
    double? maxPrice,
    int? minYear,
    int? maxYear,
  }) {
    Query collection = _firestore.collection(carsCollection);

    if (query != null && query.isNotEmpty) {
      collection = collection.where(
        'searchKeywords',
        arrayContains: query.toLowerCase(),
      );
    }

    if (brand != null && brand.isNotEmpty) {
      collection = collection.where('brand', isEqualTo: brand);
    }

    if (location != null && location.isNotEmpty) {
      collection = collection.where('location', isEqualTo: location);
    }

    if (minPrice != null) {
      collection = collection.where('price', isGreaterThanOrEqualTo: minPrice);
    }

    if (maxPrice != null) {
      collection = collection.where('price', isLessThanOrEqualTo: maxPrice);
    }

    if (minYear != null) {
      collection = collection.where('year', isGreaterThanOrEqualTo: minYear);
    }

    if (maxYear != null) {
      collection = collection.where('year', isLessThanOrEqualTo: maxYear);
    }

    return collection.orderBy('postedDate', descending: true).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) =>
                Car.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Verification Methods =======================================

  Future<void> verifySeller(String userId) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).update({
        'isVerifiedSeller': true,
      });
    } catch (e) {
      print('Verify seller error: $e');
      throw e;
    }
  }

  Future<void> verifyCarListing(String carId) async {
    try {
      await _firestore.collection(carsCollection).doc(carId).update({
        'isVerified': true,
      });
    } catch (e) {
      print('Verify car listing error: $e');
      throw e;
    }
  }
}
