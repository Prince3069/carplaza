import 'dart:io';
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
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _formKey = GlobalKey<FormState>();
  List<File> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

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
      mobileBody: SingleChildScrollView(
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

              // Car Images
              _buildImageUploadSection(),
              const SizedBox(height: 20),

              // Car Details
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title*'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Description*'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => _description = value!,
              ),
              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Price (₦)*'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
                onSaved: (value) => _price = double.parse(value!),
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _location,
                items: _locations.map((location) {
                  return DropdownMenuItem(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _location = value!),
                decoration: const InputDecoration(labelText: 'Location*'),
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _brand,
                items: _brands.map((brand) {
                  return DropdownMenuItem(
                    value: brand,
                    child: Text(brand),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _brand = value!),
                decoration: const InputDecoration(labelText: 'Brand*'),
              ),
              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Model*'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => _model = value!,
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<int>(
                value: _year,
                items: List.generate(30, (index) {
                  int year = DateTime.now().year - index;
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year.toString()),
                  );
                }),
                onChanged: (value) => setState(() => _year = value!),
                decoration: const InputDecoration(labelText: 'Year*'),
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _condition,
                items: _conditions.map((condition) {
                  return DropdownMenuItem(
                    value: condition,
                    child: Text(condition),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _condition = value!),
                decoration: const InputDecoration(labelText: 'Condition*'),
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _transmission,
                items: _transmissions.map((transmission) {
                  return DropdownMenuItem(
                    value: transmission,
                    child: Text(transmission),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _transmission = value!),
                decoration: const InputDecoration(labelText: 'Transmission*'),
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _fuelType,
                items: _fuelTypes.map((fuelType) {
                  return DropdownMenuItem(
                    value: fuelType,
                    child: Text(fuelType),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _fuelType = value!),
                decoration: const InputDecoration(labelText: 'Fuel Type*'),
              ),
              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Mileage (km)*'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => _mileage = value!,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isUploading
                    ? null
                    : () => _submitForm(database, user?.uid),
                child: _isUploading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(width: 10),
                          Text('Submitting...'),
                        ],
                      )
                    : const Text('Submit Car Listing'),
              ),
            ],
          ),
        ),
      ),
      tabletBody: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Sell Your Car',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildImageUploadSection(),
                const SizedBox(height: 24),
                // [Rest of your tablet layout...]
              ],
            ),
          ),
        ),
      ),
      desktopBody: Center(
        child: SizedBox(
          width: 1000,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Sell Your Car',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _buildImageUploadSection(),
                  const SizedBox(height: 32),
                  // [Rest of your desktop layout...]
                ],
              ),
            ),
          ),
        ),
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
                      Image.file(
                        _imageFiles[index],
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
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

  Future<void> _submitForm(DatabaseService database, String? userId) async {
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

    setState(() => _isUploading = true);

    try {
      debugPrint('Starting car submission process');
      debugPrint('User ID: $userId');

      // Upload images
      List<String> imageUrls = [];
      debugPrint('Uploading ${_imageFiles.length} images');

      for (int i = 0; i < _imageFiles.length; i++) {
        final imageFile = _imageFiles[i];
        debugPrint(
            'Uploading image ${i + 1}/${_imageFiles.length}: ${imageFile.path}');

        try {
          final fileName =
              'car_${DateTime.now().millisecondsSinceEpoch}_${i}_${userId.substring(0, 4)}';
          final storageRef =
              FirebaseStorage.instance.ref().child('car_images/$fileName');

          debugPrint('Created storage reference: car_images/$fileName');
          final uploadTask = await storageRef.putFile(imageFile);
          debugPrint('Image uploaded, getting download URL');

          final downloadUrl = await uploadTask.ref.getDownloadURL();
          debugPrint('Got download URL: $downloadUrl');
          imageUrls.add(downloadUrl);
        } catch (imageError) {
          debugPrint('Error uploading image $i: $imageError');
          throw Exception('Failed to upload image ${i + 1}: $imageError');
        }
      }

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

      debugPrint('Created car object with data: ${newCar.toMap()}');

      // Save to Firestore
      final carId = await database.addCar(newCar);
      debugPrint('Car saved to database with ID: $carId');

      if (carId == null) {
        throw Exception('Failed to save car to database - returned null ID');
      }

      // Success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car listed successfully!')),
      );

      // Reset form
      _formKey.currentState!.reset();
      setState(() {
        _imageFiles = [];
        _isUploading = false;
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
      setState(() => _isUploading = false);
    }
  }
}
