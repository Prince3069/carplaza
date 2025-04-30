// lib/screens/sell/sell_screen.dart
import 'package:flutter/material.dart';
import 'package:car_plaza/widgets/custom_button.dart';

class SellScreen extends StatelessWidget {
  const SellScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Your Car'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Icon(
              Icons.directions_car,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 30),
            const Text(
              'Ready to sell your car?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'List your car for sale and reach thousands of potential buyers.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Upload New Car',
              onPressed: () {
                Navigator.pushNamed(context, '/upload-car');
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Manage My Listings',
              onPressed: () {
                Navigator.pushNamed(context, '/manage-listings');
              },
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
