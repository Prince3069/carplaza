class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final String? location;
  final DateTime joinedAt;
  final bool isSeller;
  final List<String>? savedCars;
  final String? paymentMethod;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    this.location,
    required this.joinedAt,
    this.isSeller = false,
    this.savedCars,
    this.paymentMethod,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      photoUrl: map['photoUrl'],
      location: map['location'],
      joinedAt: map['joinedAt']?.toDate() ?? DateTime.now(),
      isSeller: map['isSeller'] ?? false,
      savedCars: List<String>.from(map['savedCars'] ?? []),
      paymentMethod: map['paymentMethod'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'location': location,
      'joinedAt': joinedAt,
      'isSeller': isSeller,
      'savedCars': savedCars,
      'paymentMethod': paymentMethod,
    };
  }
}
