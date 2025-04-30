// USER DATA MODEL
class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String phone;
  final DateTime createdAt;
  final bool isSeller;
  final String profileImage;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.createdAt,
    required this.isSeller,
    required this.profileImage,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? phone,
    DateTime? createdAt,
    bool? isSeller,
    String? profileImage,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      isSeller: isSeller ?? this.isSeller,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'isSeller': isSeller,
      'profileImage': profileImage,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      isSeller: map['isSeller'] ?? false,
      profileImage: map['profileImage'] ?? '',
    );
  }
}
