// =================== lib/screens/home/home_screen.dart ===================

import 'package:car_plaza/models/car.dart';
import 'package:car_plaza/services/car_service.dart';
import 'package:car_plaza/services/api_service.dart';
import 'package:flutter/material.dart';
import '../../widgets/car_card.dart';
import '../../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Car> _cars = [];
  final CarService _carService = CarService();
  final ApiService _apiService = ApiService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    setState(() => _isLoading = true);
    List<Car> firebaseCars = await _carService.fetchCars();
    List<Car> apiCars = await _apiService.fetchExternalCars();
    setState(() {
      _cars = [...firebaseCars, ...apiCars];
      _isLoading = false;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        break; // Already on Home
      case 1:
        Navigator.pushNamed(context, '/search');
        break;
      case 2:
        Navigator.pushNamed(context, '/sell');
        break;
      case 3:
        Navigator.pushNamed(context, '/messages');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('CarPlaz'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cars.isEmpty
              ? const Center(child: Text('No cars found'))
              : ListView.builder(
                  itemCount: _cars.length,
                  itemBuilder: (context, index) {
                    return CarCard(car: _cars[index]);
                  },
                ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

// =============================================================
