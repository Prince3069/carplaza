// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:car_plaza/models/car_model.dart';
// import 'package:car_plaza/models/user_model.dart';
// import 'package:car_plaza/utils/constants.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // User operations
//   Future<void> addUser(UserModel user) async {
//     await _firestore
//         .collection(AppConstants.usersCollection)
//         .doc(user.id)
//         .set(user.toMap());
//   }

//   Future<UserModel?> getUser(String userId) async {
//     final doc = await _firestore
//         .collection(AppConstants.usersCollection)
//         .doc(userId)
//         .get();
//     if (doc.exists) {
//       return UserModel.fromMap(doc.data()!, doc.id);
//     }
//     return null;
//   }

//   Future<void> updateUser(UserModel user) async {
//     await _firestore
//         .collection(AppConstants.usersCollection)
//         .doc(user.id)
//         .update(user.toMap());
//   }

//   // Car operations
//   Future<String> addCar(CarModel car) async {
//     final docRef = await _firestore
//         .collection(AppConstants.carsCollection)
//         .add(car.toMap());
//     return docRef.id;
//   }

//   Future<void> updateCar(CarModel car) async {
//     await _firestore
//         .collection(AppConstants.carsCollection)
//         .doc(car.id)
//         .update(car.toMap());
//   }

//   Future<void> deleteCar(String carId) async {
//     await _firestore
//         .collection(AppConstants.carsCollection)
//         .doc(carId)
//         .delete();
//   }

//   Future<CarModel?> getCar(String carId) async {
//     final doc = await _firestore
//         .collection(AppConstants.carsCollection)
//         .doc(carId)
//         .get();
//     if (doc.exists) {
//       return CarModel.fromMap(doc.data()!, doc.id);
//     }
//     return null;
//   }

//   Stream<List<CarModel>> getFeaturedCars() {
//     return _firestore
//         .collection(AppConstants.carsCollection)
//         .where('isFeatured', isEqualTo: true)
//         .where('isSold', isEqualTo: false)
//         .orderBy('postedAt', descending: true)
//         .limit(10)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => CarModel.fromMap(doc.data(), doc.id))
//             .toList());
//   }

//   Stream<List<CarModel>> getLatestCars() {
//     return _firestore
//         .collection(AppConstants.carsCollection)
//         .where('isSold', isEqualTo: false)
//         .orderBy('postedAt', descending: true)
//         .limit(20)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => CarModel.fromMap(doc.data(), doc.id))
//             .toList());
//   }

//   Stream<List<CarModel>> getCarsBySeller(String sellerId) {
//     return _firestore
//         .collection(AppConstants.carsCollection)
//         .where('sellerId', isEqualTo: sellerId)
//         .orderBy('postedAt', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => CarModel.fromMap(doc.data(), doc.id))
//             .toList());
//   }

//   Future<List<CarModel>> searchCars({
//     String? brand,
//     String? model,
//     int? minYear,
//     int? maxYear,
//     double? minPrice,
//     double? maxPrice,
//     String? location,
//     String? transmission,
//     String? fuelType,
//   }) async {
//     Query query = _firestore
//         .collection(AppConstants.carsCollection)
//         .where('isSold', isEqualTo: false);

//     if (brand != null && brand.isNotEmpty) {
//       query = query.where('brand', isEqualTo: brand);
//     }
//     if (model != null && model.isNotEmpty) {
//       query = query.where('model', isEqualTo: model);
//     }
//     if (minYear != null) {
//       query = query.where('year', isGreaterThanOrEqualTo: minYear);
//     }
//     if (maxYear != null) {
//       query = query.where('year', isLessThanOrEqualTo: maxYear);
//     }
//     if (minPrice != null) {
//       query = query.where('price', isGreaterThanOrEqualTo: minPrice);
//     }
//     if (maxPrice != null) {
//       query = query.where('price', isLessThanOrEqualTo: maxPrice);
//     }
//     if (location != null && location.isNotEmpty) {
//       query = query.where('location', isEqualTo: location);
//     }
//     if (transmission != null && transmission.isNotEmpty) {
//       query = query.where('transmission', isEqualTo: transmission);
//     }
//     if (fuelType != null && fuelType.isNotEmpty) {
//       query = query.where('fuelType', isEqualTo: fuelType);
//     }

//     final snapshot = await query.get();
//     return snapshot.docs
//         .map((doc) => CarModel.fromMap(doc.data(), doc.id))
//         .toList();
//   }
// }

// ignore_for_file: unnecessary_cast

import 'package:car_plaza/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/models/user_model.dart';
import 'package:car_plaza/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()! as Map<String, dynamic>, doc.id);
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

    if (doc.exists && doc.data() != null) {
      return CarModel.fromMap(doc.data()! as Map<String, dynamic>, doc.id);
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
            .map((doc) =>
                CarModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
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
            .map((doc) =>
                CarModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Stream<List<CarModel>> getCarsBySeller(String sellerId) {
    return _firestore
        .collection(AppConstants.carsCollection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('postedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                CarModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
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
        .map((doc) =>
            CarModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

// Update the message methods to use MessageModel
  Stream<List<MessageModel>> getMessages(String receiverId) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection(AppConstants.messagesCollection)
        .where('senderId', whereIn: [currentUserId, receiverId])
        .where('receiverId', whereIn: [currentUserId, receiverId])
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> sendMessage({
    required String receiverId,
    required String text,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    await _firestore.collection(AppConstants.messagesCollection).add({
      'senderId': currentUserId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });
  }

  Stream<List<MessageModel>> getUserConversations() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection(AppConstants.messagesCollection)
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return MessageModel.forConversation(
                id: doc.id,
                receiverId: data['receiverId'] == currentUserId
                    ? data['senderId']
                    : data['receiverId'],
                receiverName: data['receiverName'] ?? 'Unknown',
                lastMessage: data['lastMessage'] ?? '',
                lastMessageTime:
                    (data['lastMessageTime'] as Timestamp).toDate(),
                unreadCount: data['unreadCount'] ?? 0,
                receiverPhotoUrl: data['receiverPhotoUrl'],
              );
            }).toList());
  }
}
