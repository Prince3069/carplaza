import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/providers/car_provider.dart';
import 'package:car_plaza/utils/responsive.dart';
import 'package:car_plaza/widgets/adaptive/app_navigation.dart';
import 'package:car_plaza/widgets/car_card.dart';
import 'package:car_plaza/widgets/search_filter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;
  int _selectedIndex = 1; // Search tab index
  Map<String, dynamic> _currentFilters = {};

  @override
  void initState() {
    super.initState();
    final carProvider = Provider.of<CarProvider>(context, listen: false);
    carProvider.fetchAllCars();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    final carProvider = Provider.of<CarProvider>(context, listen: false);
    carProvider.searchCars(query);
  }

  void _handleFilterChanged(Map<String, dynamic> filters) {
    setState(() {
      _currentFilters = filters;
      _showFilters = false;
    });
    // Implement actual filtering logic here
    final carProvider = Provider.of<CarProvider>(context, listen: false);
    carProvider.applyFilters(filters);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final carProvider = Provider.of<CarProvider>(context);
    final isDesktop = responsive.isDesktop;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for cars...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _handleSearch(_searchController.text),
            ),
          ),
          onSubmitted: _handleSearch,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() => _showFilters = !_showFilters);
            },
          ),
        ],
      ),
      body: Row(
        children: [
          if (isDesktop)
            AppNavigation(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) {
                setState(() => _selectedIndex = index);
                // Handle navigation
              },
            ),
          Expanded(
            child: Column(
              children: [
                if (_showFilters)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SearchFilter(
                      onFilterChanged: _handleFilterChanged,
                    ),
                  ),
                Expanded(
                  child: carProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : carProvider.filteredCars.isEmpty
                          ? const Center(child: Text('No cars found'))
                          : GridView.builder(
                              padding: EdgeInsets.all(responsive.wp(3)),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: responsive.isDesktop
                                    ? 4
                                    : responsive.isTablet
                                        ? 3
                                        : 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: carProvider.filteredCars.length,
                              itemBuilder: (context, index) {
                                final car = carProvider.filteredCars[index];
                                return CarCard(car: car);
                              },
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: !isDesktop
          ? AppNavigation(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) {
                setState(() => _selectedIndex = index);
                // Handle navigation
              },
            )
          : null,
    );
  }
}
