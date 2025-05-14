import 'package:flutter/material.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FeaturedCarousel extends StatelessWidget {
  const FeaturedCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final featuredCars = [
      Car(
        id: '1',
        title: '2022 Toyota Camry XLE',
        description: 'Like new with only 5,000km',
        price: 12500000,
        brand: 'Toyota',
        model: 'Camry',
        year: 2022,
        location: 'Lagos',
        imageUrls: [
          'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
        ],
        createdAt: DateTime.now(),
      ),
      Car(
        id: '2',
        title: '2021 Mercedes-Benz C300',
        description: 'Premium package, excellent condition',
        price: 18500000,
        brand: 'Mercedes-Benz',
        model: 'C300',
        year: 2021,
        location: 'Abuja',
        imageUrls: [
          'https://images.unsplash.com/photo-1616788494707-ec28f08d05a1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1374&q=80',
        ],
        createdAt: DateTime.now(),
      ),
      Car(
        id: '3',
        title: '2020 Lexus RX 350',
        description: 'Fully loaded, one owner',
        price: 15500000,
        brand: 'Lexus',
        model: 'RX 350',
        year: 2020,
        location: 'Port Harcourt',
        imageUrls: [
          'https://images.unsplash.com/photo-1617531653332-bd46c8f469f7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1413&q=80',
        ],
        createdAt: DateTime.now(),
      ),
    ];

    return SizedBox(
      height: responsive.isDesktop ? 350 : 250,
      child: PageView.builder(
        padEnds: false,
        controller: PageController(
            viewportFraction: responsive.carouselViewportFraction),
        itemCount: featuredCars.length,
        itemBuilder: (context, index) {
          final car = featuredCars[index];
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(1.5),
              vertical: responsive.hp(1),
            ),
            child: _FeaturedCarCard(car: car),
          ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1);
        },
      ),
    );
  }
}

class _FeaturedCarCard extends StatelessWidget {
  final Car car;

  const _FeaturedCarCard({required this.car});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        // Navigate to car details
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          children: [
            // Car Image
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: car.imageUrls.first,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.error),
                ),
              ),
            ),

            // Gradient Overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                    stops: const [0.1, 0.5],
                  ),
                ),
              ),
            ),

            // Featured Tag
            if (car.isFeatured)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'FEATURED',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            // Car Info
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: responsive.hp(0.5)),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      SizedBox(width: 4),
                      Text(
                        car.location,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        car.formattedPrice,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
