import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/models/user_model.dart';
import 'package:car_plaza/screens/car_details/car_details_screen.dart';
import 'package:car_plaza/services/auth_service.dart';
import 'package:car_plaza/services/firestore_service.dart';
import 'package:car_plaza/utils/routes.dart';
import 'package:car_plaza/widgets/car_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageListingsScreen extends StatelessWidget {
  const ManageListingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder<UserModel?>(
      future: authService.getCurrentUser(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!userSnapshot.hasData || userSnapshot.data == null) {
          return const Center(child: Text('User not found'));
        }

        final userId = userSnapshot.data!.id;

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Listings'),
          ),
          body: StreamBuilder<List<CarModel>>(
            stream:
                Provider.of<FirestoreService>(context).getCarsBySeller(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('You have no listings yet'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final car = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CarCard(
                      car: car,
                      horizontal: true,
                      onTap: () => Navigator.pushNamed(
                        context,
                        Routes.carDetails,
                        arguments: car.id,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
