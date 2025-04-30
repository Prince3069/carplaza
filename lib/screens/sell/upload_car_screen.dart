import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:car_plaza/models/car_model.dart';

class UploadCarScreen extends StatefulWidget {
  const UploadCarScreen({super.key});

  @override
  State<UploadCarScreen> createState() => _UploadCarScreenState();
}

class _UploadCarScreenState extends State<UploadCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _images = [];
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCondition = 'Used';
  String _selectedTransmission = 'Automatic';
  String _selectedFuelType = 'Petrol';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Your Car')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Image Upload Section
              const Text('Upload Car Photos', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.isEmpty ? 1 : _images.length + 1,
                  itemBuilder: (ctx, index) {
                    if (index == 0 || _images.isEmpty) {
                      return GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add_a_photo, size: 40),
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(_images[index - 1]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(index - 1),
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Car Details Form
              TextFormField(
                controller: _makeController,
                decoration:
                    const InputDecoration(labelText: 'Make (e.g. Toyota)'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: _modelController,
                decoration:
                    const InputDecoration(labelText: 'Model (e.g. Camry)'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: _mileageController,
                decoration: const InputDecoration(labelText: 'Mileage (km)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCondition,
                items: ['New', 'Used', 'Foreign Used']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedCondition = value!),
                decoration: const InputDecoration(labelText: 'Condition'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedTransmission,
                items: ['Automatic', 'Manual']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedTransmission = value!),
                decoration: const InputDecoration(labelText: 'Transmission'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedFuelType,
                items: ['Petrol', 'Diesel', 'Hybrid', 'Electric']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedFuelType = value!),
                decoration: const InputDecoration(labelText: 'Fuel Type'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 24),
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(pickedFile.path); // In real app, upload to Firebase Storage
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _images.isNotEmpty) {
      // Create CarModel and save to Firestore
      final newCar = CarModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sellerId: 'current-user-id', // Replace with actual user ID
        make: _makeController.text,
        model: _modelController.text,
        year: int.parse(_yearController.text),
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        images: _images,
        location: 'Lagos, Nigeria', // Get from user or GPS
        createdAt: DateTime.now(),
        isFeatured: false,
        condition: _selectedCondition,
        mileage: double.parse(_mileageController.text),
        transmission: _selectedTransmission,
        fuelType: _selectedFuelType,
        color: 'Black', // Add color picker if needed
      );

      // Save car and navigate back
      Navigator.pop(context);
    } else if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload at least one image')),
      );
    }
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _mileageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
