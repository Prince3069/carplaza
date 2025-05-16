// import 'package:flutter/material.dart';
// import 'package:car_plaza/widgets/responsive_layout.dart';

// class SearchScreen extends StatelessWidget {
//   const SearchScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveLayout(
//       mobileBody: SearchContent(),
//       tabletBody: SearchContent(),
//       desktopBody: SearchContent(),
//     );
//   }
// }

// class SearchContent extends StatefulWidget {
//   @override
//   _SearchContentState createState() => _SearchContentState();
// }

// class _SearchContentState extends State<SearchContent> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
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
//             child: _buildSearchResults(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchResults() {
//     // In a real app, you would query Firestore with the search query
//     if (_searchQuery.isEmpty) {
//       return const Center(
//         child: Text('Enter a search term to find cars'),
//       );
//     }

//     // Mock search results - replace with actual Firestore query
//     return ListView(
//       children: [
//         ListTile(
//           leading: const Icon(Icons.car_rental),
//           title: Text('Toyota Camry - $_searchQuery'),
//           subtitle: const Text('₦5,000,000 - Lagos'),
//         ),
//         ListTile(
//           leading: const Icon(Icons.car_rental),
//           title: Text('Honda Accord - $_searchQuery'),
//           subtitle: const Text('₦4,500,000 - Abuja'),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
// }

import 'package:car_plaza/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:car_plaza/widgets/responsive_layout.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/widgets/car_item.dart';
// import 'package:car_plaza/app_colors.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: const SearchContent(),
      tabletBody: const SearchContent(),
      desktopBody: Center(
        child: SizedBox(
          width: 1000,
          child: SearchContent(),
        ),
      ),
    );
  }
}

class SearchContent extends StatefulWidget {
  const SearchContent({super.key});

  @override
  _SearchContentState createState() => _SearchContentState();
}

