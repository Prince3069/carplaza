// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSetupScreen extends StatelessWidget {
  const AdminSetupScreen({super.key});

  Future<void> _setupAdmin() async {
    try {
      // Replace with your admin credentials
      const email = 'Princenwanozie6666@gmail.com';
      const password = 'Prince6666';

      // Create auth user
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Set admin privileges
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'email': email,
        'isAdmin': true,
        'isVerifiedSeller': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Admin setup complete!');
    } catch (e) {
      print('Error setting up admin: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Setup')),
      body: Center(
        child: ElevatedButton(
          onPressed: _setupAdmin,
          child: const Text('Setup Admin Account'),
        ),
      ),
    );
  }
}
