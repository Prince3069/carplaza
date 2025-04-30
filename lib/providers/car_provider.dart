// CAR LISTINGS STATE MANAGEMENT
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/services/firestore_service.dart';
import 'package:flutter/foundation.dart';

class CarProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<CarModel> _featuredCars = [];
  List<CarModel> _recentCars = [];
  List<CarModel> _searchResults = [];
  bool _isLoading = false;

  List<CarModel> get featuredCars => _featuredCars;
  List<CarModel> get recentCars => _recentCars;
  List<CarModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  Future<void> loadFeaturedCars() async {
    _isLoading = true;
    notifyListeners();

    try {
      // For development, use mock data
      _featuredCars = [
        CarModel(
          id: '1',
          sellerId: 'seller1',
          make: 'Toyota',
          model: 'Camry',
          year: 2020,
          price: 6500000,
          description: 'Excellent condition, low mileage',
          images: ['assets/placeholder_car.jpg'],
          location: 'Lagos, Nigeria',
          createdAt: DateTime.now(),
          isFeatured: true,
          condition: 'Foreign Used',
          mileage: 25000,
          transmission: 'Automatic',
          fuelType: 'Petrol',
          color: 'Silver',
        ),
        // Add more mock cars as needed
      ];
    } catch (e) {
      debugPrint("Error loading featured cars: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRecentCars() async {
    _isLoading = true;
    notifyListeners();

    try {
      // For development, use mock data
      _recentCars = [
        CarModel(
          id: '2',
          sellerId: 'seller2',
          make: 'Honda',
          model: 'Accord',
          year: 2019,
          price: 5500000,
          description: 'Well maintained, clean interior',
          images: ['assets/placeholder_car.jpg'],
          location: 'Abuja, Nigeria',
          createdAt: DateTime.now(),
          isFeatured: false,
          condition: 'Used',
          mileage: 45000,
          transmission: 'Automatic',
          fuelType: 'Petrol',
          color: 'Black',
        ),
        // Add more mock cars as needed
      ];
    } catch (e) {
      debugPrint("Error loading recent cars: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<CarModel>> searchCars(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      // For development, filter mock data
      _searchResults = _recentCars
          .where((car) =>
              car.make.toLowerCase().contains(query.toLowerCase()) ||
              car.model.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return _searchResults;
    } catch (e) {
      debugPrint("Error searching cars: $e");
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCar(CarModel car) async {
    _isLoading = true;
    notifyListeners();

    try {
      // In production, add to Firestore
      // await _firestoreService.addCar(car);

      // For development, add to local list
      _recentCars.insert(0, car);
    } catch (e) {
      debugPrint("Error adding car: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<CarModel>> getSavedCars(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // For development, return subset of recent cars
      return _recentCars.take(3).toList();
    } catch (e) {
      debugPrint("Error getting saved cars: $e");
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeSavedCar(
      {required String userId, required String carId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      // In production, remove from Firestore
      // await _firestoreService.removeSavedCar(...);

      // For development, just notify
      debugPrint("Car $carId removed from favorites");
    } catch (e) {
      debugPrint("Error removing saved car: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
