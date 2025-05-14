import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/widgets/app_bottom_nav.dart';
import 'package:car_plaza/widgets/featured_carousel.dart';
import 'package:car_plaza/widgets/car_card.dart';
import 'package:car_plaza/providers/car_provider.dart';
import 'package:car_plaza/utils/responsive.dart';
import 'package:car_plaza/models/car_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final carProvider = Provider.of<CarProvider>(context, listen: false);
    carProvider.fetchFeaturedCars();
    carProvider.fetchRecentCars();
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
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(5),
            vertical: responsive.hp(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Featured Cars',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: responsive.hp(2)),
              const FeaturedCarousel(),
              SizedBox(height: responsive.hp(3)),
              Text(
                'Recently Added',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: responsive.hp(2)),
              carProvider.isLoading
                  ? const LoadingShimmer()
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
      bottomNavigationBar: const AppBottomNav(selectedIndex: 0),
    );
  }
}
