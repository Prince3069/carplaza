// import 'package:car_plaza/models/car_model.dart';
// import 'package:car_plaza/screens/messages/chat_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class CarDetailScreen extends StatelessWidget {
//   final CarModel car;

//   const CarDetailScreen({super.key, required this.car});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('${car.year} ${car.make} ${car.model}')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image Gallery
//             SizedBox(
//               height: 250,
//               child: PageView.builder(
//                 itemCount: car.images.length,
//                 itemBuilder: (ctx, index) => CachedNetworkImage(
//                   imageUrl: car.images[index],
//                   placeholder: (_, __) =>
//                       const Center(child: CircularProgressIndicator()),
//                   errorWidget: (_, __, ___) => const Icon(Icons.error),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),

//             // Price and Basic Info
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '\$${car.price.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                         fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   Chip(label: Text(car.condition)),
//                 ],
//               ),
//             ),

//             // Details Section
//             const Text('Details',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: [
//                 _buildDetailChip(Icons.speed, '${car.mileage} km'),
//                 _buildDetailChip(Icons.local_gas_station, car.fuelType),
//                 _buildDetailChip(Icons.color_lens, car.color),
//                 _buildDetailChip(Icons.settings, car.transmission),
//               ],
//             ),

//             // Description
//             const SizedBox(height: 16),
//             const Text('Description',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Text(car.description),

//             // Seller Info
//             const SizedBox(height: 24),
//             const Text('Seller Information',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const ListTile(
//               leading: CircleAvatar(child: Icon(Icons.person)),
//               title: Text('John Doe'),
//               subtitle: Text('Member since 2022'),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ElevatedButton(
//           onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) =>
//                     ChatScreen(sellerId: car.sellerId, carId: car.id),
//               )),
//           child: const Text('Contact Seller'),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailChip(IconData icon, String text) {
//     return Chip(
//       avatar: Icon(icon, size: 18),
//       label: Text(text),
//     );
//   }
// }

import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/screens/messages/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CarDetailScreen extends StatelessWidget {
  final CarModel car;
  final bool isOwnerView;

  const CarDetailScreen({
    super.key,
    required this.car,
    this.isOwnerView = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${car.year} ${car.make} ${car.model}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery
            SizedBox(
              height: 250,
              child: PageView.builder(
                itemCount: car.images.length,
                itemBuilder: (ctx, index) => CachedNetworkImage(
                  imageUrl: car.images[index],
                  placeholder: (_, __) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (_, __, ___) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Price and Basic Info
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${car.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Chip(label: Text(car.condition)),
                ],
              ),
            ),

            // Details Section
            const Text('Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildDetailChip(Icons.speed, '${car.mileage} km'),
                _buildDetailChip(Icons.local_gas_station, car.fuelType),
                _buildDetailChip(Icons.color_lens, car.color),
                _buildDetailChip(Icons.settings, car.transmission),
              ],
            ),

            // Description
            const SizedBox(height: 16),
            const Text('Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(car.description),

            // Seller Info
            const SizedBox(height: 24),
            const Text('Seller Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('John Doe'),
              subtitle: Text('Member since 2022'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isOwnerView
          ? null
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ChatScreen(sellerId: car.sellerId, carId: car.id),
                  ),
                ),
                child: const Text('Contact Seller'),
              ),
            ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(text),
    );
  }
}
