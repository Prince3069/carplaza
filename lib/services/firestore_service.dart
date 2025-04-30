// FIRESTORE DATABASE SERVICE
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/models/message_model.dart';
import 'package:car_plaza/models/payment_method_model.dart';
import 'package:car_plaza/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // User Collection Reference
  final CollectionReference _usersCollection = 
      FirebaseFirestore.instance.collection('users');

  // User Operations
  Future<void> createUserData(UserModel user) async {
    await _usersCollection.doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUserData(String uid) async {
    DocumentSnapshot doc = await _usersCollection.doc(uid).get();
    return doc.exists ? UserModel.fromMap(doc.data() as Map<String, dynamic>) : null;
  }

  Future<void> updateUserData(UserModel user) async {
    await _usersCollection.doc(user.uid).update(user.toMap());
  }

  // Payment Methods
  Future<List<PaymentMethod>> getUserPaymentMethods(String userId) async {
    final snapshot = await _usersCollection
        .doc(userId)
        .collection('payment_methods')
        .get();
    return snapshot.docs
        .map((doc) => PaymentMethod.fromMap(doc.data()))
        .toList();
  }

  Future<void> addPaymentMethod({
    required String userId,
    required PaymentMethod method,
  }) async {
    await _usersCollection
        .doc(userId)
        .collection('payment_methods')
        .doc(method.id)
        .set(method.toMap());
  }

  Future<void> setDefaultPaymentMethod({
    required String userId,
    required String methodId,
  }) async {
    final batch = _firestore.batch();
    
    // Reset all methods to non-default
    final methods = await _usersCollection
        .doc(userId)
        .collection('payment_methods')
        .get();
    
    for (final doc in methods.docs) {
      batch.update(doc.reference, {'isDefault': false});
    }
    
    // Set the selected method as default
    batch.update(
      _usersCollection.doc(userId).collection('payment_methods').doc(methodId),
      {'isDefault': true},
    );
    
    await batch.commit();
  }

  // Car Operations
  Future<List<CarModel>> getFeaturedCars() async {
    final snapshot = await _firestore
        .collection('cars')
        .where('isFeatured', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .get();
    
    return snapshot.docs
        .map((doc) => CarModel.fromMap(doc.data()))
        .toList();
  }

  Future<List<CarModel>> getRecentCars() async {
    final snapshot = await _firestore
        .collection('cars')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();
    
    return snapshot.docs
        .map((doc) => CarModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> addCar(CarModel car) async {
    await _firestore
        .collection('cars')
        .doc(car.id)
        .set(car.toMap());
  }

  // Saved Cars
  Future<List<CarModel>> getSavedCars(String userId) async {
    final snapshot = await _usersCollection
        .doc(userId)
        .collection('saved_cars')
        .get();
    
    return snapshot.docs
        .map((doc) => CarModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> addSavedCar({
    required String userId,
    required CarModel car,
  }) async {
    await _usersCollection
        .doc(userId)
        .collection('saved_cars')
        .doc(car.id)
        .set(car.toMap());
  }

  Future<void> removeSavedCar({
    required String userId,
    required String carId,
  }) async {
    await _usersCollection
        .doc(userId)
        .collection('saved_cars')
        .doc(carId)
        .delete();
  }

  // Chat Operations
  Future<List<ChatRoom>> getUserChatRooms(String userId) async {
    final snapshot = await _firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: userId)
        .get();
    
    return snapshot.docs
        .map((doc) => ChatRoom.fromMap(doc.data()))
        .toList();
  }

  Future<List<Message>> getChatMessages(String chatRoomId) async {
    final snapshot = await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .get();
    
    return snapshot.docs
        .map((doc) => Message.fromMap(doc.data()))
        .toList();
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String text,
  }) async {
    final message = Message