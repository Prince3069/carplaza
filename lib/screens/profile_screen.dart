// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/services/auth_service.dart';
import 'package:car_plaza/screens/login_screen.dart';
import 'package:car_plaza/routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isAdmin = false;
  bool _isVerifiedSeller = false;
  bool _isRegistering = false;
  bool _dependenciesLoaded = false;

  @override
  void initState() {
    super.initState();
    // Don't access context-related items here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_dependenciesLoaded) {
      final args = ModalRoute.of(context)?.settings.arguments;
      _isRegistering = args != null && args is Map && args['register'] == true;
      _loadUserData();
      _dependenciesLoaded = true;
    }
  }

  Future<void> _loadUserData() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.currentUser;

    if (user != null) {
      setState(() => _isLoading = true);
      try {
        final userData = await auth.getUserData(user.uid);
        if (userData != null) {
          setState(() {
            _nameController.text = userData['name'] ?? '';
            _emailController.text = userData['email'] ?? '';
            _phoneController.text = userData['phone'] ?? '';
            _isVerifiedSeller = userData['isVerifiedSeller'] ?? false;
            _isAdmin = userData['isAdmin'] ?? false;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final user = auth.currentUser;

      if (user == null) {
        await auth.registerUser(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
      } else {
        await auth.updateProfile(
          userId: user.uid,
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    await auth.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final isLoggedIn = auth.currentUser != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: isLoggedIn
            ? [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: _logout,
                  tooltip: 'Logout',
                )
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: isLoggedIn || _isRegistering
            ? _buildProfileForm(auth)
            : _buildGuestView(),
      ),
    );
  }

  Widget _buildGuestView() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Image.asset(
          'assets/onboarding1.png',
          height: 120,
        ),
        const SizedBox(height: 20),
        const Text(
          'Create an Account',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'Sign up to sell cars, save favorites, and more',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 40),

        // Login Button
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Login'),
        ),
        const SizedBox(height: 16),

        // Register Button
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
                settings: const RouteSettings(arguments: {'register': true}),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Create Account'),
        ),
      ],
    );
  }

  Widget _buildProfileForm(AuthService auth) {
    final isLoggedIn = auth.currentUser != null;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (isLoggedIn) _buildVerificationStatus(),
          const SizedBox(height: 20),

          // Profile Avatar
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: auth.currentUser?.photoURL != null
                  ? NetworkImage(auth.currentUser!.photoURL!)
                  : const NetworkImage('https://via.placeholder.com/150'),
            ),
          ),
          const SizedBox(height: 20),

          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            enabled: !isLoggedIn,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),

          if (!isLoggedIn) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              validator: (value) =>
                  value!.length < 6 ? 'Minimum 6 characters' : null,
            ),
          ],

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(isLoggedIn ? 'Update Profile' : 'Create Account'),
            ),
          ),

          // Seller Verification
          if (isLoggedIn && !_isVerifiedSeller) ...[
            const SizedBox(height: 24),
            const Divider(),
            const Text('Seller Verification',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Complete verification to sell cars on Car Plaza'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to verification process
              },
              child: const Text('Start Verification'),
            ),
          ],

          // Admin Tools
          if (_isAdmin) ...[
            const SizedBox(height: 24),
            const Divider(),
            const Text('Admin Tools',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Admin Panel'),
              onTap: () {
                Navigator.pushNamed(context, RouteManager.adminPage);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVerificationStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: _isVerifiedSeller ? Colors.green[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isVerifiedSeller ? Icons.verified : Icons.pending,
            color: _isVerifiedSeller ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 8),
          Text(
            _isVerifiedSeller ? 'Verified Seller' : 'Pending Verification',
            style: TextStyle(
              color: _isVerifiedSeller ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
