// =================== lib/screens/messages/messages_screen.dart ===================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/message_service.dart';
import '../../widgets/bottom_nav_bar.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final MessageService _messageService = MessageService();
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _messageController = TextEditingController();

  int _currentIndex = 3;

  String? _selectedChatId; // ID of the chat
  String? _otherUserId; // Target seller or buyer

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedChatId == null ? 'Your Chats' : 'Chatting'),
        centerTitle: true,
        leading: _selectedChatId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedChatId = null;
                  });
                },
              )
            : null,
      ),
      body: _selectedChatId == null
          ? _buildChatsList()
          : _buildChatRoom(_selectedChatId!),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
        Navigator.pushNamed(context, '/search');
        break;
      case 2:
        Navigator.pushNamed(context, '/sell');
        break;
      case 3:
        break; // Already on Messages
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  Widget _buildChatsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .where('participants', arrayContains: user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        var chats = snapshot.data!.docs;
        if (chats.isEmpty) {
          return const Center(child: Text('No conversations'));
        }

        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            var chatId = chats[index].id;
            return ListTile(
              title: Text('Chat Room'),
              subtitle: Text(chatId),
              onTap: () {
                setState(() {
                  _selectedChatId = chatId;
                });
              },
            );
          },
        );
      },
    );
  }

  Widget _buildChatRoom(String chatId) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _messageService.getMessages(chatId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              var messages = snapshot.data!.docs;
              return ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var message = messages[index];
                  bool isMe = message['senderId'] == user!.uid;
                  return ListTile(
                    title: Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(
                              color: isMe ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration:
                      const InputDecoration(hintText: 'Type a message...'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_messageController.text.trim().isNotEmpty) {
                    _messageService.sendMessage(
                      chatId,
                      user!.uid,
                      _messageController.text.trim(),
                    );
                    _messageController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================
