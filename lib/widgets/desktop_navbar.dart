import 'package:flutter/material.dart';
import 'package:car_plaza/widgets/search_bar.dart' as custom;

class DesktopNavBar extends StatelessWidget {
  const DesktopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Logo
          const Text(
            'CarPlaza',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),

          const SizedBox(width: 40),

          // Navigation Links
          _buildNavButton('Home', onTap: () {}),
          _buildNavButton('Browse', onTap: () {}),
          _buildNavButton('Sell Car', onTap: () {}),
          _buildNavButton('Dealers', onTap: () {}),

          const Spacer(),

          // Search Bar
          const SizedBox(
            width: 300,
            child: custom.SearchBar(),
          ),

          const SizedBox(width: 20),

          // User Section
          _buildUserSection(),
        ],
      ),
    );
  }

  Widget _buildNavButton(String text, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildUserSection() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {},
        ),
        const CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
      ],
    );
  }
}
