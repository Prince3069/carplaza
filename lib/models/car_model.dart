import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  final String id;
  final String title;
  final String description;
  final double price;
  final String brand;
  final String model;
  final int year;
  final String location;
  final List<String> imageUrls;
  final DateTime createdAt;
  final bool isFeatured;
  final int views;

  Car({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.brand,
    required this.model,
    required this.year,
    required this.location,
    required this.imageUrls,
    required this.createdAt,
    this.isFeatured = false,
    this.views = 0,
  });

  factory Car.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Car(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      brand: data['brand'] ?? '',
      model: data['model'] ?? '',
      year: data['year'] ?? 0,
      location: data['location'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isFeatured: data['isFeatured'] ?? false,
      views: data['views'] ?? 0,
    );
  }

  String get formattedPrice {
    return '₦${price.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';
  }

  String get yearAndLocation {
    return '$year • $location';
  }
}
