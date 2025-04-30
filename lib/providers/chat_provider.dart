// CHAT SYSTEM STATE MANAGEMENT
import 'package:car_plaza/models/message_model.dart';
import 'package:car_plaza/services/firestore_service.dart';
import 'package:flutter/foundation.dart';

class ChatProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<ChatRoom> _chatRooms = [];
  List<Message> _messages = [];
  bool _isLoading = false;

  List<ChatRoom> get chatRooms => _chatRooms;
  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;

  // For development - set mock chat rooms
  void setMockChatRooms(List<ChatRoom> mockRooms) {
    _chatRooms = mockRooms;
    notifyListeners();
  }

  Future<void> loadChatRooms(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // In production, load from Firestore
      // _chatRooms = await _firestoreService.getUserChatRooms(userId);
    } catch (e) {
      debugPrint("Error loading chat rooms: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMessages(String chatRoomId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // In production, load from Firestore
      // _messages = await _firestoreService.getChatMessages(chatRoomId);

      // For development, use mock messages
      _messages = [
        Message(
          id: '1',
          chatRoomId: chatRoomId,
          senderId: 'seller1',
          text: 'Hello, is this car still available?',
          sentAt: DateTime.now().subtract(Duration(minutes: 30)),
          isRead: true,
        ),
        Message(
          id: '2',
          chatRoomId: chatRoomId,
          senderId: 'buyer1',
          text: 'Yes, it is available. Are you interested?',
          sentAt: DateTime.now().subtract(Duration(minutes: 25)),
          isRead: true,
        ),
      ];
    } catch (e) {
      debugPrint("Error loading messages: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startChat({
    required String sellerId,
    required String carId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // In production, create in Firestore
      // await _firestoreService.createChatRoom(...);

      // For development, just notify
      debugPrint("Chat started with seller $sellerId about car $carId");
    } catch (e) {
      debugPrint("Error starting chat: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String text,
  }) async {
    try {
      // In production, send to Firestore
      // await _firestoreService.sendMessage(...);

      // For development, add to local list
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatRoomId: chatRoomId,
        senderId: senderId,
        text: text,
        sentAt: DateTime.now(),
      );

      _messages.insert(0, newMessage);
      notifyListeners();
    } catch (e) {
      debugPrint("Error sending message: $e");
      rethrow;
    }
  }
}
