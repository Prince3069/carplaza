import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/models/conversation.dart';
import 'package:car_plaza/models/message_model.dart';
import 'package:car_plaza/models/user_model.dart';
import 'package:car_plaza/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // User operations
  Future<void> addUser(UserModel user) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.id)
          .set(user.toMap());
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()! as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.id)
          .update(user.toMap());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Car operations
  Future<String> addCar(CarModel car) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.carsCollection)
          .add(car.toMap());

      // Update the car with its ID
      await docRef.update({'id': docRef.id});

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add car: $e');
    }
  }

  Future<void> updateCar(CarModel car) async {
    try {
      await _firestore
          .collection(AppConstants.carsCollection)
          .doc(car.id)
          .update(car.toMap());
    } catch (e) {
      throw Exception('Failed to update car: $e');
    }
  }

  Future<void> deleteCar(String carId) async {
    try {
      await _firestore
          .collection(AppConstants.carsCollection)
          .doc(carId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete car: $e');
    }
  }

  Future<CarModel?> getCar(String carId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.carsCollection)
          .doc(carId)
          .get();

      if (doc.exists && doc.data() != null) {
        return CarModel.fromMap(doc.data()! as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get car: $e');
    }
  }

  /// 🔍 NEW: Search Cars with Multiple Filters
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
    try {
      Query query = _firestore
          .collection(AppConstants.carsCollection)
          .where('isSold', isEqualTo: false);

      if (brand != null && brand.isNotEmpty) {
        query = query.where('brand', isEqualTo: brand);
      }
      if (model != null && model.isNotEmpty) {
        query = query.where('model', isEqualTo: model);
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

      final cars = snapshot.docs
          .map((doc) =>
              CarModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      return cars.where((car) {
        final year = int.tryParse(car.year.toString()) ?? 0;
        final price = car.price ?? 0.0;

        final matchesYear = (minYear == null || year >= minYear) &&
            (maxYear == null || year <= maxYear);
        final matchesPrice = (minPrice == null || price >= minPrice) &&
            (maxPrice == null || price <= maxPrice);
        return matchesYear && matchesPrice;
      }).toList();
    } catch (e) {
      throw Exception('Failed to search cars: $e');
    }
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

  Future<List<String>> getCarImageUrls(String carId) async {
    try {
      final ref = _storage.ref('${AppConstants.carImagesPath}/$carId');
      final result = await ref.listAll();
      return await Future.wait(
        result.items.map((item) => item.getDownloadURL()),
      );
    } catch (e) {
      throw Exception('Failed to get car images: $e');
    }
  }

  // Message operations
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

    try {
      // Add to messages collection
      await _firestore.collection(AppConstants.messagesCollection).add({
        'senderId': currentUserId,
        'receiverId': receiverId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });

      // Update or create conversation document
      final conversationId = _generateConversationId(currentUserId, receiverId);
      final userDoc = await getUser(currentUserId);
      final receiverDoc = await getUser(receiverId);

      await _firestore.collection('conversations').doc(conversationId).set({
        'participants': [currentUserId, receiverId],
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'otherUserId': receiverId,
        'otherUserName': receiverDoc?.name ?? 'Unknown',
        'otherUserPhotoUrl': receiverDoc?.photoUrl,
        'unreadCount': FieldValue.increment(1),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Stream<List<Conversation>> getUserConversations() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Conversation.fromFirestore(doc))
            .toList());
  }

  Future<void> markMessagesAsRead(
      String conversationId, String otherUserId) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    try {
      await _firestore.collection('conversations').doc(conversationId).update({
        'unreadCount': 0,
      });

      // Mark individual messages as read
      final query = await _firestore
          .collection(AppConstants.messagesCollection)
          .where('senderId', isEqualTo: otherUserId)
          .where('receiverId', isEqualTo: currentUserId)
          .where('read', isEqualTo: false)
          .get();

      for (final doc in query.docs) {
        await doc.reference.update({'read': true});
      }
    } catch (e) {
      throw Exception('Failed to mark messages as read: $e');
    }
  }

  String _generateConversationId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return '${ids[0]}_${ids[1]}';
  }
}
