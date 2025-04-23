// File: lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:car_plaza/widgets/search_filter_bar.dart';
import 'package:car_plaza/widgets/car_list_item.dart';
import 'package:car_plaza/models/car.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Car> _searchResults = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    // Implement search functionality
    setState(() {
      _isLoading = true;
    });

    // Simulate search with dummy data
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _searchResults = List.generate(
          10,
          (index) => Car(
            id: 'car_$index',
            title: 'Toyota Camry 2022',
            price: 25000 + (index * 1000),
            location: 'New York',
            imageUrl: 'https://via.placeholder.com/300',
          ),
        );
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search cars...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
            ),
          ),
          onSubmitted: _performSearch,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter dialog
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SearchFilterBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? const Center(
                        child: Text('No cars found. Try a different search.'),
                      )
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return CarListItem(car: _searchResults[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
