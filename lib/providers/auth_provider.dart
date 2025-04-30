// AUTHENTICATION STATE MANAGEMENT
import 'package:car_plaza/models/payment_method_model.dart';
import 'package:car_plaza/models/user_model.dart';
import 'package:car_plaza/services/auth_service.dart';
import 'package:car_plaza/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _userData;
  User? _firebaseUser;

  UserModel? get userData => _userData;
  User? get firebaseUser => _firebaseUser;
  Stream<User?> get authState => _authService.authStateChanges;

  AuthProvider() {
    authState.listen((user) {
      _firebaseUser = user;
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData(String uid) async {
    _userData = await _firestoreService.getUserData(uid);
    notifyListeners();
  }

  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    try {
      User? user =
          await _authService.signUpWithEmailAndPassword(email, password);
      if (user != null) {
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          fullName: fullName,
          phone: phone,
          createdAt: DateTime.now(),
          isSeller: false,
          profileImage: '',
        );

        await _firestoreService.createUserData(newUser);
        _userData = newUser;
        notifyListeners();
      }
      return user;
    } catch (e) {
      debugPrint("Provider Sign Up Error: $e");
      return null;
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      User? user =
          await _authService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        await _loadUserData(user.uid);
      }
      return user;
    } catch (e) {
      debugPrint("Provider Sign In Error: $e");
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      User? user = await _authService.signInWithGoogle();
      if (user != null) {
        UserModel? existingUser = await _firestoreService.getUserData(user.uid);

        if (existingUser == null) {
          UserModel newUser = UserModel(
            uid: user.uid,
            email: user.email ?? '',
            fullName: user.displayName ?? '',
            phone: user.phoneNumber ?? '',
            createdAt: DateTime.now(),
            isSeller: false,
            profileImage: user.photoURL ?? '',
          );

          await _firestoreService.createUserData(newUser);
          _userData = newUser;
        } else {
          _userData = existingUser;
        }
        notifyListeners();
      }
      return user;
    } catch (e) {
      debugPrint("Provider Google Sign In Error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _userData = null;
    notifyListeners();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    if (_userData == null) return [];
    return await _firestoreService.getUserPaymentMethods(_userData!.uid);
  }

  Future<void> addPaymentMethod(PaymentMethod method) async {
    if (_userData == null) return;
    await _firestoreService.addPaymentMethod(
      userId: _userData!.uid,
      method: method,
    );
    notifyListeners();
  }

  Future<void> setDefaultPaymentMethod(String methodId) async {
    if (_userData == null) return;
    await _firestoreService.setDefaultPaymentMethod(
      userId: _userData!.uid,
      methodId: methodId,
    );
    notifyListeners();
  }

  // Future<String> uploadProfileImage(XFile imageFile) async {
  //   if (_userData == null) return '';

  //   // final imageUrl = await _firestoreService.uploadProfileImage(
  //   //   userId: _userData!.uid,
  //   //   imageFile: imageFile,
  //   // );

  //   // _userData = _userData!.copyWith(profileImage: imageUrl);
  //   // notifyListeners();

  //   // return imageUrl;
  // }

  Future<void> updateUserData(UserModel user) async {
    await _firestoreService.updateUserData(user);
    _userData = user;
    notifyListeners();
  }
}
