import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/services/firestore_service.dart';
import 'package:flutter/material.dart';

class CarProvider with ChangeNotifier {
  final FirestoreService _firestoreService;
  List<CarModel> _featuredCars = [];
  List<CarModel> _latestCars = [];
  bool _isLoading = false;

  CarProvider(this._firestoreService);

  List<CarModel> get featuredCars => _featuredCars;
  List<CarModel> get latestCars => _latestCars;
  bool get isLoading => _isLoading;

  Future<void> loadFeaturedCars() async {
    _isLoading = true;
    notifyListeners();

    try {
      _featuredCars = await _firestoreService.getFeaturedCars().first;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadLatestCars() async {
    _isLoading = true;
    notifyListeners();

    try {
      _latestCars = await _firestoreService.getLatestCars().first;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
