// // File: lib/models/car.dart
// class Car {
//   final String id;
//   final String title;
//   final double price;
//   final String location;
//   final String imageUrl;
//   final String? description;
//   final String? make;
//   final String? model;
//   final String? year;
//   final String? sellerId;
//   final bool isFeatured;
//   final DateTime createdAt;

//   Car({
//     required this.id,
//     required this.title,
//     required this.price,
//     required this.location,
//     required this.imageUrl,
//     this.description,
//     this.make,
//     this.model,
//     this.year,
//     this.sellerId,
//     this.isFeatured = false,
//     DateTime? createdAt,
//   }) : createdAt = createdAt ?? DateTime.now();

//   // Convert to Map for Firestore
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'price': price,
//       'location': location,
//       'imageUrl': imageUrl,
//       'description': description,
//       'make': make,
//       'model': model,
//       'year': year,
//       'sellerId': sellerId,
//       'isFeatured': isFeatured,
//       'createdAt': createdAt,
//     };
//   }

//   // Create Car from Firestore data
//   factory Car.fromMap(Map<String, dynamic> map, String id) {
//     return Car(
//       id: id,
//       title: map['title'] ?? '',
//       price: (map['price'] ?? 0).toDouble(),
//       location: map['location'] ?? '',
//       imageUrl: map['imageUrl'] ?? '',
//       description: map['description'],
//       make: map['make'],
//       model: map['model'],
//       year: map['year'],
//       sellerId: map['sellerId'],
//       isFeatured: map['isFeatured'] ?? false,
//       createdAt: (map['createdAt'] as DateTime?) ?? DateTime.now(),
//     );
//   }
// }

// // File: lib/models/user.dart
// class UserModel {
//   final String id;
//   final String name;
//   final String email;
//   final String? photoUrl;
//   final String? phone;
//   final String? location;
//   final DateTime createdAt;
//   final bool isVerified;

//   UserModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     this.photoUrl,
//     this.phone,
//     this.location,
//     DateTime? createdAt,
//     this.isVerified = false,
//   }) : createdAt = createdAt ?? DateTime.now();

//   // Convert to Map for Firestore
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'photoUrl': photoUrl,
//       'phone': phone,
//       'location': location,
//       'createdAt': createdAt,
//       'isVerified': isVerified,
//     };
//   }

//   // Create UserModel from Firestore data
//   factory UserModel.fromMap(Map<String, dynamic> map, String id) {
//     return UserModel(
//       id: id,
//       name: map['name'] ?? '',
//       email: map['email'] ?? '',
//       photoUrl: map['photoUrl'],
//       phone: map['phone'],
//       location: map['location'],
//       createdAt: (map['createdAt'] as DateTime?) ?? DateTime.now(),
//       isVerified: map['isVerified'] ?? false,
//     );
//   }
// }

// // File: lib/models/message.dart
// class Message {
//   final String id;
//   final String senderId;
//   final String senderName;
//   final String? senderAvatar;
//   final String lastMessage;
//   final DateTime timestamp;
//   final bool unread;
//   final String? carId;
//   final String? carTitle;
//   final String? carImage;

//   Message({
//     required this.id,
//     required this.senderId,
//     required this.senderName,
//     this.senderAvatar,
//     required this.lastMessage,
//     required this.timestamp,
//     this.unread = false,
//     this.carId,
//     this.carTitle,
//     this.carImage,
//   });

//   // Convert to Map for Firestore
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'senderId': senderId,
//       'senderName': senderName,
//       'senderAvatar': senderAvatar,
//       'lastMessage': lastMessage,
//       'timestamp': timestamp,
//       'unread': unread,
//       'carId': carId,
//       'carTitle': carTitle,
//       'carImage': carImage,
//     };
//   }

//   // Create Message from Firestore data
//   factory Message.fromMap(Map<String, dynamic> map, String id) {
//     return Message(
//       id: id,
//       senderId: map['senderId'] ?? '',
//       senderName: map['senderName'] ?? '',
//       senderAvatar: map['senderAvatar'],
//       lastMessage: map['lastMessage'] ?? '',
//       timestamp: (map['timestamp'] as DateTime?) ?? DateTime.now(),
//       unread: map['unread'] ?? false,
//       carId: map['carId'],
//       carTitle: map['carTitle'],
//       carImage: map['carImage'],
//     );
//   }
// }
