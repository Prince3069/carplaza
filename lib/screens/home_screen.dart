// // File: lib/screens/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:car_plaza/widgets/featured_cars_section.dart';
// import 'package:car_plaza/widgets/category_tabs.dart';
// import 'package:car_plaza/widgets/recent_cars_grid.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Car Plaza'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.favorite_outline),
//             onPressed: () {
//               // Navigate to favorites
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.notifications_outlined),
//             onPressed: () {
//               // Navigate to notifications
//             },
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           // Refresh data
//         },
//         child: ListView(
//           padding: const EdgeInsets.all(16.0),
//           children: const [
//             FeaturedCarsSection(),
//             SizedBox(height: 24),
//             CategoryTabs(),
//             SizedBox(height: 24),
//             Text(
//               'Recent Cars',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             RecentCarsGrid(),
//           ],
//         ),
//       ),
//     );
//   }
// }
