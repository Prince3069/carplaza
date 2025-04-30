// TODO Implement this library.
// lib/screens/search/filter_screen.dart
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final Map<String, dynamic>? filters;

  const FilterScreen({Key? key, this.filters}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late Map<String, dynamic> _currentFilters;

  @override
  void initState() {
    super.initState();
    _currentFilters = widget.filters ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [
          TextButton(
            onPressed: () {
              // Clear all filters
              setState(() {
                _currentFilters.clear();
              });
            },
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Add your filter widgets here (price range, year range, make, model, etc.)
          // Example:
          const Text('Price Range',
              style: TextStyle(fontWeight: FontWeight.bold)),
          RangeSlider(
            values: RangeValues(
              _currentFilters['minPrice']?.toDouble() ?? 0,
              _currentFilters['maxPrice']?.toDouble() ?? 100000,
            ),
            min: 0,
            max: 100000,
            divisions: 20,
            labels: RangeLabels(
              '\$${_currentFilters['minPrice']?.toString() ?? '0'}',
              '\$${_currentFilters['maxPrice']?.toString() ?? '100000'}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentFilters['minPrice'] = values.start.round();
                _currentFilters['maxPrice'] = values.end.round();
              });
            },
          ),
          // Add more filters as needed
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, _currentFilters);
          },
          child: const Text('Apply Filters'),
        ),
      ),
    );
  }
}
