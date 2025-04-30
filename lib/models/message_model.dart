// MESSAGING SYSTEM MODELS
import 'package:car_plaza/models/user_model.dart';

class Message {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String text;
  final DateTime sentAt;
  final bool isRead;

  Message({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.text,
    required this.sentAt,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'text': text,
      'sentAt': sentAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      chatRoomId: map['chatRoomId'] ?? '',
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      sentAt: DateTime.parse(map['sentAt']),
      isRead: map['isRead'] ?? false,
    );
  }
}

class ChatRoom {
  final String id;
  final String carId;
  final String carName;
  final String carImage;
  final String buyerId;
  final String sellerId;
  final UserModel buyer;
  final UserModel seller;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;

  ChatRoom({
    required this.id,
    required this.carId,
    required this.carName,
    required this.carImage,
    required this.buyerId,
    required this.sellerId,
    required this.buyer,
    required this.seller,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'carId': carId,
      'carName': carName,
      'carImage': carImage,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'buyer': buyer.toMap(),
      'seller': seller.toMap(),
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'unreadCount': unreadCount,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] ?? '',
      carId: map['carId'] ?? '',
      carName: map['carName'] ?? '',
      carImage: map['carImage'] ?? '',
      buyerId: map['buyerId'] ?? '',
      sellerId: map['sellerId'] ?? '',
      buyer: UserModel.fromMap(map['buyer']),
      seller: UserModel.fromMap(map['seller']),
      lastMessage: map['lastMessage'],
      lastMessageTime: map['lastMessageTime'] != null
          ? DateTime.parse(map['lastMessageTime'])
          : null,
      unreadCount: map['unreadCount']?.toInt() ?? 0,
    );
  }
}
