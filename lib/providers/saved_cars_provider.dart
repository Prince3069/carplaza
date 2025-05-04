import 'package:flutter/material.dart';

class SavedCarsProvider with ChangeNotifier {
  final List<String> _savedCars = [];

  List<String> get savedCars => _savedCars;

  void toggleCar(String carId) {
    if (_savedCars.contains(carId)) {
      _savedCars.remove(carId);
    } else {
      _savedCars.add(carId);
    }
    notifyListeners();
  }

  bool isCarSaved(String carId) {
    return _savedCars.contains(carId);
  }
}
