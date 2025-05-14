import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/screens/search_screen.dart';
import 'package:car_plaza/screens/sell_screen.dart';
import 'package:car_plaza/screens/messages_screen.dart';
import 'package:car_plaza/screens/profile_screen.dart';
import 'package:car_plaza/widgets/bottom_nav_bar.dart';
import 'package:car_plaza/widgets/car_item.dart';
import 'package:car_plaza/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/services/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const SearchScreen(),
    const SellScreen(),
    const MessagesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Plaza'),
        centerTitle: true,
      ),
      body: ResponsiveLayout(
        mobileBody: _screens[_currentIndex],
        tabletBody: _screens[_currentIndex],
        desktopBody: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseService>(context);

    return StreamBuilder<List<Car>>(
      stream: database.cars,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Car> cars = snapshot.data ?? [];

        if (cars.isEmpty) {
          return const Center(child: Text('No cars available'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: cars.length,
          itemBuilder: (context, index) {
            return CarItem(car: cars[index]);
          },
        );
      },
    );
  }
}
