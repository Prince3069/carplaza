import 'package:car_plaza/widgets/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/widgets/adaptive/app_navigation.dart';
import 'package:car_plaza/widgets/featured_carousel.dart';
import 'package:car_plaza/widgets/car_card.dart';
import 'package:car_plaza/providers/car_provider.dart';
import 'package:car_plaza/utils/responsive.dart';

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
    await Future.wait([
      carProvider.fetchFeaturedCars(),
      carProvider.fetchRecentCars(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final carProvider = Provider.of<CarProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Plaza'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          if (responsive.isDesktop)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/sell'),
                icon: const Icon(Icons.add),
                label: const Text('Sell Car'),
              ),
            ),
        ],
      ),
      body: Row(
        children: [
          if (responsive.isDesktop)
            AppNavigation(
              selectedIndex: _currentIndex,
              onItemTapped: (index) {
                setState(() => _currentIndex = index);
                // Add navigation logic here
              },
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(5),
                    vertical: responsive.hp(2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (carProvider.featuredCars.isNotEmpty) ...[
                        Text(
                          'Featured Cars',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: responsive.hp(2)),
                        const FeaturedCarousel(),
                        SizedBox(height: responsive.hp(3)),
                      ],
                      Text(
                        'Recently Added',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      SizedBox(height: responsive.hp(2)),
                      carProvider.isLoading
                          ? const LoadingShimmer()
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: responsive.gridColumnCount,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio:
                                    responsive.isMobile ? 0.75 : 0.9,
                              ),
                              itemCount: carProvider.recentCars.length,
                              itemBuilder: (context, index) {
                                final car = carProvider.recentCars[index];
                                return CarCard(car: car);
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: responsive.isMobile
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/sell'),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: !responsive.isDesktop
          ? AppNavigation(
              selectedIndex: _currentIndex,
              onItemTapped: (index) {
                setState(() => _currentIndex = index);
                // Add navigation logic here
              },
            )
          : null,
    );
  }
}
