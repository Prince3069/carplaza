import 'package:flutter/material.dart';
import 'package:car_plaza/widgets/responsive_layout.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/services/auth_service.dart';
import 'package:car_plaza/services/database_service.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/widgets/car_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final database = Provider.of<DatabaseService>(context);
    final user = FirebaseAuth.instance.currentUser;

    return ResponsiveLayout(
      mobileBody:
          ProfileContent(auth: auth, database: database, userId: user?.uid),
      tabletBody:
          ProfileContent(auth: auth, database: database, userId: user?.uid),
      desktopBody:
          ProfileContent(auth: auth, database: database, userId: user?.uid),
    );
  }
}

class ProfileContent extends StatefulWidget {
  final AuthService auth;
  final DatabaseService database;
  final String? userId;

  const ProfileContent({
    super.key,
    required this.auth,
    required this.database,
    required this.userId,
  });

  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _profileImage;
  bool _isLoading = false;
  bool _isVerificationRequested = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (widget.userId == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();

    if (userDoc.exists) {
      setState(() {
        _nameController.text = userDoc.data()?['name'] ?? '';
        _emailController.text = userDoc.data()?['email'] ?? '';
        _phoneController.text = userDoc.data()?['phone'] ?? '';
        _isVerificationRequested =
            userDoc.data()?['verificationRequested'] ?? false;
      });
    } else {
      // Initialize with auth user data
      final user = FirebaseAuth.instance.currentUser;
      setState(() {
        _emailController.text = user?.email ?? '';
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_profileImage == null || widget.userId == null) return;

    try {
      final fileName =
          'profile_${widget.userId}_${DateTime.now().millisecondsSinceEpoch}';
      final ref =
          FirebaseStorage.instance.ref().child('profile_pictures/$fileName');
      await ref.putFile(_profileImage!);
      final downloadUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({'photoUrl': downloadUrl});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || widget.userId == null) return;
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      final userData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'verificationRequested': _isVerificationRequested,
        'isVerifiedSeller':
            false, // Reset verification status when profile changes
      };

      if (_profileImage != null) {
        await _uploadProfileImage();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .set(userData, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _requestVerification() async {
    if (widget.userId == null) return;

    setState(() {
      _isVerificationRequested = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({'verificationRequested': true});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification request submitted!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to request verification: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isVerifiedSeller = false; // You would get this from Firestore

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Profile Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue[100],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : (user?.photoURL != null
                                ? NetworkImage(user!.photoURL!)
                                : const AssetImage(
                                        'assets/profile_placeholder.png')
                                    as ImageProvider),
                        child: _profileImage == null && user?.photoURL == null
                            ? const Icon(Icons.person,
                                size: 50, color: Colors.blue)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your email' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value!.isEmpty
                          ? 'Please enter your phone number'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    if (!isVerifiedSeller)
                      Column(
                        children: [
                          if (!_isVerificationRequested)
                            ElevatedButton(
                              onPressed: _requestVerification,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              child: const Text(
                                'Request Seller Verification',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          else
                            const Text(
                              'Verification request submitted. We will review your profile soon.',
                              style: TextStyle(
                                color: Colors.orange,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          const SizedBox(height: 8),
                          const Text(
                            'Note: Only verified sellers can list cars for sale',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Save Profile',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: widget.auth.signOut,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'My Listings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // User's car listings
          if (widget.userId != null)
            StreamBuilder<List<Car>>(
              stream: widget.database.getCarsBySeller(widget.userId!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Car> cars = snapshot.data ?? [];

                if (cars.isEmpty) {
                  return const Center(
                    child: Text('You have no car listings yet'),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 2 : 1,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    return CarItem(car: cars[index]);
                  },
                );
              },
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
    super.dispose();
  }
}
