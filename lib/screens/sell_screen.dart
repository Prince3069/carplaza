import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/widgets/app_bottom_nav.dart';
import 'package:car_plaza/widgets/image_picker.dart';
import 'package:car_plaza/providers/car_provider.dart';
import 'package:car_plaza/utils/responsive.dart';
import 'package:car_plaza/utils/validators.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final carProvider = Provider.of<CarProvider>(context, listen: false);

      await carProvider.uploadCar(
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        brand: _brandController.text,
        model: _modelController.text,
        year: int.parse(_yearController.text),
        location: _locationController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car listed successfully!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final carProvider = Provider.of<CarProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Your Car'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(responsive.wp(5)),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Car Images',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: responsive.hp(1)),
              const CarImagePicker(),
              SizedBox(height: responsive.hp(3)),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g. Toyota Camry 2015',
                ),
                validator: Validators.validateNotEmpty,
              ),
              SizedBox(height: responsive.hp(2)),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe your car in detail...',
                ),
                maxLines: 3,
                validator: Validators.validateNotEmpty,
              ),
              SizedBox(height: responsive.hp(2)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _brandController,
                      decoration: const InputDecoration(
                        labelText: 'Brand',
                        hintText: 'e.g. Toyota',
                      ),
                      validator: Validators.validateNotEmpty,
                    ),
                  ),
                  SizedBox(width: responsive.wp(3)),
                  Expanded(
                    child: TextFormField(
                      controller: _modelController,
                      decoration: const InputDecoration(
                        labelText: 'Model',
                        hintText: 'e.g. Camry',
                      ),
                      validator: Validators.validateNotEmpty,
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.hp(2)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _yearController,
                      decoration: const InputDecoration(
                        labelText: 'Year',
                        hintText: 'e.g. 2015',
                      ),
                      keyboardType: TextInputType.number,
                      validator: Validators.validateYear,
                    ),
                  ),
                  SizedBox(width: responsive.wp(3)),
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price (₦)',
                        hintText: 'e.g. 4500000',
                      ),
                      keyboardType: TextInputType.number,
                      validator: Validators.validatePrice,
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.hp(2)),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'e.g. Lagos, Nigeria',
                ),
                validator: Validators.validateNotEmpty,
              ),
              SizedBox(height: responsive.hp(3)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: carProvider.isUploading ? null : _submitForm,
                  child: carProvider.isUploading
                      ? const CircularProgressIndicator()
                      : const Text('List Car for Sale'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(selectedIndex: 2),
    );
  }
}
