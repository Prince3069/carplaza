// File: lib/widgets/search_filter_bar.dart
import 'package:flutter/material.dart';

class SearchFilterBar extends StatefulWidget {
  const SearchFilterBar({super.key});

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  String _selectedSort = 'Newest';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFilterButton(
            icon: Icons.tune,
            label: 'Filters',
            onTap: () {
              // Show filter dialog
            },
          ),
          _buildFilterButton(
            icon: Icons.local_offer_outlined,
            label: 'Price',
            onTap: () {
              // Show price filter
            },
          ),
          _buildSortDropdown(),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButton<String>(
      value: _selectedSort,
      icon: const Icon(Icons.keyboard_arrow_down, size: 16),
      underline: Container(),
      isDense: true,
      items: ['Newest', 'Price: Low to High', 'Price: High to Low']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedSort = newValue!;
        });
      },
    );
  }
}
