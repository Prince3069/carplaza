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

import 'package:flutter/material.dart';
import '../models/car.dart';
import '../services/api_service.dart';
import '../services/firebase_service.dart';
import '../widgets/car_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final FirebaseService _firebaseService = FirebaseService();

  late Future<List<Car>> _cars;

  @override
  void initState() {
    super.initState();
    _cars = _fetchAllCars();
  }

  Future<List<Car>> _fetchAllCars() async {
    final apiCars = await _apiService.fetchCars();
    final firebaseCars = await _firebaseService.getCars();
    return [...firebaseCars, ...apiCars];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Plaza'),
      ),
      body: FutureBuilder<List<Car>>(
        future: _cars,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No cars available'));
          } else {
            final cars = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: cars.length,
              itemBuilder: (context, index) {
                return CarCard(car: cars[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/upload');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
