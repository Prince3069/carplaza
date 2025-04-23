// File: lib/screens/messages_screen.dart
import 'package:flutter/material.dart';
import 'package:car_plaza/widgets/message_list_item.dart';
import 'package:car_plaza/models/message.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for messages
    final List<Message> messages = List.generate(
      10,
      (index) => Message(
        id: 'message_$index',
        senderId: 'user_$index',
        senderName: 'User ${index + 1}',
        senderAvatar: 'https://via.placeholder.com/50',
        lastMessage: 'Is this car still available?',
        timestamp: DateTime.now().subtract(Duration(hours: index)),
        unread: index < 3,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: messages.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.message, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'When you contact sellers or buyers,\nthey will appear here',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return MessageListItem(
                  message: messages[index],
                  onTap: () {
                    // Navigate to chat detail
                  },
                );
              },
            ),
    );
  }
}
