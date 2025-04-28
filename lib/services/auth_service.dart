import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fixed getter to properly return current user
  User? get currentUser => _auth.currentUser;

  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners(); // Notify listeners when user changes
      return result.user;
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners(); // Notify listeners when user changes
      return result.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners(); // Notify listeners when user signs out
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
