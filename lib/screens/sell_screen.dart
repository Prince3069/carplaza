// ignore_for_file: unused_import, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/services/auth_service.dart';
import 'package:car_plaza/services/database_service.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  List<File> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String _uploadStatus = '';
  String _debugInfo = '';
  double _uploadProgress = 0.0;
  Timer? _progressTimer;
  bool _uploadCancelled = false;

  // Form fields
  String _title = '';
  String _description = '';
  double _price = 0.0;
  String _location = 'Lagos';
  String _brand = 'Toyota';
  String _model = '';
  int _year = DateTime.now().year;
  String _condition = 'Used';
  String _transmission = 'Automatic';
  String _fuelType = 'Petrol';
  String _mileage = '';

  final List<String> _locations = ['Lagos', 'Abuja', 'Port Harcourt', 'Kano'];
  final List<String> _brands = ['Toyota', 'Honda', 'Nissan', 'Mercedes', 'BMW'];
  final List<String> _conditions = ['New', 'Used', 'Foreign Used'];
  final List<String> _transmissions = ['Automatic', 'Manual'];
  final List<String> _fuelTypes = ['Petrol', 'Diesel', 'Hybrid'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeScreen();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _progressTimer?.cancel();
    super.dispose();
  }

  void _initializeScreen() {
    try {
      setState(() {
        _debugInfo = 'Screen initialized successfully\n';
      });
    } catch (e) {
      _logError('Initialization error: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused && _isUploading) {
      _logError('App paused during upload - marking for cancellation');
      _uploadCancelled = true;
    }
  }

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await _picker
          .pickMultiImage(
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 70,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException('Image picker timeout'),
          );

      if (pickedFiles.isNotEmpty) {
        final files = <File>[];
        int validImages = 0;

        for (var pickedFile in pickedFiles) {
          try {
            final file = File(pickedFile.path);

            // Compress image before adding to list
            final compressedFile = await _compressImage(file);
            if (compressedFile != null) {
              final size = await compressedFile.length();

              // Check file size (max 5MB per image after compression)
              if (size > 5 * 1024 * 1024) {
                _logError(
                    'Image still too large after compression: ${(size / 1024 / 1024).toStringAsFixed(1)}MB');
                continue;
              }

              files.add(compressedFile);
              validImages++;
              _logError(
                  'Valid image added: ${(size / 1024).toStringAsFixed(1)}KB');
            }
          } catch (e) {
            _logError('Error processing image: $e');
          }
        }

        if (validImages > 0) {
          setState(() {
            _imageFiles = files;
          });
          _logError('$validImages images selected successfully');
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('No valid images could be processed')),
            );
          }
        }
      }
    } on TimeoutException {
      _logError('Image picker timed out');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Image selection timed out. Please try again.')),
        );
      }
    } catch (e) {
      _logError('Image picker error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting images: $e')),
        );
      }
    }
  }

  Future<File?> _compressImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return null;

      // Resize if too large
      img.Image resized = image;
      if (image.width > 1024 || image.height > 1024) {
        resized = img.copyResize(
          image,
          width: image.width > image.height ? 1024 : null,
          height: image.height > image.width ? 1024 : null,
        );
      }

      // Compress to JPEG with quality 70
      final compressedBytes = img.encodeJpg(resized, quality: 70);

      // Create a new file with compressed data
      final compressedFile = File('${imageFile.path}_compressed.jpg');
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    } catch (e) {
      _logError('Image compression error: $e');
      return imageFile; // Return original if compression fails
    }
  }

  void _logError(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    final logMessage = '$timestamp: $message';
    debugPrint(logMessage);

    if (mounted) {
      setState(() {
        _debugInfo += '$logMessage\n';
        final lines = _debugInfo.split('\n');
        if (lines.length > 50) {
          _debugInfo = lines.skip(lines.length - 50).join('\n');
        }
      });
    }
  }

  Future<void> _submitListing() async {
    if (!_formKey.currentState!.validate()) {
      _logError('Form validation failed');
      return;
    }

    if (_imageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one image')),
      );
      return;
    }

    _formKey.currentState!.save();
    _uploadCancelled = false;

    final auth = Provider.of<AuthService>(context, listen: false);
    final database = Provider.of<DatabaseService>(context, listen: false);
    final user = auth.currentUser;

    if (user == null) {
      _logError('User not logged in');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login first')),
      );
      return;
    }

    _logError('User UID: ${user.uid}');

    setState(() {
      _isUploading = true;
      _uploadStatus = 'Checking authentication...';
      _uploadProgress = 0.0;
    });

    _startProgressTimer();

    try {
      // Step 1: Check authentication status
      _logError('Checking authentication status...');
      final authStatus = await database.getAuthStatus();
      _logError('Auth status: $authStatus');

      if (!authStatus['authenticated']) {
        throw Exception('Authentication failed: ${authStatus['error']}');
      }

      setState(() {
        _uploadStatus = 'Testing Firebase connection...';
        _uploadProgress = 0.1;
      });

      // Step 2: Test Firebase connection and authentication
      _logError('Testing Firebase connection...');
      final connectionTest = await database.testAuthAndConnection().timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw TimeoutException('Connection test timeout'),
          );

      if (!connectionTest) {
        throw Exception('Firebase connection test failed');
      }

      _logError('Firebase connection test passed');

      setState(() {
        _uploadStatus = 'Checking seller verification...';
        _uploadProgress = 0.2;
      });

      // Step 3: Check verification status
      try {
        final isVerified = await auth.isVerifiedSeller(user.uid).timeout(
              const Duration(seconds: 10),
              onTimeout: () =>
                  throw TimeoutException('Verification check timeout'),
            );

        _logError('Verification status: $isVerified');

        if (!isVerified) {
          _logError('User not verified');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please complete seller verification first'),
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }
      } catch (e) {
        _logError('Verification check error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification check failed: $e')),
        );
        return;
      }

      setState(() {
        _uploadStatus = 'Preparing images for upload...';
        _uploadProgress = 0.3;
      });

      _logError('Starting image upload process...');
      _logError('Total images to upload: ${_imageFiles.length}');

      for (int i = 0; i < _imageFiles.length; i++) {
        final size = await _imageFiles[i].length();
        _logError(
            'Image ${i + 1} size: ${(size / 1024 / 1024).toStringAsFixed(2)} MB');
      }

      // Step 4: Upload images with enhanced error handling
      final imageUrls =
          await _uploadImagesEnhanced(database, _imageFiles, user.uid);

      if (_uploadCancelled) {
        _logError('Upload was cancelled');
        return;
      }

      setState(() {
        _uploadProgress = 0.9;
        _uploadStatus = 'Creating car listing...';
      });

      // Step 5: Create and save car listing
      final newCar = Car(
        title: _title,
        description: _description,
        price: _price,
        location: _location,
        brand: _brand,
        model: _model,
        year: _year,
        condition: _condition,
        transmission: _transmission,
        fuelType: _fuelType,
        mileage: _mileage,
        images: imageUrls,
        sellerId: user.uid,
        postedDate: DateTime.now(),
        isVerified: true,
      );

      _logError('Car object created, saving to database...');

      await database.addCar(newCar).timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw TimeoutException('Database save timeout'),
          );

      setState(() {
        _uploadProgress = 1.0;
        _uploadStatus = 'Completed successfully!';
      });

      _logError('Database save completed successfully');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Car listed successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        await Future.delayed(const Duration(seconds: 1));
        _resetForm();
      }
    } catch (e, stack) {
      _logError('ERROR: Exception: $e');
      _logError('STACK TRACE: $stack');

      if (mounted && !_uploadCancelled) {
        String errorMessage = 'Upload failed';

        if (e.toString().contains('unauthenticated')) {
          errorMessage = 'Authentication error. Please logout and login again.';
        } else if (e is TimeoutException) {
          errorMessage =
              'Upload timed out. Please check your internet connection and try again.';
        } else if (e.toString().toLowerCase().contains('network') ||
            e.toString().toLowerCase().contains('connection')) {
          errorMessage =
              'Network error. Please check your internet connection.';
        } else if (e.toString().toLowerCase().contains('permission')) {
          errorMessage = 'Permission error. Please check app permissions.';
        } else {
          errorMessage = 'Upload failed: ${e.toString()}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _submitListing(),
            ),
          ),
        );
      }
    } finally {
      _progressTimer?.cancel();
      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadProgress = 0.0;
          _uploadStatus = '';
        });
      }
    }
  }

  void _startProgressTimer() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_uploadProgress < 0.8 && _isUploading && !_uploadCancelled) {
        setState(() {
          _uploadProgress += 0.005;
        });
      }
    });
  }

  Future<List<String>> _uploadImagesEnhanced(
      DatabaseService database, List<File> images, String userId) async {
    _logError('Starting enhanced image upload...');

    // Try the main upload method first
    try {
      setState(() {
        _uploadStatus = 'Uploading images (enhanced method)...';
        _uploadProgress = 0.4;
      });

      final urls = await database.uploadCarImages(images, userId).timeout(
            Duration(
                seconds: 60 +
                    (images.length *
                        30)), // Dynamic timeout based on image count
            onTimeout: () => throw TimeoutException('Enhanced upload timeout'),
          );

      _logError('Enhanced upload completed successfully');
      return urls;
    } catch (e) {
      _logError('Enhanced upload failed: $e');

      // If enhanced method fails, try simple method as fallback
      if (e.toString().contains('unauthenticated')) {
        // For authentication errors, don't retry - let it bubble up
        rethrow;
      }

      _logError('Trying simple upload method as fallback...');

      setState(() {
        _uploadStatus = 'Retrying with simple upload method...';
        _uploadProgress = 0.5;
      });

      try {
        final urls = await database
            .uploadCarImagesSimple(images, userId)
            .timeout(
              Duration(seconds: 45 + (images.length * 15)),
              onTimeout: () => throw TimeoutException('Simple upload timeout'),
            );

        _logError('Simple upload completed successfully');
        return urls;
      } catch (e2) {
        _logError('Simple upload also failed: $e2');
        throw Exception(
            'Both upload methods failed. Enhanced: $e, Simple: $e2');
      }
    }
  }

  void _cancelUpload() {
    setState(() {
      _uploadCancelled = true;
      _isUploading = false;
      _uploadStatus = 'Upload cancelled';
      _uploadProgress = 0.0;
    });
    _progressTimer?.cancel();
    _logError('Upload cancelled by user');
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _imageFiles = [];
      _location = 'Lagos';
      _brand = 'Toyota';
      _year = DateTime.now().year;
      _condition = 'Used';
      _transmission = 'Automatic';
      _fuelType = 'Petrol';
      _uploadStatus = '';
      _uploadProgress = 0.0;
      _uploadCancelled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isUploading,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (_isUploading && !didPop) {
          _showCancelDialog();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sell Your Car'),
          leading: _isUploading ? null : const BackButton(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildImageUploadSection(),
                  const SizedBox(height: 20),
                  _buildFormFields(),
                  const SizedBox(height: 20),
                  _buildUploadSection(),
                  _buildSubmitButton(),
                  const SizedBox(height: 20),
                  _buildDebugSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Upload?'),
        content: const Text('Are you sure you want to cancel the upload?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _cancelUpload();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Title*',
            border: OutlineInputBorder(),
          ),
          enabled: !_isUploading,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          onSaved: (value) => _title = value ?? '',
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Description*',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          enabled: !_isUploading,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          onSaved: (value) => _description = value ?? '',
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Price (₦)*',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          enabled: !_isUploading,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Required';
            if (double.tryParse(value!) == null) return 'Invalid number';
            return null;
          },
          onSaved: (value) => _price = double.tryParse(value ?? '0') ?? 0.0,
        ),
        const SizedBox(height: 12),
        _buildDropdownFormField<String>(
          value: _location,
          items: _locations,
          onChanged: (value) => setState(() => _location = value ?? 'Lagos'),
          labelText: 'Location*',
        ),
        const SizedBox(height: 12),
        _buildDropdownFormField<String>(
          value: _brand,
          items: _brands,
          onChanged: (value) => setState(() => _brand = value ?? 'Toyota'),
          labelText: 'Brand*',
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Model*',
            border: OutlineInputBorder(),
          ),
          enabled: !_isUploading,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          onSaved: (value) => _model = value ?? '',
        ),
        const SizedBox(height: 12),
        _buildDropdownFormField<int>(
          value: _year,
          items: List.generate(30, (index) => DateTime.now().year - index),
          onChanged: (value) =>
              setState(() => _year = value ?? DateTime.now().year),
          labelText: 'Year*',
        ),
        const SizedBox(height: 12),
        _buildDropdownFormField<String>(
          value: _condition,
          items: _conditions,
          onChanged: (value) => setState(() => _condition = value ?? 'Used'),
          labelText: 'Condition*',
        ),
        const SizedBox(height: 12),
        _buildDropdownFormField<String>(
          value: _transmission,
          items: _transmissions,
          onChanged: (value) =>
              setState(() => _transmission = value ?? 'Automatic'),
          labelText: 'Transmission*',
        ),
        const SizedBox(height: 12),
        _buildDropdownFormField<String>(
          value: _fuelType,
          items: _fuelTypes,
          onChanged: (value) => setState(() => _fuelType = value ?? 'Petrol'),
          labelText: 'Fuel Type*',
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Mileage (km)*',
            border: OutlineInputBorder(),
          ),
          enabled: !_isUploading,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          onSaved: (value) => _mileage = value ?? '',
        ),
      ],
    );
  }

  Widget _buildDropdownFormField<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String labelText,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: _isUploading ? null : onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildUploadSection() {
    if (!_isUploading) return const SizedBox.shrink();

    return Column(
      children: [
        LinearProgressIndicator(
          value: _uploadProgress,
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          backgroundColor: Colors.grey[300],
        ),
        const SizedBox(height: 8),
        Text(
          _uploadStatus,
          textAlign: TextAlign.center,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        if (_uploadProgress > 0)
          Text(
            '${(_uploadProgress * 100).toInt()}% complete',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _showCancelDialog,
          child:
              const Text('Cancel Upload', style: TextStyle(color: Colors.red)),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isUploading ? null : _submitListing,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: _isUploading
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(width: 10),
                Text('Submitting...', style: TextStyle(color: Colors.white)),
              ],
            )
          : const Text('Submit Car Listing',
              style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Car Images (Upload at least 1 image)*',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (_imageFiles.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imageFiles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _imageFiles[index],
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (!_isUploading)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _imageFiles.removeAt(index)),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickImages,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Add Images'),
            ),
            if (_imageFiles.isNotEmpty && !_isUploading)
              TextButton(
                onPressed: () => setState(() => _imageFiles.clear()),
                child: const Text('Clear All'),
              ),
          ],
        ),
        if (_imageFiles.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${_imageFiles.length} image${_imageFiles.length == 1 ? '' : 's'} selected',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }

  Widget _buildDebugSection() {
    if (_debugInfo.isEmpty) return const SizedBox.shrink();

    return ExpansionTile(
      title: const Text('Debug Info',
          style: TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Container(
          width: double.infinity,
          height: 200,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: SingleChildScrollView(
            child: SelectableText(
              _debugInfo,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _debugInfo));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Debug info copied to clipboard')),
                );
              },
              child: const Text('Copy'),
            ),
            TextButton(
              onPressed: () => setState(() => _debugInfo = ''),
              child: const Text('Clear'),
            ),
          ],
        ),
      ],
    );
  }
}