class _SearchContentState extends State<SearchContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedBrand;
  String? _selectedLocation;
  double? _minPrice;
  double? _maxPrice;
  int? _minYear;
  int? _maxYear;
  bool _isFilterActive = false;

  final List<String> _brands = [
    'Toyota',
    'Honda',
    'Nissan',
    'Mercedes',
    'BMW',
    'Lexus',
    'Audi',
    'Ford',
    'Volkswagen',
    'Hyundai',
    'Kia',
    'Chevrolet'
  ];

  final List<String> _locations = [
    'Lagos',
    'Abuja',
    'Port Harcourt',
    'Kano',
    'Enugu',
    'Ibadan',
    'Benin',
    'Calabar',
    'Uyo',
    'Warri'
  ];

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseService>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar with filter button
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by make, model, or keyword...',
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.primaryColor),
                    suffixIcon: _buildFilterButton(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: AppColors.primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      _searchQuery = value.trim();
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Active filters chips
          if (_isFilterActive) _buildActiveFiltersChips(),

          const SizedBox(height: 16),

          // Search results
          Expanded(
            child: StreamBuilder<List<Car>>(
              stream: database.searchCars(
                query: _searchQuery.isEmpty ? null : _searchQuery,
                brand: _selectedBrand,
                location: _selectedLocation,
                minPrice: _minPrice,
                maxPrice: _maxPrice,
                minYear: _minYear,
                maxYear: _maxYear,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading cars',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.primaryColor),
                    ),
                  );
                }

                List<Car> cars = snapshot.data ?? [];

                if (cars.isEmpty) {
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
                          _searchQuery.isEmpty && !_isFilterActive
                              ? 'Search for cars'
                              : 'No cars found matching your search',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        if (_searchQuery.isEmpty && !_isFilterActive)
                          const Text(
                            'Try searching by make, model, or location',
                            style: TextStyle(color: Colors.grey),
                          ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  color: AppColors.primaryColor,
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(context),
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      return CarItem(car: cars[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return IconButton(
      icon: Stack(
        children: [
          const Icon(Icons.filter_alt_outlined, color: AppColors.primaryColor),
          if (_isFilterActive)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 12,
                  minHeight: 12,
                ),
              ),
            ),
        ],
      ),
      onPressed: _showFilterDialog,
    );
  }

  Widget _buildActiveFiltersChips() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (_selectedBrand != null)
            _buildFilterChip(
              label: 'Brand: $_selectedBrand',
              onDeleted: () => _removeFilter('brand'),
            ),
          if (_selectedLocation != null)
            _buildFilterChip(
              label: 'Location: $_selectedLocation',
              onDeleted: () => _removeFilter('location'),
            ),
          if (_minPrice != null)
            _buildFilterChip(
              label: 'Min: ₦${_minPrice!.toStringAsFixed(0)}',
              onDeleted: () => _removeFilter('minPrice'),
            ),
          if (_maxPrice != null)
            _buildFilterChip(
              label: 'Max: ₦${_maxPrice!.toStringAsFixed(0)}',
              onDeleted: () => _removeFilter('maxPrice'),
            ),
          if (_minYear != null)
            _buildFilterChip(
              label: 'From: $_minYear',
              onDeleted: () => _removeFilter('minYear'),
            ),
          if (_maxYear != null)
            _buildFilterChip(
              label: 'To: $_maxYear',
              onDeleted: () => _removeFilter('maxYear'),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      {required String label, required VoidCallback onDeleted}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onDeleted,
        backgroundColor: AppColors.primaryColor.withOpacity(0.1),
        labelStyle: const TextStyle(color: AppColors.primaryColor),
      ),
    );
  }

  Future<void> _showFilterDialog() async {
    final minPriceController = TextEditingController(
        text: _minPrice != null ? _minPrice!.toStringAsFixed(0) : '');
    final maxPriceController = TextEditingController(
        text: _maxPrice != null ? _maxPrice!.toStringAsFixed(0) : '');
    final minYearController = TextEditingController(
        text: _minYear != null ? _minYear!.toString() : '');
    final maxYearController = TextEditingController(
        text: _maxYear != null ? _maxYear!.toString() : '');

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filter Cars'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedBrand,
                      items: _brands.map((brand) {
                        return DropdownMenuItem(
                          value: brand,
                          child: Text(brand),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBrand = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Brand',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedLocation,
                      items: _locations.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLocation = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              controller: minPriceController,
                              decoration: const InputDecoration(
                                labelText: 'Min Price (₦)',
                                border: OutlineInputBorder(),
                                prefixText: '₦ ',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  _minPrice = double.tryParse(value);
                                } else {
                                  _minPrice = null;
                                }
                              }),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: maxPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Max Price (₦)',
                              border: OutlineInputBorder(),
                              prefixText: '₦ ',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                _maxPrice = double.tryParse(value);
                              } else {
                                _maxPrice = null;
                              }
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
                            controller: minYearController,
                            decoration: const InputDecoration(
                              labelText: 'Min Year',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                _minYear = int.tryParse(value);
                              } else {
                                _minYear = null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: maxYearController,
                            decoration: const InputDecoration(
                              labelText: 'Max Year',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                _maxYear = int.tryParse(value);
                              } else {
                                _maxYear = null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedBrand = null;
                      _selectedLocation = null;
                      _minPrice = null;
                      _maxPrice = null;
                      _minYear = null;
                      _maxYear = null;
                      minPriceController.clear();
                      maxPriceController.clear();
                      minYearController.clear();
                      maxYearController.clear();
                      _isFilterActive = false;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Reset All'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isFilterActive = _selectedBrand != null ||
                          _selectedLocation != null ||
                          _minPrice != null ||
                          _maxPrice != null ||
                          _minYear != null ||
                          _maxYear != null;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: const Text('Apply Filters',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );

    minPriceController.dispose();
    maxPriceController.dispose();
    minYearController.dispose();
    maxYearController.dispose();
  }

  void _removeFilter(String filterType) {
    setState(() {
      switch (filterType) {
        case 'brand':
          _selectedBrand = null;
          break;
        case 'location':
          _selectedLocation = null;
          break;
        case 'minPrice':
          _minPrice = null;
          break;
        case 'maxPrice':
          _maxPrice = null;
          break;
        case 'minYear':
          _minYear = null;
          break;
        case 'maxYear':
          _maxYear = null;
          break;
      }
      _isFilterActive = _selectedBrand != null ||
          _selectedLocation != null ||
          _minPrice != null ||
          _maxPrice != null ||
          _minYear != null ||
          _maxYear != null;
    });
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
