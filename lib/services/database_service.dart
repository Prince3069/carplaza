import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:car_plaza/models/car_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  // Enhanced authentication check method
  Future<void> _ensureAuthenticated() async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception('User not authenticated with Firebase Auth');
    }

    print('DatabaseService: Current user: ${currentUser.uid}');
    print('DatabaseService: Email verified: ${currentUser.emailVerified}');

    // Force token refresh to ensure we have a valid, fresh token
    try {
      print('DatabaseService: Refreshing authentication token...');
      final token = await currentUser.getIdToken(true);
      print(
          'DatabaseService: Token refreshed successfully (length: ${token?.length})');

      // Small delay to ensure token propagation
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      print('DatabaseService: Token refresh failed: $e');
      throw Exception('Authentication token refresh failed: $e');
    }
  }

  // Test authentication and Firebase connection
  Future<bool> testAuthAndConnection() async {
    try {
      print(
          'DatabaseService: Testing authentication and Firebase connection...');

      await _ensureAuthenticated();

      final currentUser = _auth.currentUser!;
      final testData = 'Auth test - ${DateTime.now().toIso8601String()}';
      final fileName =
          'test/auth_test_${currentUser.uid}_${DateTime.now().millisecondsSinceEpoch}.txt';

      final ref = _storage.ref().child(fileName);

      print('DatabaseService: Attempting test upload...');
      final uploadTask = ref.putString(testData,
          metadata: SettableMetadata(
            contentType: 'text/plain',
            customMetadata: {'uploadedBy': currentUser.uid},
          ));

      await uploadTask.timeout(const Duration(seconds: 15));

      // Try to get download URL
      final downloadUrl = await ref.getDownloadURL();
      print('DatabaseService: Test upload successful - URL: $downloadUrl');

      // Clean up test file
      try {
        await ref.delete();
        print('DatabaseService: Test file cleaned up');
      } catch (e) {
        print('DatabaseService: Could not clean up test file: $e');
      }

      return true;
    } catch (e) {
      print('DatabaseService: Auth/Connection test FAILED: $e');
      return false;
    }
  }

  // Main upload method with enhanced authentication
  Future<List<String>> uploadCarImages(
      List<File> imageFiles, String userId) async {
    print('DatabaseService: Starting enhanced image upload...');

    // Ensure we're authenticated
    await _ensureAuthenticated();

    final currentUser = _auth.currentUser!;

    // Verify user ID matches
    if (currentUser.uid != userId) {
      print(
          'DatabaseService: WARNING - Auth UID (${currentUser.uid}) != provided UID ($userId)');
      print('DatabaseService: Using authenticated user UID for upload');
    }

    // Test connection first
    final connectionOk = await testAuthAndConnection();
    if (!connectionOk) {
      throw Exception('Authentication or connection test failed');
    }

    final List<String> downloadUrls = [];

    for (int i = 0; i < imageFiles.length; i++) {
      String? downloadUrl;
      int attempts = 0;
      const maxAttempts = 3;

      while (downloadUrl == null && attempts < maxAttempts) {
        attempts++;

        try {
          print(
              'DatabaseService: Upload attempt $attempts for image ${i + 1}/${imageFiles.length}');

          // Refresh authentication before each upload attempt
          if (attempts > 1) {
            print(
                'DatabaseService: Refreshing auth for retry attempt $attempts...');
            await _ensureAuthenticated();
          }

          final file = imageFiles[i];
          final fileSize = await file.length();
          print(
              'DatabaseService: Image ${i + 1} size: ${(fileSize / 1024).toStringAsFixed(1)} KB');

          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final fileName =
              'car_images/${currentUser.uid}/${timestamp}_image_${i + 1}.jpg';

          print('DatabaseService: Uploading to path: $fileName');

          // Create reference
          final ref = _storage.ref().child(fileName);

          // Create upload task with proper metadata
          final uploadTask = ref.putFile(
            file,
            SettableMetadata(
              contentType: 'image/jpeg',
              customMetadata: {
                'uploadedBy': currentUser.uid,
                'uploadTimestamp': timestamp.toString(),
                'imageIndex': i.toString(),
              },
            ),
          );

          // Monitor progress
          late StreamSubscription progressSubscription;
          progressSubscription = uploadTask.snapshotEvents.listen(
            (TaskSnapshot snapshot) {
              final progress =
                  (snapshot.bytesTransferred / snapshot.totalBytes * 100);
              print(
                  'DatabaseService: Image ${i + 1} progress: ${progress.toStringAsFixed(1)}%');
            },
            onError: (error) {
              print('DatabaseService: Upload progress error: $error');
              progressSubscription.cancel();
            },
          );

          // Wait for completion with progressive timeout
          final timeoutSeconds = 30 + (attempts * 15); // 30s, 45s, 60s
          print(
              'DatabaseService: Using ${timeoutSeconds}s timeout for attempt $attempts');

          final snapshot = await uploadTask.timeout(
            Duration(seconds: timeoutSeconds),
            onTimeout: () {
              progressSubscription.cancel();
              throw TimeoutException('Upload timeout after ${timeoutSeconds}s');
            },
          );

          progressSubscription.cancel();

          print('DatabaseService: Upload completed, getting download URL...');

          // Get download URL with timeout
          downloadUrl = await snapshot.ref.getDownloadURL().timeout(
                const Duration(seconds: 10),
                onTimeout: () => throw TimeoutException('Download URL timeout'),
              );

          print(
              'DatabaseService: Image ${i + 1} uploaded successfully on attempt $attempts');
          print(
              'DatabaseService: Download URL obtained: ${downloadUrl.substring(0, 50)}...');
        } catch (e) {
          print(
              'DatabaseService: Upload attempt $attempts failed for image ${i + 1}: $e');

          // Handle specific error types
          if (e.toString().contains('unauthenticated')) {
            print(
                'DatabaseService: Authentication error detected, will refresh token');
            if (attempts < maxAttempts) {
              print(
                  'DatabaseService: Waiting before retry due to auth error...');
              await Future.delayed(Duration(seconds: 2 * attempts));
            }
          } else if (e.toString().contains('network') ||
              e.toString().contains('timeout')) {
            print('DatabaseService: Network/timeout error, will retry');
            if (attempts < maxAttempts) {
              await Future.delayed(Duration(seconds: 3 * attempts));
            }
          }

          if (attempts >= maxAttempts) {
            throw Exception(
                'Failed to upload image ${i + 1} after $maxAttempts attempts: $e');
          }
        }
      }

      if (downloadUrl != null) {
        downloadUrls.add(downloadUrl);
        print(
            'DatabaseService: Image ${i + 1} added to results (${downloadUrls.length}/${imageFiles.length})');
      } else {
        throw Exception(
            'Failed to upload image ${i + 1} - no download URL obtained');
      }
    }

    print(
        'DatabaseService: All ${imageFiles.length} images uploaded successfully');
    return downloadUrls;
  }

  // Simplified backup upload method
  Future<List<String>> uploadCarImagesSimple(
      List<File> imageFiles, String userId) async {
    await _ensureAuthenticated();

    final currentUser = _auth.currentUser!;
    final List<String> downloadUrls = [];

    for (int i = 0; i < imageFiles.length; i++) {
      try {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filename =
            'car_images/${currentUser.uid}/simple_${timestamp}_$i.jpg';

        print('DatabaseService: Simple upload for image ${i + 1}');

        final ref = _storage.ref().child(filename);
        final uploadTask = ref.putFile(imageFiles[i]);

        final snapshot = await uploadTask.timeout(
          const Duration(seconds: 45),
          onTimeout: () => throw TimeoutException('Simple upload timeout'),
        );

        final url = await snapshot.ref.getDownloadURL();
        downloadUrls.add(url);

        print('DatabaseService: Simple upload successful for image ${i + 1}');
      } catch (e) {
        print('DatabaseService: Simple upload failed for image ${i + 1}: $e');
        throw Exception('Simple upload failed for image ${i + 1}: $e');
      }
    }

    return downloadUrls;
  }

  Future<void> addCar(Car car) async {
    try {
      print('DatabaseService: Adding car to Firestore...');

      // Ensure we're still authenticated
      await _ensureAuthenticated();

      await _firestore.collection('listings').add(car.toMap()).timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw TimeoutException('Firestore add timeout'),
          );

      print('DatabaseService: Car added to Firestore successfully');
    } catch (e) {
      print('DatabaseService: Failed to add car to Firestore: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get()
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Get user data timeout'),
          );
      return doc.data();
    } catch (e) {
      print('DatabaseService: Failed to get user data: $e');
      rethrow;
    }
  }

  // Method to check current authentication status
  Future<Map<String, dynamic>> getAuthStatus() async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return {
        'authenticated': false,
        'error': 'No current user',
      };
    }

    try {
      final token = await currentUser.getIdToken();
      return {
        'authenticated': true,
        'uid': currentUser.uid,
        'email': currentUser.email,
        'emailVerified': currentUser.emailVerified,
        'tokenLength': token?.length,
      };
    } catch (e) {
      return {
        'authenticated': false,
        'uid': currentUser.uid,
        'error': 'Token error: $e',
      };
    }
  }
}
