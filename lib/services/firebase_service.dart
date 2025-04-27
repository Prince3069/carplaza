import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car.dart';

class FirebaseService {
  final _carsCollection = FirebaseFirestore.instance.collection('cars');

  Future<List<Car>> getCars() async {
    final querySnapshot = await _carsCollection.get();
    return querySnapshot.docs
        .map((doc) => Car.fromFirebase(doc.data(), doc.id))
        .toList();
  }

  Future<void> uploadCar(Car car) async {
    await _carsCollection.add({
      'title': car.title,
      'imageUrl': car.imageUrl,
      'price': car.price,
      'location': car.location,
    });
  }
}
