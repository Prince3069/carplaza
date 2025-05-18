// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:car_plaza/widgets/responsive_layout.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: MessagesContent(),
      tabletBody: MessagesContent(),
      desktopBody: MessagesContent(),
    );
  }
}

class MessagesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.message, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Your Messages',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'No messages yet. When you have messages, they will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
