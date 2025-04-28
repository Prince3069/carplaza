// =================== lib/services/car_service.dart ===================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/car.dart';

class CarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload car data + media (images & video)
  Future<void> uploadCar({
    required Car car,
    required List<File> images,
    required File? video,
  }) async {
    List<String> imageUrls = [];

    // Upload each image
    for (File image in images) {
      String fileName =
          'cars/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
      UploadTask uploadTask = _storage.ref(fileName).putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }

    // Upload video
    String videoUrl = '';
    if (video != null) {
      String videoName =
          'videos/${DateTime.now().millisecondsSinceEpoch}_${video.path.split('/').last}';
      UploadTask uploadTask = _storage.ref(videoName).putFile(video);
      TaskSnapshot snapshot = await uploadTask;
      videoUrl = await snapshot.ref.getDownloadURL();
    }

    // Create final car object
    Car newCar = Car(
      id: '',
      title: car.title,
      description: car.description,
      price: car.price,
      make: car.make,
      model: car.model,
      year: car.year,
      mileage: car.mileage,
      imageUrls: imageUrls,
      videoUrl: videoUrl,
      sellerId: car.sellerId,
      postedAt: Timestamp.now(),
    );

    await _firestore.collection('cars').add(newCar.toMap());
  }

  // Fetch all cars
  Future<List<Car>> fetchCars() async {
    QuerySnapshot snapshot = await _firestore
        .collection('cars')
        .orderBy('postedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Car.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Search cars (basic filter by make, model)
  Future<List<Car>> searchCars({String? make, String? model}) async {
    Query query = _firestore.collection('cars');

    if (make != null && make.isNotEmpty) {
      query = query.where('make', isEqualTo: make);
    }
    if (model != null && model.isNotEmpty) {
      query = query.where('model', isEqualTo: model);
    }

    QuerySnapshot snapshot = await query.get();

    return snapshot.docs
        .map((doc) => Car.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}

// =============================================================
