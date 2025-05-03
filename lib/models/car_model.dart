class CarModel {
  final String id;
  final String sellerId;
  final String title;
  final String description;
  final String brand;
  final String model;
  final int year;
  final double price;
  final String location;
  final List<String> images;
  final String? videoUrl;
  final DateTime postedAt;
  final bool isFeatured;
  final bool isSold;
  final String? accidentHistory;
  final double mileage;
  final String transmission;
  final String fuelType;
  final String condition;
  final String? color;

  CarModel({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.description,
    required this.brand,
    required this.model,
    required this.year,
    required this.price,
    required this.location,
    required this.images,
    this.videoUrl,
    required this.postedAt,
    this.isFeatured = false,
    this.isSold = false,
    this.accidentHistory,
    required this.mileage,
    required this.transmission,
    required this.fuelType,
    required this.condition,
    this.color,
  });

  factory CarModel.fromMap(Map<String, dynamic> map, String id) {
    return CarModel(
      id: id,
      sellerId: map['sellerId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      brand: map['brand'] ?? '',
      model: map['model'] ?? '',
      year: map['year'] ?? 0,
      price: map['price']?.toDouble() ?? 0.0,
      location: map['location'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      videoUrl: map['videoUrl'],
      postedAt: map['postedAt']?.toDate() ?? DateTime.now(),
      isFeatured: map['isFeatured'] ?? false,
      isSold: map['isSold'] ?? false,
      accidentHistory: map['accidentHistory'],
      mileage: map['mileage']?.toDouble() ?? 0.0,
      transmission: map['transmission'] ?? 'Automatic',
      fuelType: map['fuelType'] ?? 'Petrol',
      condition: map['condition'] ?? 'Used',
      color: map['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'title': title,
      'description': description,
      'brand': brand,
      'model': model,
      'year': year,
      'price': price,
      'location': location,
      'images': images,
      'videoUrl': videoUrl,
      'postedAt': postedAt,
      'isFeatured': isFeatured,
      'isSold': isSold,
      'accidentHistory': accidentHistory,
      'mileage': mileage,
      'transmission': transmission,
      'fuelType': fuelType,
      'condition': condition,
      'color': color,
    };
  }

  String get formattedPrice {
    return '₦${price.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d)'),
          (Match m) => '${m[1]},',
        )}';
  }
}
