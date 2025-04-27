// // File: lib/widgets/featured_cars_section.dart
// import 'package:flutter/material.dart';
// import 'package:car_plaza/models/car.dart';
// import 'package:car_plaza/services/car_service.dart';
// import 'package:car_plaza/screens/car_detail_screen.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:shimmer/shimmer.dart';

// class FeaturedCarsSection extends StatefulWidget {
//   const FeaturedCarsSection({super.key});

//   @override
//   State<FeaturedCarsSection> createState() => _FeaturedCarsSectionState();
// }

// class _FeaturedCarsSectionState extends State<FeaturedCarsSection> {
//   final CarService _carService = CarService();
//   late Future<List<Car>> _featuredCars;

//   @override
//   void initState() {
//     super.initState();
//     _featuredCars = _carService.getFeaturedCars();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Featured Cars',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Navigate to featured cars page
//               },
//               child: const Text('See All'),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         SizedBox(
//           height: 220,
//           child: FutureBuilder<List<Car>>(
//             future: _featuredCars,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return _buildLoadingShimmer();
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return const Center(child: Text('No featured cars found'));
//               } else {
//                 return ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) {
//                     final car = snapshot.data![index];
//                     return _buildFeaturedCarCard(car);
//                   },
//                 );
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFeaturedCarCard(Car car) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => CarDetailScreen(car: car),
//           ),
//         );
//       },
//       child: Container(
//         width: 280,
//         margin: const EdgeInsets.only(right: 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius:
//                   const BorderRadius.vertical(top: Radius.circular(8)),
//               child: Stack(
//                 children: [
//                   CachedNetworkImage(
//                     imageUrl: car.imageUrl,
//                     height: 140,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     placeholder: (context, url) => Shimmer.fromColors(
//                       baseColor: Colors.grey[300]!,
//                       highlightColor: Colors.grey[100]!,
//                       child: Container(
//                         height: 140,
//                         color: Colors.white,
//                       ),
//                     ),
//                     errorWidget: (context, url, error) => const Center(
//                       child: Icon(Icons.error),
//                     ),
//                   ),
//                   Positioned(
//                     top: 10,
//                     right: 10,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: const Text(
//                         'Featured',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     car.title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '\$${car.price.toStringAsFixed(0)}',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       const Icon(Icons.location_on,
//                           size: 14, color: Colors.grey),
//                       const SizedBox(width: 4),
//                       Text(
//                         car.location,
//                         style:
//                             const TextStyle(color: Colors.grey, fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingShimmer() {
//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//       itemCount: 3,
//       itemBuilder: (context, index) {
//         return Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             width: 280,
//             margin: const EdgeInsets.only(right: 16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
