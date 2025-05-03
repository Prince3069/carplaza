import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/models/user_model.dart';
import 'package:car_plaza/utils/constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User operations
  Future<void> addUser(UserModel user) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.id)
        .set(user.toMap());
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.id)
        .update(user.toMap());
  }

  // Car operations
  Future<String> addCar(CarModel car) async {
    final docRef = await _firestore
        .collection(AppConstants.carsCollection)
        .add(car.toMap());
    return docRef.id;
  }

  Future<void> updateCar(CarModel car) async {
    await _firestore
        .collection(AppConstants.carsCollection)
        .doc(car.id)
        .update(car.toMap());
  }

  Future<void> deleteCar(String carId) async {
    await _firestore
        .collection(AppConstants.carsCollection)
        .doc(carId)
        .delete();
  }

  Future<CarModel?> getCar(String carId) async {
    final doc = await _firestore
        .collection(AppConstants.carsCollection)
        .doc(carId)
        .get();
    if (doc.exists) {
      return CarModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Stream<List<CarModel>> getFeaturedCars() {
    return _firestore
        .collection(AppConstants.carsCollection)
        .where('isFeatured', isEqualTo: true)
        .where('isSold', isEqualTo: false)
        .orderBy('postedAt', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CarModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<CarModel>> getLatestCars() {
    return _firestore
        .collection(AppConstants.carsCollection)
        .where('isSold', isEqualTo: false)
        .orderBy('postedAt', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CarModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<CarModel>> getCarsBySeller(String sellerId) {
    return _firestore
        .collection(AppConstants.carsCollection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('postedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CarModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<List<CarModel>> searchCars({
    String? brand,
    String? model,
    int? minYear,
    int? maxYear,
    double? minPrice,
    double? maxPrice,
    String? location,
    String? transmission,
    String? fuelType,
  }) async {
    Query query = _firestore
        .collection(AppConstants.carsCollection)
        .where('isSold', isEqualTo: false);

    if (brand != null && brand.isNotEmpty) {
      query = query.where('brand', isEqualTo: brand);
    }
    if (model != null && model.isNotEmpty) {
      query = query.where('model', isEqualTo: model);
    }
    if (minYear != null) {
      query = query.where('year', isGreaterThanOrEqualTo: minYear);
    }
    if (maxYear != null) {
      query = query.where('year', isLessThanOrEqualTo: maxYear);
    }
    if (minPrice != null) {
      query = query.where('price', isGreaterThanOrEqualTo: minPrice);
    }
    if (maxPrice != null) {
      query = query.where('price', isLessThanOrEqualTo: maxPrice);
    }
    if (location != null && location.isNotEmpty) {
      query = query.where('location', isEqualTo: location);
    }
    if (transmission != null && transmission.isNotEmpty) {
      query = query.where('transmission', isEqualTo: transmission);
    }
    if (fuelType != null && fuelType.isNotEmpty) {
      query = query.where('fuelType', isEqualTo: fuelType);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => CarModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}
