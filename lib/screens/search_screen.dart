// =================== lib/screens/search/search_screen.dart ===================

import 'package:flutter/material.dart';
import '../../services/car_service.dart';
import '../../models/car.dart';
import '../../widgets/car_card.dart';
import '../../widgets/bottom_nav_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final CarService _carService = CarService();
  List<Car> _searchResults = [];

  String _make = '';
  String _model = '';
  double _minPrice = 0;
  double _maxPrice = 100000; // Default high max price

  int _currentIndex = 1;
  bool _isLoading = false;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
        break; // Already on Search
      case 2:
        Navigator.pushNamed(context, '/sell');
        break;
      case 3:
        Navigator.pushNamed(context, '/messages');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  Future<void> _search() async {
    setState(() => _isLoading = true);

    List<Car> cars = await _carService.searchCars(make: _make, model: _model);
    // Apply price range manually
    cars = cars
        .where((car) => car.price >= _minPrice && car.price <= _maxPrice)
        .toList();

    setState(() {
      _searchResults = cars;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Cars'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Make'),
              onChanged: (value) {
                _make = value.trim();
              },
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(labelText: 'Model'),
              onChanged: (value) {
                _model = value.trim();
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Min Price'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _minPrice = double.tryParse(value) ?? 0;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Max Price'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _maxPrice = double.tryParse(value) ?? 100000;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _search,
              child: const Text('Search'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                      ? const Center(child: Text('No cars found'))
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            return CarCard(car: _searchResults[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

// =============================================================
