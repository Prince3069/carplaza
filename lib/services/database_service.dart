// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:car_plaza/models/car_model.dart';
// import 'package:car_plaza/models/user_model.dart';
// import 'package:flutter/material.dart';

// class DatabaseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   static const String carsCollection = 'cars';
//   static const String usersCollection = 'users';
//   static const String carImagesFolder = 'car_images';

//   Future<String?> addCar(Car car) async {
//     try {
//       debugPrint('Adding car to Firestore: ${car.toMap()}');

//       // First verify that all required fields are present
//       if (car.title.isEmpty || car.description.isEmpty || car.price <= 0) {
//         debugPrint('Car validation failed: Missing required fields');
//         return null;
//       }

//       // Ensure images array is not empty
//       if (car.images.isEmpty) {
//         debugPrint('Car validation failed: No images provided');
//         return null;
//       }

//       // Add the car document to Firestore
//       DocumentReference docRef =
//           await _firestore.collection(carsCollection).add(car.toMap());
//       debugPrint('Car added successfully with ID: ${docRef.id}');
//       return docRef.id;
//     } on FirebaseException catch (e) {
//       // Handle specific Firebase errors
//       debugPrint('Firebase error adding car: ${e.code} - ${e.message}');
//       throw Exception('Firebase error: ${e.message}');
//     } catch (e) {
//       debugPrint('Unexpected error adding car: $e');
//       throw Exception('Failed to add car: $e');
//     }
//   }

//   Future<List<String>> uploadCarImages(
//       List<File> imageFiles, String userId) async {
//     List<String> downloadUrls = [];
//     debugPrint(
//         'Starting upload of ${imageFiles.length} images for user: $userId');

//     try {
//       for (int i = 0; i < imageFiles.length; i++) {
//         final imageFile = imageFiles[i];
//         final fileName =
//             'car_${DateTime.now().millisecondsSinceEpoch}_${i}_${userId.substring(0, min(userId.length, 4))}';
//         final ref = _storage.ref().child('$carImagesFolder/$fileName');

//         debugPrint(
//             'Uploading image $i: ${imageFile.path} to $carImagesFolder/$fileName');

//         // Create upload task with metadata
//         final metadata = SettableMetadata(
//           contentType: 'image/jpeg',
//           customMetadata: {'userId': userId},
//         );

//         try {
//           // Create and monitor upload task
//           final uploadTask = ref.putFile(imageFile, metadata);

//           // Add progress listener for debugging
//           uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//             final progress = snapshot.bytesTransferred / snapshot.totalBytes;
//             debugPrint(
//                 'Upload progress for image $i: ${(progress * 100).toStringAsFixed(2)}%');
//           }, onError: (e) {
//             debugPrint('Upload task error for image $i: $e');
//           });

//           // Wait for completion
//           await uploadTask;
//           debugPrint('Image $i uploaded successfully');

//           // Get download URL
//           final downloadUrl = await ref.getDownloadURL();
//           debugPrint('Got download URL for image $i: $downloadUrl');
//           downloadUrls.add(downloadUrl);
//         } on FirebaseException catch (e) {
//           debugPrint(
//               'Firebase error uploading image $i: ${e.code} - ${e.message}');
//           throw Exception(
//               'Firebase error uploading image ${i + 1}: ${e.message}');
//         }
//       }

//       debugPrint('All ${imageFiles.length} images uploaded successfully');
//       return downloadUrls;
//     } catch (e) {
//       debugPrint('Image upload process failed: $e');
//       rethrow;
//     }
//   }

//   Stream<List<Car>> get cars {
//     debugPrint('Fetching all cars stream');
//     return _firestore
//         .collection(carsCollection)
//         .orderBy('postedDate', descending: true)
//         .snapshots()
//         .handleError((error) {
//       debugPrint('Error fetching cars: $error');
//       return [];
//     }).map((snapshot) {
//       final cars = snapshot.docs
//           .map((doc) {
//             try {
//               final data = doc.data() as Map<String, dynamic>?;
//               if (data == null) return null;
//               return Car.fromMap(doc.id, data);
//             } catch (e) {
//               debugPrint('Error parsing car document ${doc.id}: $e');
//               return null;
//             }
//           })
//           .where((car) => car != null)
//           .cast<Car>()
//           .toList();

//       debugPrint('Fetched ${cars.length} cars');
//       return cars;
//     });
//   }

//   Stream<List<Car>> getCarsBySeller(String sellerId) {
//     debugPrint('Fetching cars for seller: $sellerId');
//     return _firestore
//         .collection(carsCollection)
//         .where('sellerId', isEqualTo: sellerId)
//         .orderBy('postedDate', descending: true)
//         .snapshots()
//         .handleError((error) {
//       debugPrint('Error fetching seller cars: $error');
//       return [];
//     }).map((snapshot) {
//       final cars = snapshot.docs
//           .map((doc) {
//             final data = doc.data() as Map<String, dynamic>?;
//             if (data == null) return null;
//             return Car.fromMap(doc.id, data);
//           })
//           .where((car) => car != null)
//           .cast<Car>()
//           .toList();
//       debugPrint('Fetched ${cars.length} cars for seller: $sellerId');
//       return cars;
//     });
//   }

