// //import 'package:car_plaza/utils/responsive.dart';
// import 'package:car_plaza/widgets/responsive.dart';
// import 'package:flutter/material.dart';
// // import 'package:car_plaza/widgets/responsive_layout.dart';
// import 'package:car_plaza/models/car_model.dart';
// import 'package:car_plaza/services/database_service.dart';
// import 'package:provider/provider.dart';
// import 'package:car_plaza/widgets/car_item.dart';

// class SearchScreen extends StatelessWidget {
//   const SearchScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search Cars'),
//       ),
//       body: const SearchContent(),
//     );
//   }
// }

// class SearchContent extends StatefulWidget {
//   const SearchContent({super.key});

//   @override
//   State<SearchContent> createState() => _SearchContentState();
// }

// class _SearchContentState extends State<SearchContent> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
//     final database = Provider.of<DatabaseService>(context);

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               hintText: 'Search for cars...',
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.search),
//                 onPressed: () {
//                   setState(() {
//                     _searchQuery = _searchController.text;
//                   });
//                 },
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             onSubmitted: (value) {
//               setState(() {
//                 _searchQuery = value;
//               });
//             },
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: StreamBuilder<List<Car>>(
//               stream: database.searchCars(
//                   query: _searchQuery.isEmpty ? null : _searchQuery),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }

//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 List<Car> cars = snapshot.data ?? [];

//                 if (cars.isEmpty) {
//                   return const Center(child: Text('No cars found'));
//                 }

//                 return GridView.builder(
//                   padding: const EdgeInsets.only(bottom: 16),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
//                     childAspectRatio: 0.8,
//                     crossAxisSpacing: 16,
//                     mainAxisSpacing: 16,
//                   ),
//                   itemCount: cars.length,
//                   itemBuilder: (context, index) {
//                     return CarItem(car: cars[index]);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/services/database_service.dart';
import 'package:car_plaza/widgets/responsive.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;
  final String? initialLocation;

  const SearchScreen({
    super.key,
    this.initialQuery,
    this.initialLocation,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String _selectedLocation = 'All Nigeria';
  String _selectedBrand = 'All Brands';
  String _selectedBodyType = 'All Types';
  String _selectedFuelType = 'All Fuel Types';
  String _selectedTransmission = 'All Transmission';
  RangeValues _priceRange = const RangeValues(500000, 50000000);
  RangeValues _yearRange = const RangeValues(2000, 2025);
  bool _showFilters = false;
  String _sortBy = 'newest';

  final List<String> _locations = [
    'All Nigeria',
    'Lagos',
    'Abuja',
    'Kano',
    'Ibadan',
    'Port Harcourt',
    'Benin City',
    'Kaduna',
    'Jos',
    'Enugu'
  ];

  final List<String> _brands = [
    'All Brands',
    'Toyota',
    'Honda',
    'Mercedes-Benz',
    'BMW',
    'Audi',
    'Lexus',
    'Nissan',
    'Hyundai',
    'Kia',
    'Ford',
    'Chevrolet',
    'Volkswagen',
    'Peugeot'
  ];

  final List<String> _bodyTypes = [
    'All Types',
    'Sedan',
    'SUV',
    'Hatchback',
    'Coupe',
    'Convertible',
    'Wagon',
    'Pickup',
    'Van',
    'Bus'
  ];

  final List<String> _fuelTypes = [
    'All Fuel Types',
    'Petrol',
    'Diesel',
    'Hybrid',
    'Electric',
    'CNG'
  ];

  final List<String> _transmissions = [
    'All Transmission',
    'Automatic',
    'Manual',
    'CVT'
  ];

  final List<Map<String, String>> _sortOptions = [
    {'value': 'newest', 'label': 'Newest First'},
    {'value': 'oldest', 'label': 'Oldest First'},
    {'value': 'price_low', 'label': 'Price: Low to High'},
    {'value': 'price_high', 'label': 'Price: High to Low'},
    {'value': 'year_new', 'label': 'Year: Newest'},
    {'value': 'year_old', 'label': 'Year: Oldest'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      _searchQuery = widget.initialQuery!;
    }
    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseService>(context);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: _showFilters ? 320 : 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1E3A8A),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1E3A8A),
                      Color(0xFF3B82F6),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 60), // Space for app bar
                        _buildSearchSection(),
                        if (_showFilters) ...[
                          const SizedBox(height: 20),
                          _buildQuickFilters(),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            title: const Text(
              'Search Cars',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _showFilters ? Icons.filter_list_off : Icons.filter_list,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
              ),
            ],
          ),

          // Search Results Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'All Cars'
                          : 'Results for "$_searchQuery"',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildSortDropdown(),
                ],
              ),
            ),
          ),

          // Advanced Filters (when expanded)
          if (_showFilters)
            SliverToBoxAdapter(
              child: _buildAdvancedFilters(),
            ),

          // Search Results
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: StreamBuilder<List<Car>>(
              stream: _getFilteredCars(database),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: _buildErrorState(snapshot.error.toString()),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                List<Car> cars = snapshot.data ?? [];

                if (cars.isEmpty) {
                  return SliverToBoxAdapter(
                    child: _buildEmptyState(),
                  );
                }

                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return EnhancedCarItem(car: cars[index]);
                    },
                    childCount: cars.length,
                  ),
                );
              },
            ),
          ),

          // Footer space
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Location dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: DropdownButton<String>(
              value: _selectedLocation,
              underline: Container(),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: _locations.map((String location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLocation = newValue!;
                });
              },
            ),
          ),
          // Search field
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by brand, model...',
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Search button
          Container(
            margin: const EdgeInsets.all(4),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = _searchController.text;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Icon(Icons.search, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildQuickFilterChip('Brand', _selectedBrand, _brands),
          const SizedBox(width: 12),
          _buildQuickFilterChip('Body Type', _selectedBodyType, _bodyTypes),
          const SizedBox(width: 12),
          _buildQuickFilterChip('Fuel', _selectedFuelType, _fuelTypes),
          const SizedBox(width: 12),
          _buildPriceRangeChip(),
        ],
      ),
    );
  }

  Widget _buildQuickFilterChip(
      String label, String value, List<String> options) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: DropdownButton<String>(
        value: value,
        underline: Container(),
        icon: const Icon(Icons.keyboard_arrow_down,
            color: Colors.white, size: 16),
        dropdownColor: const Color(0xFF1E3A8A),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(
              option,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            if (label == 'Brand') _selectedBrand = newValue!;
            if (label == 'Body Type') _selectedBodyType = newValue!;
            if (label == 'Fuel') _selectedFuelType = newValue!;
          });
        },
        hint: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildPriceRangeChip() {
    return GestureDetector(
      onTap: () => _showPriceRangeDialog(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Price Range',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down,
                color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: _sortBy,
        underline: Container(),
        icon: const Icon(Icons.sort, size: 16),
        items: _sortOptions.map((option) {
          return DropdownMenuItem<String>(
            value: option['value'],
            child: Text(
              option['label']!,
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _sortBy = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildAdvancedFilters() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Advanced Filters',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Price Range
          const Text('Price Range',
              style: TextStyle(fontWeight: FontWeight.w600)),
          RangeSlider(
            values: _priceRange,
            min: 100000,
            max: 100000000,
            divisions: 100,
            labels: RangeLabels(
              '₦${(_priceRange.start / 1000000).toStringAsFixed(1)}M',
              '₦${(_priceRange.end / 1000000).toStringAsFixed(1)}M',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),

          const SizedBox(height: 20),

          // Year Range
          const Text('Year Range',
              style: TextStyle(fontWeight: FontWeight.w600)),
          RangeSlider(
            values: _yearRange,
            min: 1990,
            max: 2025,
            divisions: 35,
            labels: RangeLabels(
              _yearRange.start.round().toString(),
              _yearRange.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _yearRange = values;
              });
            },
          ),

          const SizedBox(height: 20),

          // Transmission
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Transmission',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    DropdownButton<String>(
                      value: _selectedTransmission,
                      isExpanded: true,
                      items: _transmissions.map((String transmission) {
                        return DropdownMenuItem<String>(
                          value: transmission,
                          child: Text(transmission),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTransmission = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Reset and Apply buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetFilters,
                  child: const Text('Reset Filters'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showFilters = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                  ),
                  child: const Text('Apply Filters',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {}); // Refresh
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No cars found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your search criteria or filters',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _resetFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
              ),
              child: const Text('Clear Filters',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showPriceRangeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Price Range'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '₦${(_priceRange.start / 1000000).toStringAsFixed(1)}M - ₦${(_priceRange.end / 1000000).toStringAsFixed(1)}M',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 100000,
                    max: 100000000,
                    divisions: 100,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {}); // Refresh main screen
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _resetFilters() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _selectedLocation = 'All Nigeria';
      _selectedBrand = 'All Brands';
      _selectedBodyType = 'All Types';
      _selectedFuelType = 'All Fuel Types';
      _selectedTransmission = 'All Transmission';
      _priceRange = const RangeValues(500000, 50000000);
      _yearRange = const RangeValues(2000, 2025);
      _sortBy = 'newest';
    });
  }

  Stream<List<Car>> _getFilteredCars(DatabaseService database) {
    // This method should be implemented to handle filtering
    // For now, returning the basic search functionality
    return database.searchCars(
      query: _searchQuery.isEmpty ? null : _searchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// Enhanced Car Item Widget (reused from home screen)
class EnhancedCarItem extends StatelessWidget {
  final Car car;

  const EnhancedCarItem({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car image
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: car.images.isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.network(
                            car.images.first,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.car_rental,
                                    size: 40, color: Colors.grey),
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.car_rental,
                              size: 40, color: Colors.grey),
                        ),
                ),
                // Popular badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'POPULAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Verified badge
                if (car.isVerified)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                // Rating
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 12),
                        Text(
                          ' 4.8',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Car details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₦${car.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${car.brand} ${car.model} ${car.year}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          car.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
