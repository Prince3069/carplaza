// SEARCH SCREEN
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/providers/car_provider.dart';
import 'package:car_plaza/screens/search/filter_screen.dart';
import 'package:car_plaza/widgets/car_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<CarModel> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchCars(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    final carProvider = Provider.of<CarProvider>(context, listen: false);
    final results = await carProvider.searchCars(query);

    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for cars...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _searchCars(_searchController.text),
            ),
          ),
          onSubmitted: _searchCars,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final filters = await Navigator.pushNamed(context, '/filter');
              if (filters != null) {
                // Apply filters
              }
            },
          ),
        ],
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? const Center(child: Text('Search for cars to see results'))
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final car = _searchResults[index];
                    return CarCard(
                      car: car,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/car-detail',
                          arguments: car,
                        );
                      },
                    );
                  },
                ),
    );
  }
}
