// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart'; // Add this import
// // import 'package:flutter/material.dart';
// // import 'package:car_plaza/services/auth_service.dart';
// // import 'package:provider/provider.dart';

// // class ProfileScreen extends StatefulWidget {
// //   const ProfileScreen({super.key});

// //   @override
// //   State<ProfileScreen> createState() => _ProfileScreenState();
// // }

// // class _ProfileScreenState extends State<ProfileScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _nameController = TextEditingController();
// //   final _emailController = TextEditingController();
// //   final _phoneController = TextEditingController();
// //   final _passwordController = TextEditingController();
// //   bool _isLoading = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _loadUserData();
// //     });
// //   }

// //   Future<void> _loadUserData() async {
// //     if (!mounted) return; // Add mounted check

// //     final auth = Provider.of<AuthService>(context, listen: false);
// //     final user = auth.currentUser; // Now this will work after adding the getter

// //     if (user != null) {
// //       final userDoc = await FirebaseFirestore.instance
// //           .collection('users')
// //           .doc(user.uid)
// //           .get();

// //       if (mounted) {
// //         // Check if widget is still mounted
// //         setState(() {
// //           _nameController.text = userDoc['name'] ?? '';
// //           _emailController.text = userDoc['email'] ?? '';
// //           _phoneController.text = userDoc['phone'] ?? '';
// //         });
// //       }
// //     }
// //   }

// //   Future<void> _saveProfile() async {
// //     if (!_formKey.currentState!.validate()) return;

// //     setState(() => _isLoading = true);

// //     try {
// //       final auth = Provider.of<AuthService>(context, listen: false);
// //       final currentUser = auth.currentUser;

// //       if (currentUser == null) {
// //         // New registration - will auto-login
// //         final user = await auth.registerWithProfile(
// //           email: _emailController.text.trim(),
// //           password: _passwordController.text.trim(),
// //           name: _nameController.text.trim(),
// //           phone: _phoneController.text.trim(),
// //         );

// //         if (user == null) throw Exception('Registration failed');

// //         // Navigate to home screen after successful registration
// //         if (mounted) {
// //           Navigator.pushNamedAndRemoveUntil(
// //             context,
// //             '/home',
// //             (route) => false,
// //           );
// //         }
// //       } else {
// //         // Existing user update
// //         await auth.updateProfile(
// //           userId: currentUser.uid,
// //           name: _nameController.text.trim(),
// //           phone: _phoneController.text.trim(),
// //         );

// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Profile updated!')),
// //         );
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error: ${e.toString()}')),
// //       );
// //     } finally {
// //       if (mounted) setState(() => _isLoading = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final auth = Provider.of<AuthService>(context);
// //     final isLoggedIn = auth.currentUser != null;

// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Profile')),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             children: [
// //               TextFormField(
// //                 controller: _nameController,
// //                 decoration: const InputDecoration(labelText: 'Full Name'),
// //                 validator: (value) =>
// //                     value?.isEmpty ?? true ? 'Required' : null,
// //               ),
// //               TextFormField(
// //                 controller: _emailController,
// //                 decoration: const InputDecoration(labelText: 'Email'),
// //                 keyboardType: TextInputType.emailAddress,
// //                 validator: (value) =>
// //                     value?.isEmpty ?? true ? 'Required' : null,
// //                 enabled: !isLoggedIn,
// //               ),
// //               if (!isLoggedIn) ...[
// //                 TextFormField(
// //                   controller: _passwordController,
// //                   decoration: const InputDecoration(labelText: 'Password'),
// //                   obscureText: true,
// //                   validator: (value) =>
// //                       (value?.length ?? 0) < 6 ? 'Minimum 6 characters' : null,
// //                 ),
// //               ],
// //               TextFormField(
// //                 controller: _phoneController,
// //                 decoration: const InputDecoration(labelText: 'Phone'),
// //                 keyboardType: TextInputType.phone,
// //                 validator: (value) =>
// //                     value?.isEmpty ?? true ? 'Required' : null,
// //               ),
// //               const SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: _isLoading ? null : _saveProfile,
// //                 child: _isLoading
// //                     ? const CircularProgressIndicator()
// //                     : Text(isLoggedIn ? 'Update Profile' : 'Create Account'),
// //               ),
// //               if (isLoggedIn) ...[
// //                 const SizedBox(height: 16),
// //                 OutlinedButton(
// //                   onPressed: () async {
// //                     await auth.signOut();
// //                     if (mounted) {
// //                       _loadUserData(); // Refresh the UI after sign out
// //                     }
// //                   },
// //                   child: const Text('Sign Out'),
// //                 ),
// //               ],
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _nameController.dispose();
// //     _emailController.dispose();
// //     _phoneController.dispose();
// //     _passwordController.dispose();
// //     super.dispose();
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:car_plaza/services/auth_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadUserData();
//     });
//   }

//   Future<void> _loadUserData() async {
//     if (!mounted) return;

//     final auth = Provider.of<AuthService>(context, listen: false);
//     final user = auth.currentUser;

//     if (user != null) {
//       final userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();

//       if (mounted) {
//         setState(() {
//           _nameController.text = userDoc['name'] ?? '';
//           _emailController.text = userDoc['email'] ?? '';
//           _phoneController.text = userDoc['phone'] ?? '';
//         });
//       }
//     }
//   }

//   Future<void> _saveProfile() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final auth = Provider.of<AuthService>(context, listen: false);
//       final currentUser = auth.currentUser;

//       if (currentUser == null) {
//         final user = await auth.registerWithProfile(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//           name: _nameController.text.trim(),
//           phone: _phoneController.text.trim(),
//         );

//         if (user == null) throw Exception('Registration failed');

//         if (mounted) {
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             '/home',
//             (route) => false,
//           );
//         }
//       } else {
//         await auth.updateProfile(
//           userId: currentUser.uid,
//           name: _nameController.text.trim(),
//           phone: _phoneController.text.trim(),
//         );

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Profile updated!')),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${e.toString()}')),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthService>(context);
//     final isLoggedIn = auth.currentUser != null;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Profile')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Full Name'),
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Required' : null,
//               ),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Required' : null,
//                 enabled: !isLoggedIn,
//               ),
//               if (!isLoggedIn) ...[
//                 TextFormField(
//                   controller: _passwordController,
//                   decoration: const InputDecoration(labelText: 'Password'),
//                   obscureText: true,
//                   validator: (value) =>
//                       (value?.length ?? 0) < 6 ? 'Minimum 6 characters' : null,
//                 ),
//               ],
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(labelText: 'Phone'),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Required' : null,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _saveProfile,
//                 child: _isLoading
//                     ? const CircularProgressIndicator()
//                     : Text(isLoggedIn ? 'Update Profile' : 'Create Account'),
//               ),
//               if (isLoggedIn) ...[
//                 const SizedBox(height: 16),
//                 OutlinedButton(
//                   onPressed: () async {
//                     await auth.signOut();
//                     if (mounted) {
//                       _loadUserData();
//                     }
//                   },
//                   child: const Text('Sign Out'),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
// }

// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/services/auth_service.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.currentUser;

    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (mounted) {
        setState(() {
          _nameController.text = userDoc['name'] ?? '';
          _emailController.text = userDoc['email'] ?? '';
          _phoneController.text = userDoc['phone'] ?? '';
        });
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
        // New user - should be handled by auth flow
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'isVerifiedSeller': true,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Profile'),
              ),
            ],
          ),
        ),
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
