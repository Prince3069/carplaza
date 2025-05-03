import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool read;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.read = false,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    return MessageModel(
      id: id,
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      read: map['read'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp,
      'read': read,
    };
  }

  // For conversation list items
  factory MessageModel.forConversation({
    required String id,
    required String receiverId,
    required String receiverName,
    required String lastMessage,
    required DateTime lastMessageTime,
    required int unreadCount,
    String? receiverPhotoUrl,
  }) {
    return MessageModel(
      id: id,
      senderId: '',
      receiverId: receiverId,
      text: lastMessage,
      timestamp: lastMessageTime,
      read: unreadCount == 0,
    );
  }
}
