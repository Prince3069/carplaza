import 'package:car_plaza/screens/home/car_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/screens/home/car_detail_screen.dart';

class SavedCarsScreen extends StatelessWidget {
  final List<CarModel> savedCars;

  const SavedCarsScreen({super.key, required this.savedCars});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Cars')),
      body: savedCars.isEmpty
          ? const Center(child: Text('No saved cars yet'))
          : ListView.builder(
              itemCount: savedCars.length,
              itemBuilder: (ctx, index) =>
                  _buildSavedCarItem(context, savedCars[index]),
            ),
    );
  }

  Widget _buildSavedCarItem(BuildContext context, CarModel car) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Image.network(car.images.first,
            width: 60, height: 60, fit: BoxFit.cover),
        title: Text('${car.year} ${car.make} ${car.model}'),
        subtitle: Text('\$${car.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {}, // Implement remove from favorites
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CarDetailScreen(car: car),
          ),
        ),
      ),
    );
  }
}
