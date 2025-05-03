import 'package:car_plaza/services/auth_service.dart';
import 'package:car_plaza/services/firestore_service.dart';
import 'package:car_plaza/services/storage_service.dart';
import 'package:car_plaza/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  XFile? _imageFile;
  bool _isLoading = false;

  // Form fields
  String _name = '';
  String? _phone;
  String? _location;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = await authService.getCurrentUser();
    if (user != null && mounted) {
      setState(() {
        _name = user.name;
        _phone = user.phone;
        _location = user.location;
        _photoUrl = user.photoUrl;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (pickedFile != null && mounted) {
        setState(() => _imageFile = pickedFile);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final firestoreService =
          Provider.of<FirestoreService>(context, listen: false);
      final storageService =
          Provider.of<StorageService>(context, listen: false);

      final currentUser = await authService.getCurrentUser();
      if (currentUser == null) throw Exception('User not logged in');

      // Upload new image if selected
      if (_imageFile != null) {
        _photoUrl = await storageService.uploadProfileImage(
          currentUser.id,
          _imageFile!,
        );
      }

      // Create updated user
      final updatedUser = currentUser.copyWith(
        name: _name,
        phone: _phone,
        location: _location,
        photoUrl: _photoUrl,
      );

      // Update in Firestore
      await firestoreService.updateUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isLoading ? null : _saveProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _getProfileImage(),
                        child: _imageFile == null && _photoUrl == null
                            ? const Icon(Icons.camera_alt, size: 30)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Full Name',
                      initialValue: _name,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                      onSaved: (value) => _name = value!,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Phone Number',
                      initialValue: _phone,
                      keyboardType: TextInputType.phone,
                      onSaved: (value) => _phone = value,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Location',
                      initialValue: _location,
                      onSaved: (value) => _location = value,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        child: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  ImageProvider<Object>? _getProfileImage() {
    if (_imageFile != null) {
      return FileImage(File(_imageFile!.path));
    } else if (_photoUrl != null) {
      return NetworkImage(_photoUrl!);
    }
    return null;
  }
}
