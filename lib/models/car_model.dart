class Car {
  final String id;
  final String userId;
  final String brand;
  final String model;
  final int year;
  final String condition;
  final String transmission;
  final String fuelType;
  final int mileage;
  final double price;
  final String location;
  final List<String> images;
  final String description;
  final DateTime postedDate;

  Car({
    this.id = '',
    required this.userId,
    required this.brand,
    required this.model,
    required this.year,
    required this.condition,
    required this.transmission,
    required this.fuelType,
    required this.mileage,
    required this.price,
    required this.location,
    required this.images,
    required this.description,
    required this.postedDate,
  });

  factory Car.fromMap(Map<String, dynamic> data, String id) {
    return Car(
      id: id,
      userId: data['userId'] ?? '',
      brand: data['brand'] ?? '',
      model: data['model'] ?? '',
      year: data['year'] ?? 0,
      condition: data['condition'] ?? 'Used',
      transmission: data['transmission'] ?? 'Automatic',
      fuelType: data['fuelType'] ?? 'Petrol',
      mileage: data['mileage'] ?? 0,
      price: data['price']?.toDouble() ?? 0.0,
      location: data['location'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      description: data['description'] ?? '',
      postedDate: (data['postedDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'brand': brand,
      'model': model,
      'year': year,
      'condition': condition,
      'transmission': transmission,
      'fuelType': fuelType,
      'mileage': mileage,
      'price': price,
      'location': location,
      'images': images,
      'description': description,
      'postedDate': Timestamp.fromDate(postedDate),
    };
  }
}
