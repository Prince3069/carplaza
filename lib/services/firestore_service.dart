import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/models/user_model.dart';
import 'package:car_plaza/models/message_model.dart';
import 'package:image_picker/image_picker.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /* ---------------------------- User Operations ---------------------------- */

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;

      final data = doc.data();
      if (data == null) return null;

      return UserModel.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update(user.toMap());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  /* ---------------------------- Car Operations ---------------------------- */

  Stream<List<CarModel>> getCarsStream({bool featuredOnly = false}) {
    try {
      Query query =
          _firestore.collection('cars').orderBy('createdAt', descending: true);

      if (featuredOnly) {
        query = query.where('isFeatured', isEqualTo: true);
      }

      return query.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => CarModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList());
    } catch (e) {
      throw Exception('Failed to get cars stream: $e');
    }
  }

  Future<List<CarModel>> searchCars(String query) async {
    try {
      final snapshot = await _firestore
          .collection('cars')
          .where('make', isGreaterThanOrEqualTo: query)
          .where('make', isLessThan: query + 'z')
          .get();

      return snapshot.docs
          .map((doc) => CarModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search cars: $e');
    }
  }

  Future<String> addCar(CarModel car) async {
    try {
      final docRef = await _firestore.collection('cars').add(car.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add car: $e');
    }
  }

  Future<void> updateCar(CarModel car) async {
    try {
      await _firestore.collection('cars').doc(car.id).update(car.toMap());
    } catch (e) {
      throw Exception('Failed to update car: $e');
    }
  }

  Future<void> deleteCar(String carId) async {
    try {
      await _firestore.collection('cars').doc(carId).delete();
    } catch (e) {
      throw Exception('Failed to delete car: $e');
    }
  }

  /* ------------------------- Image Upload Operations ------------------------- */

  Future<String> uploadCarImage(XFile imageFile) async {
    try {
      final ref = _storage
          .ref()
          .child('car_images/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putData(await imageFile.readAsBytes());
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload car image: $e');
    }
  }

  Future<String> uploadProfileImage(String userId, XFile imageFile) async {
    try {
      final ref = _storage.ref().child('profile_images/$userId');
      await ref.putData(await imageFile.readAsBytes());
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  /* ------------------------- Saved Cars Operations ------------------------- */

  Future<void> saveCarForUser(String userId, String carId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_cars')
          .doc(carId)
          .set({'savedAt': FieldValue.serverTimestamp()});
    } catch (e) {
      throw Exception('Failed to save car for user: $e');
    }
  }

  Future<void> removeSavedCar(String userId, String carId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_cars')
          .doc(carId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove saved car: $e');
    }
  }

  Stream<List<String>> getUserSavedCarIds(String userId) {
    try {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_cars')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
    } catch (e) {
      throw Exception('Failed to get saved car IDs: $e');
    }
  }

  /* ------------------------- Messaging Operations ------------------------- */

  Future<String> createChatRoom({
    required String carId,
    required String sellerId,
    required String buyerId,
  }) async {
    try {
      final chatId = '${buyerId}_${sellerId}_$carId';

      await _firestore.collection('chat_rooms').doc(chatId).set({
        'carId': carId,
        'sellerId': sellerId,
        'buyerId': buyerId,
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'participants': [sellerId, buyerId]
      });

      return chatId;
    } catch (e) {
      throw Exception('Failed to create chat room: $e');
    }
  }

  Stream<List<ChatRoom>> getUserChatRooms(String userId) {
    try {
      return _firestore
          .collection('chat_rooms')
          .where('participants', arrayContains: userId)
          .orderBy('lastMessageTime', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map(
                  (doc) => ChatRoom.fromMap(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      throw Exception('Failed to get chat rooms: $e');
    }
  }

  Stream<List<Message>> getChatMessages(String chatId) {
    try {
      return _firestore
          .collection('chat_rooms')
          .doc(chatId)
          .collection('messages')
          .orderBy('sentAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      throw Exception('Failed to get chat messages: $e');
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    try {
      final messageRef = _firestore
          .collection('chat_rooms')
          .doc(chatId)
          .collection('messages')
          .doc();

      final message = Message(
        id: messageRef.id,
        chatRoomId: chatId,
        senderId: senderId,
        text: text,
        sentAt: DateTime.now(),
      );

      await messageRef.set(message.toMap());

      // Update last message in chat room
      await _firestore.collection('chat_rooms').doc(chatId).update({
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}
