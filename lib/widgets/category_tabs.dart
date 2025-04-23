// File: lib/widgets/category_tabs.dart
import 'package:flutter/material.dart';
import 'package:car_plaza/models/car.dart';
import 'package:car_plaza/services/car_service.dart';
import 'package:car_plaza/widgets/car_grid_item.dart';
import 'package:shimmer/shimmer.dart';

class CategoryTabs extends StatefulWidget {
  const CategoryTabs({super.key});

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CarService _carService = CarService();
  final List<String> _categories = [
    'Toyota',
    'Honda',
    'Ford',
    'BMW',
    'Mercedes'
  ];
  late Map<String, Future<List<Car>>> _categoryCars;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _categoryCars = {
      for (var category in _categories)
        category: _carService.getCarsByCategory(category)
    };
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: _categories.map((category) => Tab(text: category)).toList(),
        ),
        SizedBox(
          height: 260,
          child: TabBarView(
            controller: _tabController,
            children: _categories.map((category) {
              return FutureBuilder<List<Car>>(
                future: _categoryCars[category],
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingShimmer();
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No cars found in this category'));
                  } else {
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount:
                          snapshot.data!.length > 4 ? 4 : snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return CarGridItem(car: snapshot.data![index]);
                      },
                    );
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      ),
    );
  }
}
