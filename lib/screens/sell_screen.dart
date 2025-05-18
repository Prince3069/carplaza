import 'dart:io';
import 'package:car_plaza/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/services/database_service.dart';
import 'package:car_plaza/widgets/responsive_layout.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
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
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              onSaved: (value) => _title = value ?? '',
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description*',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              onSaved: (value) => _description = value ?? '',
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Price (₦)*',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Required';
                if (double.tryParse(value!) == null) return 'Invalid number';
                return null;
              },
              onSaved: (value) => _price = double.tryParse(value ?? '0') ?? 0.0,
            ),
            const SizedBox(height: 12),
            _buildDropdownFormField<String>(
              value: _location,
              items: _locations,
              onChanged: (value) =>
                  setState(() => _location = value ?? 'Lagos'),
              labelText: 'Location*',
            ),
            const SizedBox(height: 12),
            _buildDropdownFormField<String>(
              value: _brand,
              items: _brands,
              onChanged: (value) => setState(() => _brand = value ?? 'Toyota'),
              labelText: 'Brand*',
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Model*',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              onSaved: (value) => _model = value ?? '',
            ),
            const SizedBox(height: 12),
            _buildDropdownFormField<int>(
              value: _year,
              items: List.generate(30, (index) => DateTime.now().year - index),
              onChanged: (value) =>
                  setState(() => _year = value ?? DateTime.now().year),
              labelText: 'Year*',
            ),
            const SizedBox(height: 12),
            _buildDropdownFormField<String>(
              value: _condition,
              items: _conditions,
              onChanged: (value) =>
                  setState(() => _condition = value ?? 'Used'),
              labelText: 'Condition*',
            ),
            const SizedBox(height: 12),
            _buildDropdownFormField<String>(
              value: _transmission,
              items: _transmissions,
              onChanged: (value) =>
                  setState(() => _transmission = value ?? 'Automatic'),
              labelText: 'Transmission*',
            ),
            const SizedBox(height: 12),
            _buildDropdownFormField<String>(
              value: _fuelType,
              items: _fuelTypes,
              onChanged: (value) =>
                  setState(() => _fuelType = value ?? 'Petrol'),
              labelText: 'Fuel Type*',
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Mileage (km)*',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              onSaved: (value) => _mileage = value ?? '',
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: ${e.toString()}')),
      );
    }
  }

  Future<List<String>> _uploadImages(String userId) async {
    List<String> imageUrls = [];
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Get fresh ID token
    final idToken = await user.getIdToken(true);

    for (int i = 0; i < _imageFiles.length; i++) {
      try {
        final imageFile = _imageFiles[i];
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filename = '${userId}_$timestamp$i.jpg';

        setState(() {
          _uploadStatus = 'Uploading image ${i + 1}/${_imageFiles.length}';
        });

        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploaderId': userId,
            'authToken': idToken!,
          },
        );

        final ref = FirebaseStorage.instance.ref('car_images').child(filename);
        final uploadTask = ref.putFile(imageFile, metadata);

        uploadTask.snapshotEvents.listen((taskSnapshot) {
          setState(() {
            _uploadProgress =
                taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
          });
        });

        final taskSnapshot = await uploadTask;
        final url = await taskSnapshot.ref.getDownloadURL();
        imageUrls.add(url);
      } catch (e) {
        debugPrint('Error uploading image: $e');
        rethrow;
      }
    }
    return imageUrls;
  }

  Future<void> _submitForm(DatabaseService database, String? userId) async {
    if (userId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login first')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_imageFiles.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload at least one image')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadStatus = 'Starting submission...';
    });

    try {
      // Verify user exists and is verified
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists || !(userDoc.data()?['isVerifiedSeller'] ?? false)) {
        throw Exception('Please complete your profile verification first');
      }

      // Upload images
      final imageUrls = await _uploadImages(userId);

      // Create car listing
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

      setState(() => _uploadStatus = 'Saving car details...');
      await database.addCar(newCar);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Car listed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      _resetForm();
    } on FirebaseException catch (e) {
      if (e.code == 'storage/unauthorized') {
        await FirebaseAuth.instance.signOut();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message ?? 'Unknown error'}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadStatus = '';
        });
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _imageFiles = [];
      _location = 'Lagos';
      _brand = 'Toyota';
      _year = DateTime.now().year;
      _condition = 'Used';
      _transmission = 'Automatic';
      _fuelType = 'Petrol';
    });
  }
}
