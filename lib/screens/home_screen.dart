// home_screen.dart
import 'package:car_plaza/screens/login_screen.dart';
import 'package:car_plaza/screens/profile_screen.dart';
import 'package:car_plaza/screens/sell_screen.dart';
import 'package:car_plaza/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/screens/search_screen.dart';
import 'package:car_plaza/screens/messages_screen.dart';
import 'package:car_plaza/widgets/bottom_nav_bar.dart';
import 'package:car_plaza/widgets/responsive.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/services/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeContent(),
      const SearchScreen(),
      Container(), // Placeholder for Sell screen
      const MessagesScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Responsive.isMobile(context)
          ? BottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                // Handle sell button for guests
                if (index == 2) {
                  _handleSellAction(context);
                } else {
                  setState(() => _currentIndex = index);
                }
              },
            )
          : null,
    );
  }

  void _handleSellAction(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    if (auth.currentUser == null) {
      // Show login prompt for guests
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Required'),
          content: const Text('You need to login to sell your car'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _currentIndex = 2;
        _screens[2] = const SellScreen(); // Load SellScreen for logged in users
      });
    }
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = 'All Nigeria';
  final List<String> _locations = [
    'All Nigeria',
    'Lagos',
    'Abuja',
    'Kano',
    'Ibadan',
    'Port Harcourt',
    'Benin City'
  ];

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseService>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Search
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1E3A8A), // Deep blue
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1E3A8A), // Deep blue
                      Color(0xFF3B82F6), // Medium blue
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Top bar with icons
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Logo
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.directions_car,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Car Plaza',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            // Action icons - responsive based on screen size
                            _buildResponsiveActionIcons(context),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Search section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'What car are you looking for?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 14),
                            _buildSearchBar(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Categories section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Browse Categories',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  _buildCategoriesGrid(),
                ],
              ),
            ),
          ),

          // Stats section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('326,255', 'Cars'),
                  _buildStat('50K+', 'Happy Customers'),
                  _buildStat('1000+', 'Dealers'),
                ],
              ),
            ),
          ),

          // Featured Cars section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Trending Cars',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
          ),

          // Cars grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: StreamBuilder<List<Car>>(
              stream: database.cars,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline,
                              size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text('Error: ${snapshot.error}'),
                        ],
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                List<Car> cars = snapshot.data ?? [];

                if (cars.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.car_rental,
                              size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('No cars available'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SellScreen(),
                                ),
                              );
                            },
                            child: const Text('List Your Car'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return EnhancedCarItem(car: cars[index]);
                    },
                    childCount: cars.length,
                  ),
                );
              },
            ),
          ),

          // Footer
          SliverToBoxAdapter(
            child: _buildFooter(),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveActionIcons(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    if (Responsive.isMobile(context)) {
      return Row(
        children: [
          _buildActionIcon(Icons.notifications_outlined, () {}),
          const SizedBox(width: 12),
          _buildActionIcon(Icons.favorite_border, () {}),
          const SizedBox(width: 12),
          _buildActionIcon(Icons.account_circle_outlined, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          }),
        ],
      );
    } else {
      return Row(
        children: [
          // Sell Icon (prominent)
          _buildNavigationActionIcon(
            Icons.add_circle,
            'Sell',
            () {
              if (auth.currentUser == null) {
                // Navigate to LoginScreen with message
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              } else {
                // Navigate directly to SellScreen if logged in
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SellScreen()),
                );
              }
            },
            isPrimary: true,
          ),
          const SizedBox(width: 8),

          // Messages Icon
          _buildNavigationActionIcon(
            Icons.message,
            'Messages',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MessagesScreen()),
              );
            },
          ),
          const SizedBox(width: 8),

          // Notifications Icon
          _buildNavigationActionIcon(
            Icons.notifications_outlined,
            'Notifications',
            () {
              // Handle notifications
            },
          ),
          const SizedBox(width: 8),

          // Favorites Icon
          _buildNavigationActionIcon(
            Icons.favorite_border,
            'Favorites',
            () {
              // Handle favorites
            },
          ),
          const SizedBox(width: 12),

          // Profile Avatar
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: auth.currentUser?.photoURL != null
                    ? NetworkImage(auth.currentUser!.photoURL!)
                    : const NetworkImage('https://via.placeholder.com/150'),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildActionIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildNavigationActionIcon(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isPrimary = false,
  }) {
    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isPrimary ? Colors.white : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: isPrimary
                ? null
                : Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
          ),
          child: Icon(
            icon,
            size: isPrimary ? 24 : 20,
            color: isPrimary ? const Color(0xFF3B82F6) : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Location dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: DropdownButton<String>(
              value: _selectedLocation,
              underline: Container(),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: _locations.map((String location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLocation = newValue!;
                });
              },
            ),
          ),
          // Search field
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'I am looking for...',
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          // Search button
          Container(
            margin: const EdgeInsets.all(4),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to search with query
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(
                      initialQuery: _searchController.text,
                      initialLocation: _selectedLocation,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Icon(Icons.search, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = [
      {'name': 'Sedans', 'icon': Icons.directions_car, 'count': '45,230'},
      {'name': 'SUVs', 'icon': Icons.airport_shuttle, 'count': '32,180'},
      {
        'name': 'Hatchback',
        'icon': Icons.directions_car_filled,
        'count': '28,940'
      },
      {'name': 'Pickup', 'icon': Icons.local_shipping, 'count': '15,670'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {
            // Navigate to category search
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category['icon'] as IconData,
                  size: 32,
                  color: const Color(0xFF3B82F6),
                ),
                const SizedBox(height: 8),
                Text(
                  category['name'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  category['count'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStat(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A8A),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1E3A8A),
            Color(0xFF1E40AF),
          ],
        ),
      ),
      child: Column(
        children: [
          // City skyline illustration
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
            ),
            child: CustomPaint(
              painter: CitySkylinePainter(),
              size: const Size(double.infinity, 100),
            ),
          ),

          // Footer content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Footer sections
                Wrap(
                  spacing: 40,
                  runSpacing: 24,
                  children: [
                    _buildFooterSection(
                      'About us',
                      [
                        'About Car Plaza',
                        'We are hiring!',
                        'Terms & Conditions',
                        'Privacy Policy'
                      ],
                    ),
                    _buildFooterSection(
                      'Support',
                      [
                        'support@carplaza.ng',
                        'Safety tips',
                        'Contact Us',
                        'FAQ'
                      ],
                    ),
                    _buildFooterSection(
                      'Our resources',
                      [
                        'Our blog',
                        'Car Plaza on FB',
                        'Our Instagram',
                        'Our YouTube'
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // App download buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAppButton('App Store', Icons.apple),
                    const SizedBox(width: 16),
                    _buildAppButton('Google Play', Icons.android),
                  ],
                ),

                const SizedBox(height: 32),

                // Country flags
                Wrap(
                  spacing: 12,
                  children: [
                    _buildCountryFlag('🇳🇬'),
                    _buildCountryFlag('🇬🇭'),
                    _buildCountryFlag('🇰🇪'),
                    _buildCountryFlag('🇺🇬'),
                    _buildCountryFlag('🇹🇿'),
                    _buildCountryFlag('🇿🇦'),
                  ],
                ),

                const SizedBox(height: 24),

                // Copyright
                Text(
                  '© 2025 Car Plaza',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                item,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildAppButton(String store, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Download on',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 10,
                ),
              ),
              Text(
                store,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountryFlag(String flag) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          flag,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

// Enhanced Car Item Widget
class EnhancedCarItem extends StatelessWidget {
  final Car car;

  const EnhancedCarItem({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car image
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: car.images.isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.network(
                            car.images.first,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.car_rental,
                                    size: 40, color: Colors.grey),
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.car_rental,
                              size: 40, color: Colors.grey),
                        ),
                ),
                // Popular badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'POPULAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Verified badge
                if (car.isVerified)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                // Rating
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 12),
                        Text(
                          ' 4.8',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Car details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₦${car.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(201, 214, 250, 1),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${car.brand} ${car.model} ${car.year}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          car.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for city skyline
class CitySkylinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Draw simple building silhouettes
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.6);
    path.lineTo(size.width * 0.1, size.height * 0.6);
    path.lineTo(size.width * 0.1, size.height * 0.3);
    path.lineTo(size.width * 0.2, size.height * 0.3);
    path.lineTo(size.width * 0.2, size.height * 0.7);
    path.lineTo(size.width * 0.3, size.height * 0.7);
    path.lineTo(size.width * 0.3, size.height * 0.4);
    path.lineTo(size.width * 0.4, size.height * 0.4);
    path.lineTo(size.width * 0.4, size.height * 0.8);
    path.lineTo(size.width * 0.6, size.height * 0.8);
    path.lineTo(size.width * 0.6, size.height * 0.2);
    path.lineTo(size.width * 0.7, size.height * 0.2);
    path.lineTo(size.width * 0.7, size.height * 0.5);
    path.lineTo(size.width * 0.8, size.height * 0.5);
    path.lineTo(size.width * 0.8, size.height * 0.6);
    path.lineTo(size.width, size.height * 0.6);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