//   Stream<UserModel?> getUserData(String userId) {
//     debugPrint('Fetching user data for: $userId');
//     return _firestore
//         .collection(usersCollection)
//         .doc(userId)
//         .snapshots()
//         .handleError((error) {
//       debugPrint('Error fetching user: $error');
//       return null;
//     }).map((doc) {
//       if (!doc.exists) return null;
//       final data = doc.data();
//       return data != null ? UserModel.fromMap(data) : null;
//     });
//   }

//   Future<UserModel?> getUser(String userId) async {
//     try {
//       debugPrint('Fetching user data for: $userId');
//       final doc =
//           await _firestore.collection(usersCollection).doc(userId).get();
//       if (!doc.exists) return null;
//       final data = doc.data();
//       return data != null ? UserModel.fromMap(data) : null;
//     } catch (e) {
//       debugPrint('Error getting user: $e');
//       return null;
//     }
//   }

//   Future<Car?> getCarById(String carId) async {
//     try {
//       debugPrint('Fetching car by ID: $carId');
//       final doc = await _firestore.collection(carsCollection).doc(carId).get();
//       if (!doc.exists) return null;
//       final data = doc.data();
//       return data != null ? Car.fromMap(doc.id, data) : null;
//     } catch (e) {
//       debugPrint('Error getting car: $e');
//       return null;
//     }
//   }

//   Future<void> deleteCar(String carId) async {
//     try {
//       debugPrint('Deleting car: $carId');
//       await _firestore.collection(carsCollection).doc(carId).delete();
//       debugPrint('Car deleted: $carId');
//     } catch (e) {
//       debugPrint('Error deleting car: $e');
//       rethrow;
//     }
//   }

//   Future<void> updateUserData(UserModel user) async {
//     try {
//       debugPrint('Updating user: ${user.id}');
//       await _firestore
//           .collection(usersCollection)
//           .doc(user.id)
//           .set(user.toMap());
//       debugPrint('User updated successfully');
//     } catch (e) {
//       debugPrint('Error updating user: $e');
//       rethrow;
//     }
//   }

//   // Helper function for min
//   int min(int a, int b) {
//     return a < b ? a : b;
//   }

//   // Add search functionality
//   Stream<List<Car>> searchCars({
//     String? query,
//     String? brand,
//     String? location,
//     double? minPrice,
//     double? maxPrice,
//     int? minYear,
//     int? maxYear,
//   }) {
//     Query collection = _firestore.collection(carsCollection);

//     if (query != null && query.isNotEmpty) {
//       collection = collection.where(
//         'searchKeywords',
//         arrayContains: query.toLowerCase(),
//       );
//     }

//     if (brand != null && brand.isNotEmpty) {
//       collection = collection.where('brand', isEqualTo: brand);
//     }

//     if (location != null && location.isNotEmpty) {
//       collection = collection.where('location', isEqualTo: location);
//     }

//     if (minPrice != null) {
//       collection = collection.where('price', isGreaterThanOrEqualTo: minPrice);
//     }

//     if (maxPrice != null) {
//       collection = collection.where('price', isLessThanOrEqualTo: maxPrice);
//     }

//     if (minYear != null) {
//       collection = collection.where('year', isGreaterThanOrEqualTo: minYear);
//     }

//     if (maxYear != null) {
//       collection = collection.where('year', isLessThanOrEqualTo: maxYear);
//     }

// ignore_for_file: unnecessary_cast

//     return collection
//         .orderBy('postedDate', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) {
//               final data = doc.data() as Map<String, dynamic>?;
//               if (data == null) return null;
//               return Car.fromMap(doc.id, data);
//             })
//             .where((car) => car != null)
//             .cast<Car>()
//             .toList());
//   }
// }
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:car_plaza/models/car_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<Car>> get cars {
    return _firestore
        .collection('listings')
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                Car.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<Car>> searchCars({
    String? query,
    String? brand,
    String? location,
    double? minPrice,
    double? maxPrice,
    int? minYear,
    int? maxYear,
  }) {
    Query collection = _firestore.collection('listings');

    if (query != null && query.isNotEmpty) {
      collection = collection.where(
        'searchKeywords',
        arrayContains: query.toLowerCase(),
      );
    }

    if (brand != null && brand.isNotEmpty) {
      collection = collection.where('brand', isEqualTo: brand);
    }

    if (location != null && location.isNotEmpty) {
      collection = collection.where('location', isEqualTo: location);
    }

    if (minPrice != null) {
      collection = collection.where('price', isGreaterThanOrEqualTo: minPrice);
    }

    if (maxPrice != null) {
      collection = collection.where('price', isLessThanOrEqualTo: maxPrice);
    }

    if (minYear != null) {
      collection = collection.where('year', isGreaterThanOrEqualTo: minYear);
    }

    if (maxYear != null) {
      collection = collection.where('year', isLessThanOrEqualTo: maxYear);
    }

    return collection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Car.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<List<String>> uploadCarImages(
      List<File> imageFiles, String userId) async {
    List<String> downloadUrls = [];

    for (int i = 0; i < imageFiles.length; i++) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = '${userId}_$timestamp$i.jpg';
      final ref = _storage.ref('car_images').child(filename);
      await ref.putFile(imageFiles[i]);
      final url = await ref.getDownloadURL();
      downloadUrls.add(url);
    }

    return downloadUrls;
  }

  Future<void> addCar(Car car) async {
    await _firestore.collection('listings').add(car.toMap());
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data();
  }
}
