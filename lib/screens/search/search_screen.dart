import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/screens/car_details/car_details_screen.dart';
import 'package:car_plaza/services/firestore_service.dart';
import 'package:car_plaza/utils/constants.dart';
import 'package:car_plaza/widgets/car_card.dart';
import 'package:car_plaza/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CarModel> _searchResults = [];
  bool _isSearching = false;
  bool _showFilters = false;

  // Filter variables
  String? _selectedBrand;
  String? _selectedModel;
  int? _minYear;
  int? _maxYear;
  double? _minPrice;
  double? _maxPrice;
  String? _selectedLocation;
  String? _selectedTransmission;
  String? _selectedFuelType;

  Future<void> _searchCars() async {
    if (_searchController.text.isEmpty && !_showFilters) return;

    setState(() => _isSearching = true);

    try {
      final firestoreService =
          Provider.of<FirestoreService>(context, listen: false);
      final results = await firestoreService.searchCars(
        brand: _selectedBrand,
        model: _selectedModel,
        minYear: _minYear,
        maxYear: _maxYear,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        location: _selectedLocation,
        transmission: _selectedTransmission,
        fuelType: _selectedFuelType,
      );

      // Additional filtering by search text if provided
      final searchText = _searchController.text.toLowerCase();
      if (searchText.isNotEmpty) {
        results.retainWhere((car) =>
            car.brand.toLowerCase().contains(searchText) ||
            car.model.toLowerCase().contains(searchText) ||
            car.title.toLowerCase().contains(searchText) ||
            car.description.toLowerCase().contains(searchText));
      }

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search failed: $e')),
      );
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedBrand = null;
      _selectedModel = null;
      _minYear = null;
      _maxYear = null;
      _minPrice = null;
      _maxPrice = null;
      _selectedLocation = null;
      _selectedTransmission = null;
      _selectedFuelType = null;
      _searchController.clear();
      _searchResults.clear();
      _showFilters = false;
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
              icon: const Icon(Icons.search),
              onPressed: _searchCars,
            ),
          ),
          onSubmitted: (_) => _searchCars(),
        ),
        actions: [
          IconButton(
            icon: Icon(
                _showFilters ? Icons.filter_alt : Icons.filter_alt_outlined),
            onPressed: () {
              setState(() => _showFilters = !_showFilters);
              if (_showFilters) _searchCars();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showFilters) _buildFiltersSection(),
          Expanded(
            child: _isSearching
                ? _buildLoadingIndicator()
                : _searchResults.isEmpty
                    ? _buildEmptyState()
                    : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedBrand,
                  decoration: const InputDecoration(labelText: 'Brand'),
                  items: AppConstants.popularBrands
                      .map((brand) => DropdownMenuItem(
                            value: brand,
                            child: Text(brand),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedBrand = value);
                    _searchCars();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedLocation,
                  decoration: const InputDecoration(labelText: 'Location'),
                  items: AppConstants.nigerianStates
                      .map((state) => DropdownMenuItem(
                            value: state,
                            child: Text(state),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedLocation = value);
                    _searchCars();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Min Price (₦)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() => _minPrice = double.tryParse(value));
                    _searchCars();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Max Price (₦)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() => _maxPrice = double.tryParse(value));
                    _searchCars();
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
                  value: _selectedTransmission,
                  decoration: const InputDecoration(labelText: 'Transmission'),
                  items: ['Automatic', 'Manual']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedTransmission = value);
                    _searchCars();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedFuelType,
                  decoration: const InputDecoration(labelText: 'Fuel Type'),
                  items: ['Petrol', 'Diesel', 'Hybrid', 'Electric']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedFuelType = value);
                    _searchCars();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _clearFilters,
                child: const Text('Clear Filters'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, index) => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: ShimmerCard(height: 120),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No cars found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (_, index) {
        final car = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CarCard(
            car: car,
            horizontal: true,
            onTap: () => Navigator.pushNamed(
              context,
              Routes.carDetails,
              arguments: car.id,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
