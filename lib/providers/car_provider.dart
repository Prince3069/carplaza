import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/services/firestore_service.dart';

class CarProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<CarModel> _cars = [];
  List<CarModel> _featuredCars = [];
  bool _isLoading = false;

  List<CarModel> get cars => _cars;
  List<CarModel> get featuredCars => _featuredCars;
  bool get isLoading => _isLoading;

  Future<void> loadCars() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Load regular cars
      _cars = await _firestoreService.getCars();

      // Load featured cars
      _featuredCars = await _firestoreService.getFeaturedCars();
    } catch (e) {
      debugPrint('Error loading cars: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCar(CarModel car) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestoreService.addCar(car);
      await loadCars(); // Refresh the list
    } catch (e) {
      debugPrint('Error adding car: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<CarModel>> searchCars(String query) async {
    try {
      return await _firestoreService.searchCars(query);
    } catch (e) {
      debugPrint('Error searching cars: $e');
      rethrow;
    }
  }
}
