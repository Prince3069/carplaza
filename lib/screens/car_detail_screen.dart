// File: lib/screens/car_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:car_plaza/models/car.dart';
import 'package:car_plaza/widgets/image_gallery.dart';
import 'package:car_plaza/widgets/seller_info.dart';
import 'package:car_plaza/widgets/similar_cars.dart';

class CarDetailScreen extends StatelessWidget {
  final Car car;

  const CarDetailScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(car.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Add to favorites
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageGallery(
              imageUrls: [car.imageUrl, car.imageUrl, car.imageUrl],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${car.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        car.location,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      const Text(
                        'Posted 2 days ago',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This 2022 Toyota Camry is in excellent condition with low mileage. Features include leather seats, panoramic sunroof, advanced safety features, and more. One owner, regular maintenance, and no accidents.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const Divider(height: 32),
                  const Text(
                    'Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildDetailItem(Icons.speed, 'Mileage', '15,000 mi'),
                      _buildDetailItem(
                          Icons.local_gas_station, 'Fuel', 'Gasoline'),
                      _buildDetailItem(Icons.color_lens, 'Color', 'White'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildDetailItem(
                          Icons.settings, 'Transmission', 'Automatic'),
                      _buildDetailItem(Icons.person, 'Seats', '5'),
                      _buildDetailItem(Icons.calendar_today, 'Year', '2022'),
                    ],
                  ),
                  const Divider(height: 32),
                  const SellerInfo(),
                  const Divider(height: 32),
                  const Text(
                    'Similar Cars',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const SimilarCars(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.phone),
                label: const Text('Call'),
                onPressed: () {
                  // Implement call functionality
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.message),
                label: const Text('Message'),
                onPressed: () {
                  // Navigate to chat screen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
