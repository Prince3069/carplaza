// import 'package:car_plaza/models/message_model.dart';
// import 'package:car_plaza/models/user_model.dart';
// import 'package:car_plaza/services/firestore_service.dart';
// import 'package:car_plaza/widgets/shimmer_effect.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class MessagesScreen extends StatelessWidget {
//   const MessagesScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Messages'),
//       ),
//       body: StreamBuilder<List<MessageModel>>(
//         stream: Provider.of<FirestoreService>(context).getUserConversations(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return ListView.builder(
//               itemCount: 5,
//               itemBuilder: (_, index) => const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: ShimmerCard(height: 80),
//               ),
//             );
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text('No messages yet'),
//             );
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (_, index) {
//               final conversation = snapshot.data![index];
//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage: conversation.receiverPhotoUrl != null
//                       ? NetworkImage(conversation.receiverPhotoUrl!)
//                       : null,
//                   child: conversation.receiverPhotoUrl == null
//                       ? Text(conversation.receiverName[0])
//                       : null,
//                 ),
//                 title: Text(conversation.receiverName),
//                 subtitle: Text(
//                   conversation.lastMessage,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 trailing: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       _formatTime(conversation.timestamp),
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 12,
//                       ),
//                     ),
//                     if (conversation.unreadCount > 0)
//                       Container(
//                         padding: const EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).primaryColor,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Text(
//                           conversation.unreadCount.toString(),
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//                 onTap: () => Navigator.pushNamed(
//                   context,
//                   Routes.chat,
//                   arguments: {
//                     'receiverId': conversation.receiverId,
//                     'receiverName': conversation.receiverName,
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   String _formatTime(DateTime timestamp) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final yesterday = DateTime(now.year, now.month, now.day - 1);
//     final messageDate =
//         DateTime(timestamp.year, timestamp.month, timestamp.day);

//     if (messageDate == today) {
//       return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
//     } else if (messageDate == yesterday) {
//       return 'Yesterday';
//     } else {
//       return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
//     }
//   }
// }

// ignore_for_file: duplicate_import, unused_import

import 'package:car_plaza/models/message_model.dart';
import 'package:car_plaza/models/user_model.dart';
import 'package:car_plaza/services/firestore_service.dart';
import 'package:car_plaza/utils/routes.dart';
import 'package:car_plaza/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/models/conversation.dart';
// ... other imports
import 'package:car_plaza/models/conversation.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: StreamBuilder<List<Conversation>>(
        stream: Provider.of<FirestoreService>(context).getUserConversations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (_, index) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ShimmerCard(height: 80, width: double.infinity),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No conversations yet'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) {
              final conversation = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: conversation.otherUserPhotoUrl != null
                      ? NetworkImage(conversation.otherUserPhotoUrl!)
                      : null,
                  child: conversation.otherUserPhotoUrl == null
                      ? Text(conversation.otherUserName[0])
                      : null,
                ),
                title: Text(conversation.otherUserName),
                subtitle: Text(
                  conversation.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatTime(conversation.lastMessageTime),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    if (conversation.unreadCount > 0)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          conversation.unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.chat,
                  arguments: {
                    'receiverId': conversation.otherUserId,
                    'receiverName': conversation.otherUserName,
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate =
        DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
