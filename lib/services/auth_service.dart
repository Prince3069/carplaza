// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class AuthService {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// //   // Create user with email/password and save profile
// //   Future<User?> registerWithEmailAndPassword(
// //     String email,
// //     String password,
// //     String name,
// //     String phone,
// //   ) async {
// //     try {
// //       // Create user
// //       UserCredential result = await _auth.createUserWithEmailAndPassword(
// //         email: email,
// //         password: password,
// //       );
// //       User? user = result.user;

// //       // Save user profile
// //       if (user != null) {
// //         await _firestore.collection('users').doc(user.uid).set({
// //           'name': name,
// //           'email': email,
// //           'phone': phone,
// //           'isVerifiedSeller': true,
// //           'createdAt': FieldValue.serverTimestamp(),
// //         });
// //       }

// //       return user;
// //     } catch (e) {
// //       print("Error during registration: $e");
// //       return null;
// //     }
// //   }

// //   // Sign in with email/password
// //   Future<User?> signInWithEmailAndPassword(
// //       String email, String password) async {
// //     try {
// //       UserCredential result = await _auth.signInWithEmailAndPassword(
// //         email: email,
// //         password: password,
// //       );
// //       return result.user;
// //     } catch (e) {
// //       print("Error during sign in: $e");
// //       return null;
// //     }
// //   }

// //   // Sign out
// //   Future signOut() async {
// //     try {
// //       return await _auth.signOut();
// //     } catch (e) {
// //       print("Error signing out: $e");
// //       return null;
// //     }
// //   }

// //   // Auth state stream
// //   Stream<User?> get user {
// //     return _auth.authStateChanges();
// //   }
// // }

// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class AuthService {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// //   // Get the current user (nullable)
// //   User? get currentUser => _auth.currentUser;

// //   // Auth state stream
// //   Stream<User?> get user {
// //     return _auth.authStateChanges();
// //   }

// //   // Register new user with profile data
// //   Future<User?> registerWithProfile({
// //     required String email,
// //     required String password,
// //     required String name,
// //     required String phone,
// //   }) async {
// //     try {
// //       // 1. Create user account
// //       UserCredential credential = await _auth.createUserWithEmailAndPassword(
// //         email: email,
// //         password: password,
// //       );

// //       // 2. Save profile data
// //       await _firestore.collection('users').doc(credential.user!.uid).set({
// //         'name': name,
// //         'email': email,
// //         'phone': phone,
// //         'isVerifiedSeller': true,
// //         'createdAt': FieldValue.serverTimestamp(),
// //         'updatedAt': FieldValue.serverTimestamp(),
// //       });

// //       return credential.user;
// //     } on FirebaseAuthException catch (e) {
// //       print("Firebase Auth Error during registration: ${e.message}");
// //       rethrow; // Re-throw to handle in UI
// //     } catch (e) {
// //       print("General error during registration: $e");
// //       rethrow;
// //     }
// //   }

// //   // Update existing user profile
// //   Future<void> updateProfile({
// //     required String userId,
// //     required String name,
// //     required String phone,
// //   }) async {
// //     try {
// //       await _firestore.collection('users').doc(userId).update({
// //         'name': name,
// //         'phone': phone,
// //         'isVerifiedSeller': true, // Ensure they stay verified
// //         'updatedAt': FieldValue.serverTimestamp(),
// //       });
// //     } catch (e) {
// //       print("Error updating profile: $e");
// //       rethrow;
// //     }
// //   }

// //   // Sign in existing user
// //   Future<User?> signIn(String email, String password) async {
// //     try {
// //       UserCredential result = await _auth.signInWithEmailAndPassword(
// //         email: email,
// //         password: password,
// //       );
// //       return result.user;
// //     } on FirebaseAuthException catch (e) {
// //       print("Firebase Auth Error during sign in: ${e.message}");
// //       rethrow;
// //     } catch (e) {
// //       print("General error during sign in: $e");
// //       rethrow;
// //     }
// //   }

// //   // Sign out
// //   Future<void> signOut() async {
// //     try {
// //       await _auth.signOut();
// //     } catch (e) {
// //       print("Error signing out: $e");
// //       rethrow;
// //     }
// //   }

// // ignore_for_file: avoid_print

// //   // Optional: Password reset
// //   Future<void> sendPasswordResetEmail(String email) async {
// //     try {
// //       await _auth.sendPasswordResetEmail(email: email);
// //     } catch (e) {
// //       print("Error sending password reset email: $e");
// //       rethrow;
// //     }
// //   }
// // }
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Add the missing currentUser getter
//   User? get currentUser => _auth.currentUser;

//   // Add the missing signOut method
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }

