import 'dart:io';
import 'package:car_plaza/constants/app_colors.dart';
import 'package:car_plaza/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/services/database_service.dart';
import 'package:car_plaza/widgets/responsive_layout.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
// import 'package:car_plaza/app_colors.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _formKey = GlobalKey<FormState>();
  List<File> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String _uploadStatus = '';
  double _uploadProgress = 0.0;

  // Form fields
  String _title = '';
  String _description = '';
  double _price = 0.0;
  String _location = 'Lagos';
  String _brand = 'Toyota';
  String _model = '';
  int _year = DateTime.now().year;
  String _condition = 'Used';
  String _transmission = 'Automatic';
  String _fuelType = 'Petrol';
  String _mileage = '';

  final List<String> _locations = [
    'Lagos',
    'Abuja',
    'Port Harcourt',
    'Kano',
    'Enugu'
  ];
  final List<String> _brands = [
    'Toyota',
    'Honda',
    'Nissan',
    'Mercedes',
    'BMW',
    'Lexus'
  ];
  final List<String> _conditions = ['New', 'Used', 'Foreign Used'];
  final List<String> _transmissions = ['Automatic', 'Manual'];
  final List<String> _fuelTypes = ['Petrol', 'Diesel', 'Hybrid', 'Electric'];

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseService>(context);
    final user = FirebaseAuth.instance.currentUser;

    return ResponsiveLayout(
      mobileBody: _buildForm(database, user?.uid),
      tabletBody: _buildForm(database, user?.uid),
      desktopBody: Center(
        child: SizedBox(
          width: 800,
          child: _buildForm(database, user?.uid),
        ),
      ),
    );
  }

  Widget _buildForm(DatabaseService database, String? userId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Sell Your Car',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildImageUploadSection(),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title*',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value!.isEmpty ? 'Required' : null,
              onSaved: (value) => _title = value!,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description*',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) => value!.isEmpty ? 'Required' : null,
              onSaved: (value) => _description = value!,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Price (₦)*',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) return 'Required';
                if (double.tryParse(value) == null) return 'Invalid number';
                return null;
              },
              onSaved: (value) => _price = double.parse(value!),
            ),
            const SizedBox(height: 12),
            _buildDropdownFormField<String>(
              value: _location,
              items: _locations,
              onChanged: (value) => setState(() => _location = value!),
              labelText: 'Location*',
            ),
            const SizedBox(height: 12),
            _buildDropdownFormField<String>(
              value: _brand,
              items: _brands,
              onChanged: (value) => setState(() => _brand = value!),
              labelText: 'Brand*',
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Model*',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value!.isEmpty ? 'Required' : null,
              onSaved: (value) => _model = value!,
            ),
            const SizedBox(height: 12),
            _buildDropdownFormField<int>(
              value: _year,
              items: List.generate(30, (index) => DateTime.now().year - index),
              onChanged: (value) => setState(() => _year = value!),
              labelText: 'Year*',
            ),
            const SizedBox(height: 12),
            _buildDropdownFormField<String>(
              value: _condition,
              items: _conditions,
              onChanged: (value) => setState(() => _condition = value!),
              labelText: 'Condition*',
            ),
            const SizedBox(height: 12),
            _buildDropdownFormField<String>(
              value: _transmission,
              items: _transmissions,
              onChanged: (value) => setState(() => _transmission = value!),
              labelText: 'Transmission*',
            ),
            const SizedBox(height: 12),
            _buildDropdownFormField<String>(
              value: _fuelType,
              items: _fuelTypes,
              onChanged: (value) => setState(() => _fuelType = value!),
              labelText: 'Fuel Type*',
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Mileage (km)*',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value!.isEmpty ? 'Required' : null,
              onSaved: (value) => _mileage = value!,
            ),
            const SizedBox(height: 20),
            if (_isUploading) ...[
              LinearProgressIndicator(value: _uploadProgress),
              const SizedBox(height: 8),
              Text(
                _uploadStatus,
                textAlign: TextAlign.center,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 12),
            ],
            ElevatedButton(
              onPressed:
                  _isUploading ? null : () => _submitForm(database, userId),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isUploading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(width: 10),
                        Text('Submitting...',
                            style: TextStyle(color: Colors.white)),
                      ],
                    )
                  : const Text('Submit Car Listing',
                      style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownFormField<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String labelText,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Car Images (Upload at least 1 image)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (_imageFiles.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imageFiles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _imageFiles[index],
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _imageFiles.removeAt(index);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickImages,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Add Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
            ),
            if (_imageFiles.isNotEmpty)
              TextButton(
                onPressed: _isUploading
                    ? null
                    : () => setState(() => _imageFiles.clear()),
                child: const Text('Clear All'),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          _imageFiles = pickedFiles.map((xfile) => File(xfile.path)).toList();
        });
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: ${e.toString()}')),
      );
    }
  }

  Future<List<String>> _uploadImages(String userId) async {
    List<String> imageUrls = [];
    setState(() {
      _uploadStatus = 'Preparing to upload images...';
      _uploadProgress = 0.0;
    });

    try {
      for (int i = 0; i < _imageFiles.length; i++) {
        final imageFile = _imageFiles[i];
        setState(() {
          _uploadStatus =
              'Uploading image ${i + 1} of ${_imageFiles.length}...';
        });

        // Create a unique filename
        final fileName =
            'car_${DateTime.now().millisecondsSinceEpoch}_${i}_${userId.substring(0, min(userId.length, 4))}';
        final fileExtension = path.extension(imageFile.path);
        final fullFileName = '$fileName$fileExtension';

        // Get reference to Firebase Storage
        final Reference storageReference =
            FirebaseStorage.instance.ref().child('car_images/$fullFileName');

        // Set metadata
        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'userId': userId},
        );

        // Create upload task
        final UploadTask uploadTask =
            storageReference.putFile(imageFile, metadata);

        // Monitor upload progress
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          double progress = snapshot.bytesTransferred / snapshot.totalBytes;
          setState(() {
            _uploadProgress = progress;
          });
          debugPrint(
              'Upload progress for image $i: ${(progress * 100).toStringAsFixed(2)}%');
        });

        // Wait for upload to complete
        await uploadTask;

        // Get download URL
        final String downloadUrl = await storageReference.getDownloadURL();
        imageUrls.add(downloadUrl);

        debugPrint('Image $i uploaded: $downloadUrl');
      }

      setState(() {
        _uploadStatus = 'All images uploaded successfully!';
        _uploadProgress = 1.0;
      });

      return imageUrls;
    } catch (e) {
      setState(() {
        _uploadStatus = 'Error: ${e.toString()}';
      });
      debugPrint('Error uploading images: $e');
      throw Exception('Failed to upload images: $e');
    }
  }

  Future<void> _submitForm(DatabaseService database, String? userId) async {
    // Add this at the beginning of your _submitForm method:
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please save your profile first'),
          action: SnackBarAction(
            label: 'Go to Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ),
      );
      return;
    }
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to sell a car')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_imageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload at least one image')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadStatus = 'Starting submission process...';
    });

    try {
      debugPrint('Starting car submission process');
      debugPrint('User ID: $userId');

      // Check if user is verified
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists || !(userDoc.data()?['isVerifiedSeller'] ?? false)) {
        throw Exception('You must be a verified seller to list cars');
      }

      // Upload images using our improved method
      List<String> imageUrls = await _uploadImages(userId);
      debugPrint('All images uploaded successfully. Image URLs: $imageUrls');

      // Create car object
      final newCar = Car(
        title: _title,
        description: _description,
        price: _price,
        location: _location,
        brand: _brand,
        model: _model,
        year: _year,
        condition: _condition,
        transmission: _transmission,
        fuelType: _fuelType,
        mileage: _mileage,
        images: imageUrls,
        sellerId: userId,
        postedDate: DateTime.now(),
      );

      setState(() {
        _uploadStatus = 'Saving car listing to database...';
      });

      debugPrint('Created car object with data: ${newCar.toMap()}');

      // Save to Firestore
      final carId = await database.addCar(newCar);

      if (carId == null) {
        throw Exception('Failed to save car to database - returned null ID');
      }

      debugPrint('Car saved to database with ID: $carId');

      // Success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Car listed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Reset form
      _formKey.currentState!.reset();
      setState(() {
        _imageFiles = [];
        _isUploading = false;
        _uploadStatus = '';
        _uploadProgress = 0.0;
        _location = 'Lagos';
        _brand = 'Toyota';
        _year = DateTime.now().year;
        _condition = 'Used';
        _transmission = 'Automatic';
        _fuelType = 'Petrol';
      });
    } catch (e) {
      debugPrint('Error submitting car: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
      setState(() {
        _isUploading = false;
        _uploadStatus = '';
        _uploadProgress = 0.0;
      });
    }
  }

  // Helper function for min
  int min(int a, int b) {
    return a < b ? a : b;
  }
}
