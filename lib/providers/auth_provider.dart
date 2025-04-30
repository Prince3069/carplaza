import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:car_plaza/models/user_model.dart';
import 'package:car_plaza/services/firestore_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirestoreService _firestore = FirestoreService();

  UserModel? _user;
  User? _firebaseUser;
  bool _isLoading = false;

  UserModel? get user => _user;
  User? get firebaseUser => _firebaseUser;
  bool get isLoading => _isLoading;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  AuthProvider() {
    _setupAuthListener();
  }

  void _setupAuthListener() {
    _auth.authStateChanges().listen((User? user) async {
      _firebaseUser = user;
      if (user != null) {
        await _loadUserData(user.uid);
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      _isLoading = true;
      notifyListeners();

      _user = await _firestore.getUser(uid);

      if (_user == null && _firebaseUser != null) {
        // Create new user if doesn't exist
        _user = UserModel(
          uid: uid,
          email: _firebaseUser!.email ?? '',
          fullName: _firebaseUser!.displayName ?? 'New User',
          phone: _firebaseUser!.phoneNumber ?? '',
          createdAt: DateTime.now(),
          isSeller: false,
          profileImage: _firebaseUser!.photoURL ?? '',
        );
        await _firestore.createUser(_user!);
      }
    } catch (e) {
      debugPrint("Error loading user data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } catch (e) {
      debugPrint("Email sign in error: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        _user = UserModel(
          uid: credential.user!.uid,
          email: email,
          fullName: fullName,
          phone: phone,
          createdAt: DateTime.now(),
          isSeller: false,
          profileImage: '',
        );
        await _firestore.createUser(_user!);
      }

      return credential.user;
    } catch (e) {
      debugPrint("Email sign up error: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      debugPrint("Google sign in error: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      _user = null;
    } catch (e) {
      debugPrint("Sign out error: $e");
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint("Password reset error: $e");
      rethrow;
    }
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.updateUser(updatedUser);
      _user = updatedUser;
    } catch (e) {
      debugPrint("Update profile error: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
