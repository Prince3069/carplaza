// File: lib/widgets/recent_cars_grid.dart
import 'package:flutter/material.dart';
import 'package:car_plaza/models/car.dart';
import 'package:car_plaza/services/car_service.dart';
import 'package:car_plaza/widgets/car_grid_item.dart';
import 'package:shimmer/shimmer.dart';

class RecentCarsGrid extends StatefulWidget {
  const RecentCarsGrid({super.key});

  @override
  State<RecentCarsGrid> createState() => _RecentCarsGridState();
}

class _RecentCarsGridState extends State<RecentCarsGrid> {
  final CarService _carService = CarService();
  late Future<List<Car>> _recentCars;

  @override
  void initState() {
    super.initState();
    _recentCars = _carService.getRecentCars();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Car>>(
      future: _recentCars,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingShimmer();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No recent cars found'));
        } else {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data!.length > 6 ? 6 : snapshot.data!.length,
            itemBuilder: (context, index) {
              return CarGridItem(car: snapshot.data![index]);
            },
          );
        }
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6,
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
    );
  }
}
