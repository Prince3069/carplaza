// =================== lib/models/car.dart ===================

import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  final String id;
  final String title;
  final String description;
  final double price;
  final String make;
  final String model;
  final int year;
  final int mileage;
  final List<String> imageUrls;
  final String videoUrl;
  final String sellerId;
  final Timestamp postedAt;

  Car({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.make,
    required this.model,
    required this.year,
    required this.mileage,
    required this.imageUrls,
    required this.videoUrl,
    required this.sellerId,
    required this.postedAt,
  });

  factory Car.fromMap(Map<String, dynamic> data, String documentId) {
    return Car(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      make: data['make'] ?? '',
      model: data['model'] ?? '',
      year: data['year'] ?? 0,
      mileage: data['mileage'] ?? 0,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      videoUrl: data['videoUrl'] ?? '',
      sellerId: data['sellerId'] ?? '',
      postedAt: data['postedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'make': make,
      'model': model,
      'year': year,
      'mileage': mileage,
      'imageUrls': imageUrls,
      'videoUrl': videoUrl,
      'sellerId': sellerId,
      'postedAt': postedAt,
    };
  }
}

// =============================================================
