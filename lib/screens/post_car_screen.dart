// File: lib/screens/post_car_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostCarScreen extends StatefulWidget {
  const PostCarScreen({super.key});

  @override
  State<PostCarScreen> createState() => _PostCarScreenState();
}

class _PostCarScreenState extends State<PostCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<File> _images = [];
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedMake = 'Toyota';
  String _selectedModel = 'Camry';
  String _selectedYear = '2022';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> selectedImages = await picker.pickMultiImage();

    if (selectedImages.isNotEmpty) {
      setState(() {
        for (var image in selectedImages) {
          _images.add(File(image.path));
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _images.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      // Simulate form submission
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car listing submitted successfully!')),
        );
        _resetForm();
      });
    } else if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one image')),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _images.clear();
      _titleController.clear();
      _priceController.clear();
      _descriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Your Car'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Car Images',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _images.isEmpty
                          ? Center(
                              child: TextButton.icon(
                                onPressed: _pickImages,
                                icon: const Icon(Icons.add_a_photo),
                                label: const Text('Add Photos'),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _images.length + 1,
                              itemBuilder: (context, index) {
                                if (index == _images.length) {
                                  return InkWell(
                                    onTap: _pickImages,
                                    child: Container(
                                      width: 100,
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.add),
                                    ),
                                  );
                                }
                                return Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: FileImage(_images[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.remove_circle,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _images.removeAt(index);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText:
                            'e.g., Toyota Camry 2022 - Excellent Condition',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedMake,
                            decoration: const InputDecoration(
                              labelText: 'Make',
                              border: OutlineInputBorder(),
                            ),
                            items:
                                ['Toyota', 'Honda', 'Ford', 'BMW', 'Mercedes']
                                    .map((make) => DropdownMenuItem<String>(
                                          value: make,
                                          child: Text(make),
                                        ))
                                    .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedMake = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedModel,
                            decoration: const InputDecoration(
                              labelText: 'Model',
                              border: OutlineInputBorder(),
                            ),
                            items:
                                ['Camry', 'Corolla', 'Civic', 'Accord', 'F-150']
                                    .map((model) => DropdownMenuItem<String>(
                                          value: model,
                                          child: Text(model),
                                        ))
                                    .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedModel = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedYear,
                            decoration: const InputDecoration(
                              labelText: 'Year',
                              border: OutlineInputBorder(),
                            ),
                            items: ['2024', '2023', '2022', '2021', '2020']
                                .map((year) => DropdownMenuItem<String>(
                                      value: year,
                                      child: Text(year),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedYear = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Price (USD)',
                              border: OutlineInputBorder(),
                              prefixText: '\$ ',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a price';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText:
                            'Describe your car, including condition, features, etc.',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Post Car For Sale'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
