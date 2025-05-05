import 'package:car_plaza/models/user_model.dart';
import 'package:car_plaza/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  UserModel? _user;
  bool _isLoading = false;

  AuthProvider(this._authService);

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _user = await _authService.getCurrentUser();
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authService.signInWithEmailAndPassword(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authService.registerWithEmailAndPassword(
          name, email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
