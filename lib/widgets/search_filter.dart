// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:car_plaza/utils/responsive.dart';

class SearchFilter extends StatefulWidget {
  final Function(Map<String, dynamic>) onFilterChanged;

  const SearchFilter({super.key, required this.onFilterChanged});

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  final _locationController = TextEditingController();
  RangeValues _yearRange = const RangeValues(2010, 2023);

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final filters = {
      'brand': _brandController.text.trim(),
      'model': _modelController.text.trim(),
      'minPrice': _minPriceController.text.trim().isEmpty
          ? null
          : double.tryParse(_minPriceController.text.trim()),
      'maxPrice': _maxPriceController.text.trim().isEmpty
          ? null
          : double.tryParse(_maxPriceController.text.trim()),
      'minYear': _yearRange.start.round(),
      'maxYear': _yearRange.end.round(),
      'location': _locationController.text.trim(),
    };
    widget.onFilterChanged(filters);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Cars',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: 'Brand',
                hintText: 'e.g. Toyota',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: 'Model',
                hintText: 'e.g. Camry',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _minPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Min Price (₦)',
                      hintText: 'e.g. 1000000',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _maxPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Max Price (₦)',
                      hintText: 'e.g. 5000000',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Year Range: ${_yearRange.start.round()} - ${_yearRange.end.round()}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            RangeSlider(
              values: _yearRange,
              min: 1990,
              max: DateTime.now().year.toDouble(),
              divisions: DateTime.now().year - 1990,
              labels: RangeLabels(
                _yearRange.start.round().toString(),
                _yearRange.end.round().toString(),
              ),
              onChanged: (values) {
                setState(() => _yearRange = values);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'e.g. Lagos',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
