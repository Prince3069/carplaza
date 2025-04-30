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
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists
        ? UserModel.fromMap(doc.data() as Map<String, dynamic>)
        : null;
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
  }

  /* ---------------------------- Car Operations ---------------------------- */

  Stream<List<CarModel>> getCarsStream({bool featuredOnly = false}) {
    Query query =
        _firestore.collection('cars').orderBy('createdAt', descending: true);

    if (featuredOnly) {
      query = query.where('isFeatured', isEqualTo: true);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => CarModel.fromMap(doc.data())).toList());
  }

  Future<List<CarModel>> searchCars(String query) async {
    final snapshot = await _firestore
        .collection('cars')
        .where('make', isGreaterThanOrEqualTo: query)
        .where('make', isLessThan: query + 'z')
        .get();

    return snapshot.docs.map((doc) => CarModel.fromMap(doc.data())).toList();
  }

  Future<String> addCar(CarModel car) async {
    final docRef = await _firestore.collection('cars').add(car.toMap());
    return docRef.id;
  }

  Future<void> updateCar(CarModel car) async {
    await _firestore.collection('cars').doc(car.id).update(car.toMap());
  }

  Future<void> deleteCar(String carId) async {
    await _firestore.collection('cars').doc(carId).delete();
  }

  /* ------------------------- Image Upload Operations ------------------------- */

  Future<String> uploadCarImage(XFile imageFile) async {
    final ref = _storage
        .ref()
        .child('car_images/${DateTime.now().millisecondsSinceEpoch}');
    await ref.putData(await imageFile.readAsBytes());
    return await ref.getDownloadURL();
  }

  Future<String> uploadProfileImage(String userId, XFile imageFile) async {
    final ref = _storage.ref().child('profile_images/$userId');
    await ref.putData(await imageFile.readAsBytes());
    return await ref.getDownloadURL();
  }

  /* ------------------------- Saved Cars Operations ------------------------- */

  Future<void> saveCarForUser(String userId, String carId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_cars')
        .doc(carId)
        .set({'savedAt': FieldValue.serverTimestamp()});
  }

  Future<void> removeSavedCar(String userId, String carId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_cars')
        .doc(carId)
        .delete();
  }

  Stream<List<String>> getUserSavedCarIds(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_cars')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  /* ------------------------- Messaging Operations ------------------------- */

  Future<String> createChatRoom({
    required String carId,
    required String sellerId,
    required String buyerId,
  }) async {
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
  }

  Stream<List<ChatRoom>> getUserChatRooms(String userId) {
    return _firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatRoom.fromMap(doc.data())).toList());
  }

  Stream<List<Message>> getChatMessages(String chatId) {
    return _firestore
        .collection('chat_rooms')
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList());
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
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
  }
}
