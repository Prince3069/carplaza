import 'package:car_plaza/screens/sell/upload_car_screen.dart';
import 'package:flutter/material.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/screens/home/car_detail_screen.dart';

class ManageListingsScreen extends StatefulWidget {
  const ManageListingsScreen({super.key});

  @override
  State<ManageListingsScreen> createState() => _ManageListingsScreenState();
}

class _ManageListingsScreenState extends State<ManageListingsScreen> {
  final List<CarModel> _userListings = []; // Replace with actual data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Listings')),
      body: _userListings.isEmpty
          ? const Center(child: Text('You have no active listings'))
          : ListView.builder(
              itemCount: _userListings.length,
              itemBuilder: (ctx, index) =>
                  _buildListingItem(_userListings[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const UploadCarScreen(
                    car: null,
                    user: null,
                  )),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListingItem(CarModel car) {
    return Dismissible(
      key: Key(car.id),
      background: Container(color: Colors.red),
      onDismissed: (_) => _deleteListing(car.id),
      child: Card(
        child: ListTile(
          leading: Image.network(car.images.first,
              width: 60, height: 60, fit: BoxFit.cover),
          title: Text('${car.year} ${car.make} ${car.model}'),
          subtitle: Text('\$${car.price.toStringAsFixed(2)}'),
          trailing: const Icon(Icons.edit),
          onTap: () => _editListing(car),
        ),
      ),
    );
  }

  void _deleteListing(String carId) {
    // Implement delete logic
  }

  void _editListing(CarModel car) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CarDetailScreen(
          car: car,
          isOwnerView: true,
          category: null,
        ),
      ),
    );
  }
}
