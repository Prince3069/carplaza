// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/providers/theme_provider.dart';
import 'package:car_plaza/utils/responsive.dart';
import 'package:car_plaza/widgets/adaptive/app_navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4; // Profile tab index
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load user data (in a real app, this would come from Firebase)
    _nameController.text = 'John Doe';
    _emailController.text = 'john.doe@example.com';
    _phoneController.text = '+234 812 345 6789';
    _locationController.text = 'Lagos, Nigeria';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDesktop = responsive.isDesktop;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                if (_formKey.currentState!.validate()) {
                  // Save changes
                  setState(() => _isEditing = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Profile updated successfully')),
                  );
                }
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
        ],
      ),
      body: Row(
        children: [
          if (isDesktop)
            AppNavigation(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) {
                setState(() => _selectedIndex = index);
                // Handle navigation
              },
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(responsive.wp(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: responsive.wp(15),
                        backgroundImage: const NetworkImage(
                            'https://i.imgur.com/Q6qBQ9J.png'),
                      ),
                      if (_isEditing)
                        FloatingActionButton.small(
                          onPressed: () {
                            // Implement image picker
                          },
                          child: const Icon(Icons.camera_alt),
                        ),
                    ],
                  ),
                  SizedBox(height: responsive.hp(2)),
                  Text(
                    'John Doe',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: responsive.hp(1)),
                  Text(
                    'Member since: January 2023',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: responsive.hp(3)),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildProfileField(
                          label: 'Full Name',
                          controller: _nameController,
                          enabled: _isEditing,
                          icon: Icons.person,
                        ),
                        _buildProfileField(
                          label: 'Email',
                          controller: _emailController,
                          enabled: _isEditing,
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _buildProfileField(
                          label: 'Phone',
                          controller: _phoneController,
                          enabled: _isEditing,
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                        _buildProfileField(
                          label: 'Location',
                          controller: _locationController,
                          enabled: _isEditing,
                          icon: Icons.location_on,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: responsive.hp(3)),
                  if (!isDesktop) ...[
                    _buildSectionTitle('Preferences'),
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme(value);
                      },
                    ),
                    _buildSectionTitle('Account'),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Sign Out'),
                      onTap: () {
                        // Implement sign out
                      },
                    ),
                  ],
                  if (isDesktop)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard('Listings', '12'),
                        _buildStatCard('Sold', '5'),
                        _buildStatCard('Favorites', '8'),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (isDesktop)
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Preferences'),
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme(value);
                      },
                    ),
                    _buildSectionTitle('Account'),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Sign Out'),
                      onTap: () {
                        // Implement sign out
                      },
                    ),
                    _buildSectionTitle('Statistics'),
                    _buildStatCard('Listings', '12', expanded: true),
                    _buildStatCard('Sold', '5', expanded: true),
                    _buildStatCard('Favorites', '8', expanded: true),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: !isDesktop
          ? AppNavigation(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) {
                setState(() => _selectedIndex = index);
                // Handle navigation
              },
            )
          : null,
    );
  }

  Widget _buildProfileField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, {bool expanded = false}) {
    return Card(
      child: Container(
        width: expanded ? double.infinity : null,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}
