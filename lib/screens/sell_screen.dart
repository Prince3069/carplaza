import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/services/database_service.dart';
import 'package:car_plaza/widgets/responsive_layout.dart';
import 'package:provider/provider.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _imagePaths = [];
  final ImagePicker _picker = ImagePicker();

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
                validator: (value) => value!.isEmpty ? 'Required' : null,
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
                onPressed: () => _submitForm(database),
                child: const Text('Submit Car Listing'),
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

                // Car Images
                _buildImageUploadSection(),
                const SizedBox(height: 24),

                // Car Details - Two columns for tablet
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Title*'),
                            validator: (value) =>
                                value!.isEmpty ? 'Required' : null,
                            onSaved: (value) => _title = value!,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Description*'),
                            maxLines: 4,
                            validator: (value) =>
                                value!.isEmpty ? 'Required' : null,
                            onSaved: (value) => _description = value!,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Price (₦)*'),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? 'Required' : null,
                            onSaved: (value) => _price = double.parse(value!),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _location,
                            items: _locations.map((location) {
                              return DropdownMenuItem(
                                value: location,
                                child: Text(location),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _location = value!),
                            decoration:
                                const InputDecoration(labelText: 'Location*'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _brand,
                            items: _brands.map((brand) {
                              return DropdownMenuItem(
                                value: brand,
                                child: Text(brand),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _brand = value!),
                            decoration:
                                const InputDecoration(labelText: 'Brand*'),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Model*'),
                            validator: (value) =>
                                value!.isEmpty ? 'Required' : null,
                            onSaved: (value) => _model = value!,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<int>(
                            value: _year,
                            items: List.generate(30, (index) {
                              int year = DateTime.now().year - index;
                              return DropdownMenuItem(
                                value: year,
                                child: Text(year.toString()),
                              );
                            }),
                            onChanged: (value) =>
                                setState(() => _year = value!),
                            decoration:
                                const InputDecoration(labelText: 'Year*'),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _condition,
                            items: _conditions.map((condition) {
                              return DropdownMenuItem(
                                value: condition,
                                child: Text(condition),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _condition = value!),
                            decoration:
                                const InputDecoration(labelText: 'Condition*'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Second row for tablet
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _transmission,
                            items: _transmissions.map((transmission) {
                              return DropdownMenuItem(
                                value: transmission,
                                child: Text(transmission),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _transmission = value!),
                            decoration: const InputDecoration(
                                labelText: 'Transmission*'),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Mileage (km)*'),
                            validator: (value) =>
                                value!.isEmpty ? 'Required' : null,
                            onSaved: (value) => _mileage = value!,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _fuelType,
                            items: _fuelTypes.map((fuelType) {
                              return DropdownMenuItem(
                                value: fuelType,
                                child: Text(fuelType),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _fuelType = value!),
                            decoration:
                                const InputDecoration(labelText: 'Fuel Type*'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _submitForm(database),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Submit Car Listing',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
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

                  // Car Images
                  _buildImageUploadSection(),
                  const SizedBox(height: 32),

                  // Car Details - Three columns for desktop
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Title*'),
                              validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                              onSaved: (value) => _title = value!,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Description*'),
                              maxLines: 5,
                              validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                              onSaved: (value) => _description = value!,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Price (₦)*'),
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                              onSaved: (value) => _price = double.parse(value!),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _location,
                              items: _locations.map((location) {
                                return DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                );
                              }).toList(),
                              onChanged: (value) =>
                                  setState(() => _location = value!),
                              decoration:
                                  const InputDecoration(labelText: 'Location*'),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _brand,
                              items: _brands.map((brand) {
                                return DropdownMenuItem(
                                  value: brand,
                                  child: Text(brand),
                                );
                              }).toList(),
                              onChanged: (value) =>
                                  setState(() => _brand = value!),
                              decoration:
                                  const InputDecoration(labelText: 'Brand*'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          children: [
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Model*'),
                              validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                              onSaved: (value) => _model = value!,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<int>(
                              value: _year,
                              items: List.generate(30, (index) {
                                int year = DateTime.now().year - index;
                                return DropdownMenuItem(
                                  value: year,
                                  child: Text(year.toString()),
                                );
                              }),
                              onChanged: (value) =>
                                  setState(() => _year = value!),
                              decoration:
                                  const InputDecoration(labelText: 'Year*'),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _condition,
                              items: _conditions.map((condition) {
                                return DropdownMenuItem(
                                  value: condition,
                                  child: Text(condition),
                                );
                              }).toList(),
                              onChanged: (value) =>
                                  setState(() => _condition = value!),
                              decoration: const InputDecoration(
                                  labelText: 'Condition*'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Second row for desktop
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: _transmission,
                              items: _transmissions.map((transmission) {
                                return DropdownMenuItem(
                                  value: transmission,
                                  child: Text(transmission),
                                );
                              }).toList(),
                              onChanged: (value) =>
                                  setState(() => _transmission = value!),
                              decoration: const InputDecoration(
                                  labelText: 'Transmission*'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: _fuelType,
                              items: _fuelTypes.map((fuelType) {
                                return DropdownMenuItem(
                                  value: fuelType,
                                  child: Text(fuelType),
                                );
                              }).toList(),
                              onChanged: (value) =>
                                  setState(() => _fuelType = value!),
                              decoration: const InputDecoration(
                                  labelText: 'Fuel Type*'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Mileage (km)*'),
                              validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                              onSaved: (value) => _mileage = value!,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => _submitForm(database),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Text('Submit Car Listing',
                        style: TextStyle(fontSize: 20)),
                  ),
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

        // Display selected images
        if (_imagePaths.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imagePaths.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.file(
                    _imagePaths[index] as File,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),

        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Add Image'),
            ),
            if (_imagePaths.isNotEmpty)
              TextButton(
                onPressed: () => setState(() => _imagePaths.clear()),
                child: const Text('Clear All'),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagePaths.add(pickedFile.path);
        });
      }
    } catch (e) {
      print('Image picker error: $e');
    }
  }

  Future<void> _submitForm(DatabaseService database) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_imagePaths.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload at least one image')),
        );
        return;
      }

      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );

        // Upload images to Firebase Storage
        List<String> imageUrls = await database.uploadCarImages(_imagePaths);

        // Create car object
        Car newCar = Car(
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
          sellerId: 'current_user_id', // Replace with actual user ID
          postedDate: DateTime.now(),
        );

        // Add car to Firestore
        await database.addCar(newCar);

        // Close loading dialog
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car listing submitted successfully!')),
        );

        // Clear form
        _formKey.currentState!.reset();
        setState(() {
          _imagePaths.clear();
          _location = 'Lagos';
          _brand = 'Toyota';
          _year = DateTime.now().year;
          _condition = 'Used';
          _transmission = 'Automatic';
          _fuelType = 'Petrol';
        });
      } catch (e) {
        // Close loading dialog
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting car: $e')),
        );
      }
    }
  }
}
