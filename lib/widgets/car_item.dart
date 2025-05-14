import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:car_plaza/models/car_model.dart';

class CarItem extends StatelessWidget {
  final Car car;

  const CarItem({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 0,
    );

    return Card(
      child: InkWell(
        onTap: () {
          // Navigate to car details screen
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Car Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: car.images.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: car.images[0],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : const Center(
                      child: Icon(Icons.car_rental, size: 50),
                    ),
            ),

            // Car Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${car.brand} ${car.model}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    priceFormat.format(car.price),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        car.location,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        car.year.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      if (car.isVerified)
                        const Icon(Icons.verified,
                            size: 14, color: Colors.green),
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
