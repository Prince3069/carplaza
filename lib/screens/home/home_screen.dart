import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            const ListTile(
              title: Text('Car 1'),
              subtitle: Text('Details of car 1'),
            ),
            const ListTile(
              title: Text('Car 2'),
              subtitle: Text('Details of car 2'),
            ),
            const ListTile(
              title: Text('Car 3'),
              subtitle: Text('Details of car 3'),
            ),
            // Add more car listings as needed
          ],
        ),
      ),
    );
  }
}