//   // Add the missing updateProfile method
//   Future<void> updateProfile({
//     required String userId,
//     required String name,
//     required String phone,
//   }) async {
//     await _firestore.collection('users').doc(userId).update({
//       'name': name,
//       'phone': phone,
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   // Existing registerWithProfile method
//   Future<User?> registerWithProfile({
//     required String email,
//     required String password,
//     required String name,
//     required String phone,
//   }) async {
//     try {
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       await _firestore.collection('users').doc(credential.user!.uid).set({
//         'name': name,
//         'email': email,
//         'phone': phone,
//         'isVerifiedSeller': true,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       return credential.user;
//     } catch (e) {
//       print("Registration error: $e");
//       return null;
//     }
//   }
// }
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   User? get currentUser => _auth.currentUser;
//   Stream<User?> get user => _auth.authStateChanges();

//   // Add this method to check admin status
//   Future<bool> isAdmin() async {
//     if (currentUser == null) return false;
//     try {
//       DocumentSnapshot doc =
//           await _firestore.collection('users').doc(currentUser!.uid).get();
//       return doc.data()?['isAdmin'] == true;
//     } catch (e) {
//       print('Error checking admin status: $e');
//       return false;
//     }
//   }

//   // Add this method to verify sellers
//   Future<void> verifySeller(String userId) async {
//     try {
//       await _firestore.collection('users').doc(userId).update({
//         'isVerifiedSeller': true,
//         'verifiedAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print('Error verifying seller: $e');
//       rethrow;
//     }
//   }

//   Future<User?> registerWithEmailAndPassword({
//     required String email,
//     required String password,
//     required String name,
//     required String phone,
//     bool isAdmin = false,
//     bool isVerifiedSeller = false,
//   }) async {
//     try {
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       await _firestore.collection('users').doc(credential.user!.uid).set({
//         'name': name,
//         'email': email,
//         'phone': phone,
//         'isVerifiedSeller': isVerifiedSeller,
//         'isAdmin': isAdmin,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       return credential.user;
//     } catch (e) {
//       print("Registration error: $e");
//       return null;
//     }
//   }

//   Future<User?> signInWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       UserCredential result = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return result.user;
//     } catch (e) {
//       print("Sign in error: $e");
//       return null;
//     }
//   }

//   Future<void> signOut() async {
//     await _auth.signOut();
//   }

//   Future<void> updateProfile({
//     required String userId,
//     required String name,
//     required String phone,
//   }) async {
//     try {
//       await _firestore.collection('users').doc(userId).update({
//         'name': name,
//         'phone': phone,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print("Error updating profile: $e");
//       rethrow;
//     }
//   }

//   Future<Map<String, dynamic>?> getUserData(String userId) async {
//     try {
//       DocumentSnapshot doc =
//           await _firestore.collection('users').doc(userId).get();
//       return doc.data() as Map<String, dynamic>?;
//     } catch (e) {
//       print("Error getting user data: $e");
//       return null;
//     }
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   User? get currentUser => _auth.currentUser;
//   Stream<User?> get user => _auth.authStateChanges();

//   Future<bool> isAdmin() async {
//     if (currentUser == null) return false;
//     try {
//       DocumentSnapshot doc =
//           await _firestore.collection('users').doc(currentUser!.uid).get();
//       final data = doc.data();
//       if (data != null && data is Map<String, dynamic>) {
//         return data['isAdmin'] == true;
//       }
//       return false;
//     } catch (e) {
//       print('Error checking admin status: $e');
//       return false;
//     }
//   }

//   Future<void> verifySeller(String userId) async {
//     try {
//       await _firestore.collection('users').doc(userId).update({
//         'isVerifiedSeller': true,
//         'verifiedAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print('Error verifying seller: $e');
//       rethrow;
//     }
//   }

//   Future<Map<String, dynamic>?> getUserData(String userId) async {
//     try {
//       DocumentSnapshot doc =
//           await _firestore.collection('users').doc(userId).get();
//       return doc.data() as Map<String, dynamic>?;
//     } catch (e) {
//       print("Error getting user data: $e");
//       return null;
//     }
//   }

//   Future<void> updateProfile({
//     required String userId,
//     required String name,
//     required String phone,
//   }) async {
//     try {
//       await _firestore.collection('users').doc(userId).update({
//         'name': name,
//         'phone': phone,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print("Error updating profile: $e");
//       rethrow;
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get user => _auth.authStateChanges();

  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    bool isAdmin = false,
    bool isVerifiedSeller = false,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'isVerifiedSeller': isVerifiedSeller,
        'isAdmin': isAdmin,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> isAdmin() async {
    if (currentUser == null) return false;
    final doc =
        await _firestore.collection('users').doc(currentUser!.uid).get();
    return doc.data()?['isAdmin'] == true;
  }

  Future<void> verifySeller(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'isVerifiedSeller': true,
      'verifiedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data();
  }

  Future<void> updateProfile({
    required String userId,
    required String name,
    required String phone,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'name': name,
        'phone': phone,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw FirebaseException(
        plugin: 'updateProfile',
        code: e.code,
        message: 'Failed to update profile: ${e.message}',
      );
    }
  }
}
