// class AppUser {
//   final String id;
//   final String name;
//   final String email;
//   final String profileImageUrl;
//   final bool isDealer;

//   AppUser({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.profileImageUrl,
//     required this.isDealer,
//   });

//   factory AppUser.fromJson(Map<String, dynamic> json) {
//     return AppUser(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//       profileImageUrl: json['profileImageUrl'],
//       isDealer: json['isDealer'] ?? false,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'email': email,
//         'profileImageUrl': profileImageUrl,
//         'isDealer': isDealer,
//       };
// }
