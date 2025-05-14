// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:car_plaza/utils/responsive.dart';
import 'package:car_plaza/widgets/adaptive/app_navigation.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final List<Map<String, dynamic>> _conversations = [
    {
      'id': '1',
      'user': 'John Doe',
      'avatar': 'https://i.imgur.com/Q6qBQ9J.png',
      'lastMessage': 'Is the car still available?',
      'time': '10:30 AM',
      'unread': true,
    },
    {
      'id': '2',
      'user': 'Jane Smith',
      'avatar': 'https://i.imgur.com/Q6qBQ9J.png',
      'lastMessage': 'I can offer ₦4,500,000',
      'time': 'Yesterday',
      'unread': false,
    },
    {
      'id': '3',
      'user': 'Mike Johnson',
      'avatar': 'https://i.imgur.com/Q6qBQ9J.png',
      'lastMessage': 'When can I come for inspection?',
      'time': '2 days ago',
      'unread': false,
    },
  ];

  int _selectedIndex = 3; // Messages tab index
  int _selectedConversationIndex = -1;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final isDesktop = responsive.isDesktop;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Row(
        children: [
          if (isDesktop)
            AppNavigation(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) {
                setState(() => _selectedIndex = index);
                // Handle navigation
              },
            ),
          Expanded(
            child: Row(
              children: [
                // Conversation list
                Container(
                  width: isDesktop ? 350 : double.infinity,
                  decoration: BoxDecoration(
                    border: isDesktop
                        ? const Border(
                            right: BorderSide(color: Colors.grey, width: 0.5),
                          )
                        : null,
                  ),
                  child: ListView.builder(
                    itemCount: _conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = _conversations[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(conversation['avatar']),
                        ),
                        title: Text(conversation['user']),
                        subtitle: Text(conversation['lastMessage']),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(conversation['time']),
                            if (conversation['unread'])
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        onTap: () {
                          setState(() => _selectedConversationIndex = index);
                          if (!isDesktop) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConversationDetailScreen(
                                  conversation: conversation,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                // Conversation detail (desktop only)
                if (isDesktop && _selectedConversationIndex != -1)
                  Expanded(
                    child: ConversationDetailScreen(
                      conversation: _conversations[_selectedConversationIndex],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: !isDesktop
          ? AppNavigation(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) {
                setState(() => _selectedIndex = index);
                // Handle navigation
              },
            )
          : null,
    );
  }
}

class ConversationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> conversation;

  const ConversationDetailScreen({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final isDesktop = responsive.isDesktop;

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: Text(conversation['user']),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMessage(
                  isMe: false,
                  message: 'Hello, is this car still available?',
                  time: '10:30 AM',
                ),
                _buildMessage(
                  isMe: true,
                  message: 'Yes, it is. Are you interested?',
                  time: '10:32 AM',
                ),
                _buildMessage(
                  isMe: false,
                  message: 'Yes, can I come for inspection tomorrow?',
                  time: '10:33 AM',
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(
      {required bool isMe, required String message, required String time}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
