import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/widgets/app_bottom_nav.dart';
import 'package:car_plaza/widgets/car_card.dart';
import 'package:car_plaza/widgets/search_filter.dart';
import 'package:car_plaza/providers/car_provider.dart';
import 'package:car_plaza/utils/responsive.dart';
import 'package:car_plaza/models/car_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

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

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final carProvider = Provider.of<CarProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for cars...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                carProvider.searchCars(_searchController.text);
              },
            ),
          ),
          onSubmitted: (value) {
            carProvider.searchCars(value);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showFilters) const SearchFilter(),
          Expanded(
            child: carProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : carProvider.filteredCars.isEmpty
                    ? const Center(child: Text('No cars found'))
                    : GridView.builder(
                        padding: EdgeInsets.all(responsive.wp(3)),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
      bottomNavigationBar: const AppBottomNav(selectedIndex: 1),
    );
  }
}
