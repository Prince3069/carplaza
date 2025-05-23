// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class TestUploadPage extends StatefulWidget {
  @override
  _TestUploadPageState createState() => _TestUploadPageState();
}

class _TestUploadPageState extends State<TestUploadPage> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  List<String> _imageUrls = [];
  bool _isUploading = false;

  Future<void> _uploadImage(File image) async {
    setState(() => _isUploading = true);
    try {
      // Create a reference to the location you want to upload to
      final ref = _storage
          .ref()
          .child('test_uploads/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the file with explicit metadata
      await ref.putFile(
        image,
        SettableMetadata(
          contentType: 'image/jpeg',
          cacheControl: 'public,max-age=300',
        ),
      );

      // Get the download URL
      final url = await ref.getDownloadURL();

      setState(() {
        _imageUrls.add(url);
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload successful!')),
      );
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _uploadImage(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Upload Test')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _isUploading ? null : _pickAndUploadImage,
            child: _isUploading
                ? const CircularProgressIndicator()
                : const Text('Upload Image'),
          ),
          if (_isUploading) const LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _imageUrls.length,
              itemBuilder: (ctx, index) => Image.network(_imageUrls[index]),
            ),
          ),
        ],
      ),
    );
  }
}
