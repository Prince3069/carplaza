import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/screens/car_details/car_details_screen.dart';
import 'package:car_plaza/services/firestore_service.dart';
import 'package:car_plaza/utils/routes.dart';
import 'package:car_plaza/widgets/car_card.dart';
import 'package:car_plaza/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Plaza'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, Routes.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFeaturedCarsSection(context),
            const SizedBox(height: 20),
            _buildLatestCarsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCarsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Featured Cars',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: StreamBuilder<List<CarModel>>(
            stream: Provider.of<FirestoreService>(context).getFeaturedCars(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (_, index) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: ShimmerCard(width: 200, height: 200),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No featured cars available'));
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final car = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CarCard(
                      car: car,
                      onTap: () => _navigateToCarDetails(context, car.id),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLatestCarsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Latest Listings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<CarModel>>(
            stream: Provider.of<FirestoreService>(context).getLatestCars(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  children: [
                    ShimmerCard(height: 120),
                    SizedBox(height: 8),
                    ShimmerCard(height: 120),
                    SizedBox(height: 8),
                    ShimmerCard(height: 120),
                  ],
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No cars available'));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final car = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CarCard(
                      car: car,
                      horizontal: true,
                      onTap: () => _navigateToCarDetails(context, car.id),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateToCarDetails(BuildContext context, String carId) {
    Navigator.pushNamed(
      context,
      Routes.carDetails,
      arguments: carId,
    );
  }
}
