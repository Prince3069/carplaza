// File: lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_plaza/models/user.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // For demo/testing purposes - temporary user simulation
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<void> signIn(String email, String password) async {
    try {
      // For testing purposes, we'll simulate successful authentication
      if (email == 'test@example.com' && password == 'password') {
        // In a real app, you would use:
        // await _auth.signInWithEmailAndPassword(email: email, password: password);
        // For now, we'll just simulate a delay
        await Future.delayed(const Duration(seconds: 1));
        notifyListeners();
        return;
      }

      // For real implementation:
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  // Sign up with email and password
  Future<void> signUp(String email, String password, String name) async {
    try {
      // For testing purposes, we'll simulate successful registration
      if (true) {
        // In a real app, you would use:
        // final userCredential = await _auth.createUserWithEmailAndPassword(
        //   email: email,
        //   password: password,
        // );
        // await _createUserInFirestore(userCredential.user!.uid, name, email);

        // For now, we'll just simulate a delay
        await Future.delayed(const Duration(seconds: 1));
        notifyListeners();
        return;
      }

      // For real implementation:
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _createUserInFirestore(userCredential.user!.uid, name, email);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  // Create user document in Firestore
  Future<void> _createUserInFirestore(
      String uid, String name, String email) async {
    final userModel = UserModel(
      id: uid,
      name: name,
      email: email,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(uid).set(userModel.toMap());
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Check if user exists in Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        await _createUserInFirestore(
          user.uid,
          user.displayName ?? 'User',
          user.email ?? '',
        );
      }

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}
