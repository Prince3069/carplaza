// CAR LISTING MODEL
class CarModel {
  final String id;
  final String sellerId;
  final String make;
  final String model;
  final int year;
  final double price;
  final String description;
  final List<String> images;
  final String location;
  final DateTime createdAt;
  final bool isFeatured;
  final String condition;
  final double mileage;
  final String transmission;
  final String fuelType;
  final String color;

  CarModel({
    required this.id,
    required this.sellerId,
    required this.make,
    required this.model,
    required this.year,
    required this.price,
    required this.description,
    required this.images,
    required this.location,
    required this.createdAt,
    required this.isFeatured,
    required this.condition,
    required this.mileage,
    required this.transmission,
    required this.fuelType,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sellerId': sellerId,
      'make': make,
      'model': model,
      'year': year,
      'price': price,
      'description': description,
      'images': images,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'isFeatured': isFeatured,
      'condition': condition,
      'mileage': mileage,
      'transmission': transmission,
      'fuelType': fuelType,
      'color': color,
    };
  }

  factory CarModel.fromMap(Map<String, dynamic> map) {
    return CarModel(
      id: map['id'] ?? '',
      sellerId: map['sellerId'] ?? '',
      make: map['make'] ?? '',
      model: map['model'] ?? '',
      year: map['year']?.toInt() ?? 0,
      price: map['price']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      location: map['location'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      isFeatured: map['isFeatured'] ?? false,
      condition: map['condition'] ?? 'Used',
      mileage: map['mileage']?.toDouble() ?? 0.0,
      transmission: map['transmission'] ?? 'Automatic',
      fuelType: map['fuelType'] ?? 'Petrol',
      color: map['color'] ?? '',
    );
  }
}
