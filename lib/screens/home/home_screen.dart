// HOME SCREEN
import 'package:car_plaza/providers/auth_provider.dart';
import 'package:car_plaza/providers/car_provider.dart';
import 'package:car_plaza/widgets/bottom_nav_bar.dart';
import 'package:car_plaza/widgets/car_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final carProvider = Provider.of<CarProvider>(context, listen: false);
    await carProvider.loadFeaturedCars();
    await carProvider.loadRecentCars();
  }

  @override
  Widget build(BuildContext context) {
    final carProvider = Provider.of<CarProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Plaza'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Home Tab
          SingleChildScrollView(
            child: Column(
              children: [
                // Featured Cars Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Featured Cars',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 220,
                        child: carProvider.isLoading
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 200,
                                      child: Card(
                                        child: Placeholder(),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: carProvider.featuredCars.length,
                                itemBuilder: (context, index) {
                                  final car = carProvider.featuredCars[index];
                                  return SizedBox(
                                    width: 200,
                                    child: CarCard(
                                      car: car,
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/car-detail',
                                          arguments: car,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
                // Recent Cars Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recently Added',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      carProvider.isLoading
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Card(
                                    child: SizedBox(
                                      height: 120,
                                      child: Placeholder(),
                                    ),
                                  ),
                                );
                              },
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: carProvider.recentCars.length,
                              itemBuilder: (context, index) {
                                final car = carProvider.recentCars[index];
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Search Tab
          const Center(child: Text('Search Screen')),
          // Sell Tab
          const Center(child: Text('Sell Screen')),
          // Messages Tab
          const Center(child: Text('Messages Screen')),
          // Profile Tab
          const Center(child: Text('Profile Screen')),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
      floatingActionButton: _currentIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/upload-car');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
