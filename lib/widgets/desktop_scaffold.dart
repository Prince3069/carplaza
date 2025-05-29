import 'package:flutter/material.dart';
import 'package:car_plaza/widgets/desktop_navbar.dart';
import 'package:car_plaza/widgets/desktop_filter_sidebar.dart';
import 'package:car_plaza/widgets/car_item.dart';
import 'package:car_plaza/models/car_model.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  final List<Car> _cars = []; // Replace with your actual car data source

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(
            flex: 2,
            child: DesktopFilterSidebar(),
          ),
          Expanded(
            flex: 7,
            child: Column(
              children: [
                const DesktopNavBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _cars.length,
                      itemBuilder: (context, index) {
                        return CarItem(
                          car: _cars[index],
                          isWeb: true,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            flex: 3,
            child: Placeholder(), // Replace with featured listings or ads
          ),
        ],
      ),
    );
  }
}
