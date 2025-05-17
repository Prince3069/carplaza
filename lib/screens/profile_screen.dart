import 'package:car_plaza/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_plaza/widgets/responsive_layout.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/services/auth_service.dart';
import 'package:car_plaza/services/database_service.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/widgets/car_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final database = Provider.of<DatabaseService>(context);

    return StreamBuilder<User?>(
      stream: auth.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return ResponsiveLayout(
            mobileBody:
                ProfileContent(auth: auth, database: database, user: user),
            tabletBody:
                ProfileContent(auth: auth, database: database, user: user),
            desktopBody:
                ProfileContent(auth: auth, database: database, user: user),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ProfileContent extends StatefulWidget {
  final AuthService auth;
  final DatabaseService database;
  final User? user;

  const ProfileContent({
    super.key,
    required this.auth,
    required this.database,
    required this.user,
  });

  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    final userDoc = await widget.database.getUser(widget.user!.uid);
    if (userDoc != null) {
      setState(() {
        _nameController.text = userDoc.name;
        _emailController.text = userDoc.email;
        _phoneController.text = userDoc.phone;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.user == null) {
        // New user - register
        final user = await widget.auth.registerWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nameController.text.trim(),
          _phoneController.text.trim(),
        );

        if (user == null) {
          throw Exception('Registration failed');
        }
      } else {
        // Existing user - update profile
        await widget.database.updateUserData(UserModel(
          id: widget.user!.uid,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          isVerifiedSeller: true,
          joinedDate: DateTime.now(),
        ));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved! You can now sell cars.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = widget.user != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isLoggedIn ? 'My Profile' : 'Create Account',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 50),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(labelText: 'Full Name*'),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email*'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone*'),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    if (!isLoggedIn) ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        decoration:
                            const InputDecoration(labelText: 'Password*'),
                        obscureText: true,
                        validator: (value) =>
                            value!.length < 6 ? 'Minimum 6 characters' : null,
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                isLoggedIn ? 'Save Profile' : 'Create Account'),
                      ),
                    ),
                    if (isLoggedIn) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: widget.auth.signOut,
                          child: const Text('Sign Out'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (isLoggedIn) ...[
            const SizedBox(height: 24),
            const Text(
              'My Listings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<Car>>(
              stream: widget.database.getCarsBySeller(widget.user!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                if (!snapshot.hasData) return const CircularProgressIndicator();

                final cars = snapshot.data!;
                if (cars.isEmpty) return const Text('No listings yet');

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: cars.length,
                  itemBuilder: (context, index) => CarItem(car: cars[index]),
                );
              },
            ),
          ],
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
