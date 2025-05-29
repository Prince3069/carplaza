import 'package:flutter/material.dart';

class DesktopFilterSidebar extends StatefulWidget {
  const DesktopFilterSidebar({super.key});

  @override
  State<DesktopFilterSidebar> createState() => _DesktopFilterSidebarState();
}

class _DesktopFilterSidebarState extends State<DesktopFilterSidebar> {
  double _minPrice = 0;
  double _maxPrice = 10000000;
  int _minYear = 1990;
  int _maxYear = DateTime.now().year;
  String? _selectedBrand;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filters',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildPriceFilter(),
          const SizedBox(height: 20),
          _buildYearFilter(),
          const SizedBox(height: 20),
          _buildBrandFilter(),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Price Range'),
        RangeSlider(
          values: RangeValues(_minPrice, _maxPrice),
          min: 0,
          max: 10000000,
          divisions: 10,
          labels: RangeLabels(
            '₦${_minPrice.toStringAsFixed(0)}',
            '₦${_maxPrice.toStringAsFixed(0)}',
          ),
          onChanged: (values) {
            setState(() {
              _minPrice = values.start;
              _maxPrice = values.end;
            });
          },
        ),
      ],
    );
  }

  Widget _buildYearFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Year Range'),
        RangeSlider(
          values: RangeValues(_minYear.toDouble(), _maxYear.toDouble()),
          min: 1990,
          max: DateTime.now().year.toDouble(),
          divisions: DateTime.now().year - 1990,
          labels: RangeLabels(
            _minYear.toString(),
            _maxYear.toString(),
          ),
          onChanged: (values) {
            setState(() {
              _minYear = values.start.toInt();
              _maxYear = values.end.toInt();
            });
          },
        ),
      ],
    );
  }

  Widget _buildBrandFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Brand'),
        DropdownButtonFormField<String>(
          value: _selectedBrand,
          items: const [
            DropdownMenuItem(value: 'Toyota', child: Text('Toyota')),
            DropdownMenuItem(value: 'Honda', child: Text('Honda')),
            DropdownMenuItem(value: 'BMW', child: Text('BMW')),
            DropdownMenuItem(value: 'Mercedes', child: Text('Mercedes')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedBrand = value;
            });
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
      ],
    );
  }
}
