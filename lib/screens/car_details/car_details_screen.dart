import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/services/firestore_service.dart';
import 'package:car_plaza/routes.dart';
import 'package:car_plaza/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarDetailsScreen extends StatefulWidget {
  final String carId;

  const CarDetailsScreen({Key? key, required this.carId}) : super(key: key);

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  late Future<CarModel?> _carFuture;

  @override
  void initState() {
    super.initState();
    _carFuture = _loadCar();
  }

  Future<CarModel?> _loadCar() async {
    final firestoreService =
        Provider.of<FirestoreService>(context, listen: false);
    return await firestoreService.getCar(widget.carId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<CarModel?>(
        future: _carFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Car not found'));
          }

          final car = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  background: CarImagesGallery(images: car.images),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${car.brand} ${car.model} ${car.year}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        car.formattedPrice,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        car.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        'Details',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Location', car.location),
                      _buildDetailRow(
                          'Mileage', '${car.mileage.toStringAsFixed(0)} km'),
                      _buildDetailRow('Transmission', car.transmission),
                      _buildDetailRow('Fuel Type', car.fuelType),
                      _buildDetailRow('Condition', car.condition),
                      if (car.color != null)
                        _buildDetailRow('Color', car.color!),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _checkAccidentHistory(car.id),
                        child: const Text('Check Accident History'),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {}, // Implement buy now
                          child: const Text('Buy Now'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  void _checkAccidentHistory(String carId) {
    Navigator.pushNamed(
      context,
      Routes.accidentHistory,
      arguments: carId,
    );
  }
}

class CarImagesGallery extends StatelessWidget {
  final List<String> images;

  const CarImagesGallery({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Image.network(
          images[index],
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const ShimmerCard(
              height: double.infinity,
              width: double.minPositive,
            );
          },
        );
      },
    );
  }
}
