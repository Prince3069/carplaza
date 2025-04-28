// =================== lib/models/user.dart ===================

class AppUser {
  final String id;
  final String email;
  final String name;
  final String? phone;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String documentId) {
    return AppUser(
      id: documentId,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
    };
  }
}

// =============================================================
