// // ignore_for_file: unused_import

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:car_plaza/models/user_model.dart';
// import 'package:car_plaza/services/firestore_service.dart';
// import 'package:car_plaza/utils/constants.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirestoreService _firestoreService = FirestoreService();
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Future<UserModel?> getCurrentUser() async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       return await _firestoreService.getUser(user.uid);
//     }
//     return null;
//   }

//   Future<UserModel?> signInWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       final userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return await _firestoreService.getUser(userCredential.user!.uid);
//     } on FirebaseAuthException catch (e) {
//       throw _handleAuthError(e);
//     }
//   }

//   Future<UserModel?> registerWithEmailAndPassword(
//       String name, String email, String password) async {
//     try {
//       final userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       final user = UserModel(
//         id: userCredential.user!.uid,
//         name: name,
//         email: email,
//         joinedAt: DateTime.now(),
//         isSeller: false,
//       );

//       await _firestoreService.addUser(user);
//       return user;
//     } on FirebaseAuthException catch (e) {
//       throw _handleAuthError(e);
//     }
//   }

//   Future<UserModel?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) return null;

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final userCredential = await _auth.signInWithCredential(credential);
//       final user = userCredential.user;
//       if (user == null) return null;

//       var existingUser = await _firestoreService.getUser(user.uid);
//       if (existingUser != null) return existingUser;

//       final newUser = UserModel(
//         id: user.uid,
//         name: user.displayName ?? 'User',
//         email: user.email ?? '',
//         photoUrl: user.photoURL,
//         joinedAt: DateTime.now(),
//         isSeller: false,
//       );

//       await _firestoreService.addUser(newUser);
//       return newUser;
//     } catch (e) {
//       throw Exception('Google sign in failed: $e');
//     }
//   }

//   Future<void> signOut() async {
//     await _auth.signOut();
//     await _googleSignIn.signOut();
//   }

//   Future<void> resetPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//     } on FirebaseAuthException catch (e) {
//       throw _handleAuthError(e);
//     }
//   }

//   String _handleAuthError(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'invalid-email':
//         return 'The email address is invalid.';
//       case 'user-disabled':
//         return 'This user has been disabled.';
//       case 'user-not-found':
//         return 'No user found with this email.';
//       case 'wrong-password':
//         return 'Wrong password provided.';
//       case 'email-already-in-use':
//         return 'The email address is already in use.';
//       case 'operation-not-allowed':
//         return 'Email/password accounts are not enabled.';
//       case 'weak-password':
//         return 'The password is too weak.';
//       default:
//         return 'An error occurred. Please try again.';
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:car_plaza/models/user_model.dart';
import 'package:car_plaza/services/firestore_service.dart';
import 'package:car_plaza/utils/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await _firestoreService.getUser(user.uid);
    }
    return null;
  }

  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await _firestoreService.getUser(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<UserModel?> registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        joinedAt: DateTime.now(),
        isSeller: false,
      );

      await _firestoreService.addUser(user);
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) return null;

      var existingUser = await _firestoreService.getUser(user.uid);
      if (existingUser != null) return existingUser;

      final newUser = UserModel(
        id: user.uid,
        name: user.displayName ?? 'User',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        joinedAt: DateTime.now(),
        isSeller: false,
      );

      await _firestoreService.addUser(newUser);
      return newUser;
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The email address is already in use.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
