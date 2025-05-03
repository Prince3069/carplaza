import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/services/firestore_service.dart';
import 'package:car_plaza/services/storage_service.dart';
import 'package:car_plaza/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadCarScreen extends StatefulWidget {
  const UploadCarScreen({Key? key}) : super(key: key);

  @override
  State<UploadCarScreen> createState() => _UploadCarScreenState();
}

class _UploadCarScreenState extends State<UploadCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  List<XFile> _images = [];
  bool _isLoading = false;

  // Form fields
  String _title = '';
  String _description = '';
  String _brand = '';
  String _model = '';
  int _year = DateTime.now().year;
  double _price = 0;
  String _location = '';
  double _mileage = 0;
  String _transmission = 'Automatic';
  String _fuelType = 'Petrol';
  String _condition = 'Used';
  String? _color;

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (pickedFiles != null) {
        setState(() {
          _images.addAll(pickedFiles);
          if (_images.length > 10) {
            _images = _images.sublist(0, 10);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Maximum 10 images allowed')),
            );
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick images: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload at least one image')),
      );
      return;
    }

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      final firestoreService =
          Provider.of<FirestoreService>(context, listen: false);
      final storageService =
          Provider.of<StorageService>(context, listen: false);
      final auth = Provider.of<AuthService>(context, listen: false);
      final currentUser = await auth.getCurrentUser();

      if (currentUser == null) throw Exception('User not logged in');

      // Create car model
      final car = CarModel(
        id: '', // Will be set by Firestore
        sellerId: currentUser.id,
        title: _title,
        description: _description,
        brand: _brand,
        model: _model,
        year: _year,
        price: _price,
        location: _location,
        images: [], // Will be set after upload
        postedAt: DateTime.now(),
        isFeatured: false,
        isSold: false,
        mileage: _mileage,
        transmission: _transmission,
        fuelType: _fuelType,
        condition: _condition,
        color: _color,
      );

      // Add car to Firestore to get ID
      final carId = await firestoreService.addCar(car);

      // Upload images
      final imageUrls = await storageService.uploadCarImages(carId, _images);

      // Update car with image URLs
      final updatedCar = car.copyWith(id: carId, images: imageUrls);
      await firestoreService.updateCar(updatedCar);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car listed successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to list car: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Your Car'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isLoading ? null : _submitForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image upload section
                    _buildImageUploadSection(),
                    const SizedBox(height: 20),

                    // Car details form
                    CustomTextField(
                      label: 'Title',
                      hint: 'e.g. Toyota Camry 2015',
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                      onSaved: (value) => _title = value!,
                    ),
                    const SizedBox(height: 12),

                    CustomTextField(
                      label: 'Description',
                      hint: 'Describe your car in detail',
                      maxLines: 4,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                      onSaved: (value) => _description = value!,
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Brand',
                            hint: 'e.g. Toyota',
                            validator: (value) =>
                                value!.isEmpty ? 'Required' : null,
                            onSaved: (value) => _brand = value!,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            label: 'Model',
                            hint: 'e.g. Camry',
                            validator: (value) =>
                                value!.isEmpty ? 'Required' : null,
                            onSaved: (value) => _model = value!,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // More form fields...
                    // Add similar fields for year, price, location, etc.

                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('List My Car'),
                    ),
                  ],
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
          'Car Images',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Upload clear photos (${_images.length}/10)',
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),

        // Image grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _images.length + 1,
          itemBuilder: (context, index) {
            if (index == _images.length) {
              return _buildAddImageButton();
            }
            return _buildImageThumbnail(_images[index]);
          },
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(XFile image) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(image.path),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _images.removeAt(_images.indexOf(image));
              });
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black54,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
