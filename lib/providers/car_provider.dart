import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:car_plaza/services/firebase_service.dart';
import 'package:car_plaza/models/car_model.dart';

class CarProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final ImagePicker _imagePicker = ImagePicker();

  List<Car> _featuredCars = [];
  List<Car> _recentCars = [];
  List<Car> _filteredCars = [];
  List<XFile> _carImages = [];
  bool _isLoading = false;
  bool _isUploading = false;

  List<Car> get featuredCars => _featuredCars;
  List<Car> get recentCars => _recentCars;
  List<Car> get filteredCars => _filteredCars;
  List<Uint8List> get carImages =>
      _carImages.map((file) => file.readAsBytesSync()).toList();
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;

  Future<void> fetchFeaturedCars() async {
    _isLoading = true;
    notifyListeners();
    try {
      _featuredCars = await _firebaseService.fetchFeaturedCars();
    } catch (e) {
      debugPrint('Error fetching featured cars: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRecentCars() async {
    _isLoading = true;
    notifyListeners();
    try {
      _recentCars = await _firebaseService.fetchRecentCars();
      _filteredCars = _recentCars;
    } catch (e) {
      debugPrint('Error fetching recent cars: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchCars(String query) async {
    if (query.isEmpty) {
      _filteredCars = _recentCars;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();
    try {
      _filteredCars = await _firebaseService.searchCars(query);
    } catch (e) {
      debugPrint('Error searching cars: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickImages() async {
    try {
      final pickedFiles = await _imagePicker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFiles != null) {
        _carImages.addAll(pickedFiles);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    }
  }

  void removeImage(Uint8List image) {
    _carImages.removeWhere((file) => file.readAsBytesSync() == image);
    notifyListeners();
  }

  Future<void> uploadCar({
    required String title,
    required String description,
    required double price,
    required String brand,
    required String model,
    required int year,
    required String location,
  }) async {
    _isUploading = true;
    notifyListeners();

    try {
      // Upload images first
      final imageUrls = <String>[];
      for (final image in _carImages) {
        final url = await _firebaseService.uploadImage(
          '${DateTime.now().millisecondsSinceEpoch}_${image.name}',
          await image.readAsBytes(),
        );
        imageUrls.add(url);
      }

      // Then upload car data
      await _firebaseService.uploadCar(
        title: title,
        description: description,
        price: price,
        brand: brand,
        model: model,
        year: year,
        location: location,
        imageUrls: imageUrls,
      );

      // Clear form after successful upload
      _carImages.clear();
    } catch (e) {
      debugPrint('Error uploading car: $e');
      rethrow;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
