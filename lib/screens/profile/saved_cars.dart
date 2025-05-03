// ignore_for_file: unused_import

import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/models/user_model.dart';
import 'package:car_plaza/screens/car_details/car_details_screen.dart';
import 'package:car_plaza/services/auth_service.dart';
import 'package:car_plaza/services/firestore_service.dart';
import 'package:car_plaza/utils/routes.dart';
import 'package:car_plaza/widgets/car_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedCarsScreen extends StatelessWidget {
  const SavedCarsScreen({Key? key}) : super(key: key);

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

        final savedCars = userSnapshot.data!.savedCars ?? [];
        if (savedCars.isEmpty) {
          return const Center(
            child: Text('You have no saved cars'),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Saved Cars'),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: savedCars.length,
            itemBuilder: (context, index) {
              final carId = savedCars[index];
              return FutureBuilder<CarModel?>(
                future: Provider.of<FirestoreService>(context).getCar(carId),
                builder: (context, carSnapshot) {
                  if (!carSnapshot.hasData || carSnapshot.data == null) {
                    return const SizedBox.shrink();
                  }
                  final car = carSnapshot.data!;
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
