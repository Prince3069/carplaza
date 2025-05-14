class Car {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String location;
  final String brand;
  final String model;
  final int year;
  final String condition;
  final String transmission;
  final String fuelType;
  final String mileage;
  final List<String> images;
  final String sellerId;
  final DateTime postedDate;
  final bool isVerified;

  Car({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.brand,
    required this.model,
    required this.year,
    required this.condition,
    required this.transmission,
    required this.fuelType,
    required this.mileage,
    required this.images,
    required this.sellerId,
    required this.postedDate,
    this.isVerified = false,
  });

  // Convert Car to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'brand': brand,
      'model': model,
      'year': year,
      'condition': condition,
      'transmission': transmission,
      'fuelType': fuelType,
      'mileage': mileage,
      'images': images,
      'sellerId': sellerId,
      'postedDate': postedDate.toIso8601String(),
      'isVerified': isVerified,
    };
  }

  // Create Car from Map
  factory Car.fromMap(String id, Map<String, dynamic> map) {
    return Car(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      location: map['location'] ?? '',
      brand: map['brand'] ?? '',
      model: map['model'] ?? '',
      year: map['year']?.toInt() ?? 0,
      condition: map['condition'] ?? '',
      transmission: map['transmission'] ?? '',
      fuelType: map['fuelType'] ?? '',
      mileage: map['mileage'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      sellerId: map['sellerId'] ?? '',
      postedDate: DateTime.parse(map['postedDate']),
      isVerified: map['isVerified'] ?? false,
    );
  }
}
