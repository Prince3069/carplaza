class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? photoUrl;
  final bool isVerifiedSeller;
  final DateTime joinedDate;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
    this.isVerifiedSeller = false,
    required this.joinedDate,
  });

  // Convert User to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'isVerifiedSeller': isVerifiedSeller,
      'joinedDate': joinedDate.toIso8601String(),
    };
  }

  // Create User from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      photoUrl: map['photoUrl'],
      isVerifiedSeller: map['isVerifiedSeller'] ?? false,
      joinedDate: DateTime.parse(map['joinedDate']),
    );
  }
}
