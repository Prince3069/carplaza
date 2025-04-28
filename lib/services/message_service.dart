// =================== lib/services/message_service.dart ===================

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send a message
  Future<void> sendMessage(String chatId, String senderId, String text) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'text': text,
      'timestamp': Timestamp.now(),
    });
  }

  // Listen for new messages
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Create chat room
  Future<void> createChat(String chatId, List<String> participantIds) async {
    await _firestore.collection('chats').doc(chatId).set({
      'participants': participantIds,
      'createdAt': Timestamp.now(),
    });
  }
}

// =============================================================
