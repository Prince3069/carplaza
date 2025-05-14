import 'package:flutter/material.dart';
import 'package:car_plaza/widgets/responsive_layout.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/services/auth_service.dart';
import 'package:car_plaza/services/database_service.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/widgets/car_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final database = Provider.of<DatabaseService>(context);

    return ResponsiveLayout(
      mobileBody: ProfileContent(auth: auth, database: database),
      tabletBody: ProfileContent(auth: auth, database: database),
      desktopBody: ProfileContent(auth: auth, database: database),
    );
  }
}

class ProfileContent extends StatelessWidget {
  final AuthService auth;
  final DatabaseService database;

  const ProfileContent({super.key, required this.auth, required this.database});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // User Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        AssetImage('assets/profile_placeholder.png'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Demo User',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'demo@carplaza.com',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => auth.signOut(),
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'My Listings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // User's car listings
          StreamBuilder<List<Car>>(
            stream: database.getCarsBySeller(
                'current_user_id'), // Replace with actual user ID
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              List<Car> cars = snapshot.data ?? [];

              if (cars.isEmpty) {
                return const Center(
                  child: Text('You have no car listings yet'),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cars.length,
                itemBuilder: (context, index) {
                  return CarItem(car: cars[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
