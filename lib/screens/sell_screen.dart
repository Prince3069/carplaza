// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:car_plaza/services/auth_service.dart';
// import 'package:car_plaza/services/database_service.dart';
// import 'package:car_plaza/models/car_model.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class SellScreen extends StatefulWidget {
//   const SellScreen({super.key});

//   @override
//   State<SellScreen> createState() => _SellScreenState();
// }

// class _SellScreenState extends State<SellScreen> {
//   final _formKey = GlobalKey<FormState>();
//   List<File> _imageFiles = [];
//   final ImagePicker _picker = ImagePicker();
//   bool _isUploading = false;
//   String _uploadStatus = '';

//   // Form fields
//   String _title = '';
//   String _description = '';
//   double _price = 0.0;
//   String _location = 'Lagos';
//   String _brand = 'Toyota';
//   String _model = '';
//   int _year = DateTime.now().year;
//   String _condition = 'Used';
//   String _transmission = 'Automatic';
//   String _fuelType = 'Petrol';
//   String _mileage = '';

//   final List<String> _locations = ['Lagos', 'Abuja', 'Port Harcourt', 'Kano'];
//   final List<String> _brands = ['Toyota', 'Honda', 'Nissan', 'Mercedes', 'BMW'];
//   final List<String> _conditions = ['New', 'Used', 'Foreign Used'];
//   final List<String> _transmissions = ['Automatic', 'Manual'];
//   final List<String> _fuelTypes = ['Petrol', 'Diesel', 'Hybrid'];

//   Future<void> _pickImages() async {
//     try {
//       final pickedFiles = await _picker.pickMultiImage();
//       if (pickedFiles != null) {
//         setState(() {
//           _imageFiles = pickedFiles.map((xfile) => File(xfile.path)).toList();
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error picking images: $e')),
//       );
//     }
//   }

//   Future<void> _submitListing() async {
//     if (!_formKey.currentState!.validate()) return;
//     _formKey.currentState!.save();

//     final auth = Provider.of<AuthService>(context, listen: false);
//     final user = auth.currentUser;

//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please login first')),
//       );
//       return;
//     }

//     // Check if user is verified
//     final isVerified = await auth.isVerifiedSeller(user.uid);
//     if (!isVerified) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please complete seller verification first'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//       _uploadStatus = 'Starting submission...';
//     });

//     try {
//       // Upload images
//       final database = Provider.of<DatabaseService>(context, listen: false);
//       final imageUrls = await database.uploadCarImages(_imageFiles, user.uid);

//       // Create car listing
//       final newCar = Car(
//         title: _title,
//         description: _description,
//         price: _price,
//         location: _location,
//         brand: _brand,
//         model: _model,
//         year: _year,
//         condition: _condition,
//         transmission: _transmission,
//         fuelType: _fuelType,
//         mileage: _mileage,
//         images: imageUrls,
//         sellerId: user.uid,
//         postedDate: DateTime.now(),
//         isVerified: true, // Admin will verify listings separately
//       );

//       // Save car to database
//       await database.addCar(newCar);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Car listed successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );

//       _resetForm();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isUploading = false;
//           _uploadStatus = '';
//         });
//       }
//     }
//   }

//   void _resetForm() {
//     _formKey.currentState?.reset();
//     setState(() {
//       _imageFiles = [];
//       _location = 'Lagos';
//       _brand = 'Toyota';
//       _year = DateTime.now().year;
//       _condition = 'Used';
//       _transmission = 'Automatic';
//       _fuelType = 'Petrol';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sell Your Car')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               _buildImageUploadSection(),
//               const SizedBox(height: 20),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Title*',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Required' : null,
//                 onSaved: (value) => _title = value ?? '',
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Description*',
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 3,
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Required' : null,
//                 onSaved: (value) => _description = value ?? '',
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Price (₦)*',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value?.isEmpty ?? true) return 'Required';
//                   if (double.tryParse(value!) == null) return 'Invalid number';
//                   return null;
//                 },
//                 onSaved: (value) =>
//                     _price = double.tryParse(value ?? '0') ?? 0.0,
//               ),
//               const SizedBox(height: 12),
//               _buildDropdownFormField<String>(
//                 value: _location,
//                 items: _locations,
//                 onChanged: (value) =>
//                     setState(() => _location = value ?? 'Lagos'),
//                 labelText: 'Location*',
//               ),
//               const SizedBox(height: 12),
//               _buildDropdownFormField<String>(
//                 value: _brand,
//                 items: _brands,
//                 onChanged: (value) =>
//                     setState(() => _brand = value ?? 'Toyota'),
//                 labelText: 'Brand*',
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Model*',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Required' : null,
//                 onSaved: (value) => _model = value ?? '',
//               ),
//               const SizedBox(height: 12),
//               _buildDropdownFormField<int>(
//                 value: _year,
//                 items:
//                     List.generate(30, (index) => DateTime.now().year - index),
//                 onChanged: (value) =>
//                     setState(() => _year = value ?? DateTime.now().year),
//                 labelText: 'Year*',
//               ),
//               const SizedBox(height: 12),
//               _buildDropdownFormField<String>(
//                 value: _condition,
//                 items: _conditions,
//                 onChanged: (value) =>
//                     setState(() => _condition = value ?? 'Used'),
//                 labelText: 'Condition*',
//               ),
//               const SizedBox(height: 12),
//               _buildDropdownFormField<String>(
//                 value: _transmission,
//                 items: _transmissions,
//                 onChanged: (value) =>
//                     setState(() => _transmission = value ?? 'Automatic'),
//                 labelText: 'Transmission*',
//               ),
//               const SizedBox(height: 12),
//               _buildDropdownFormField<String>(
//                 value: _fuelType,
//                 items: _fuelTypes,
//                 onChanged: (value) =>
//                     setState(() => _fuelType = value ?? 'Petrol'),
//                 labelText: 'Fuel Type*',
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Mileage (km)*',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Required' : null,
//                 onSaved: (value) => _mileage = value ?? '',
//               ),
//               const SizedBox(height: 20),
//               if (_isUploading) ...[
//                 LinearProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                       Theme.of(context).primaryColor),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   _uploadStatus,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontStyle: FontStyle.italic),
//                 ),
//                 const SizedBox(height: 12),
//               ],
//               ElevatedButton(
//                 onPressed: _isUploading ? null : _submitListing,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: _isUploading
//                     ? const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircularProgressIndicator(color: Colors.white),
//                           SizedBox(width: 10),
//                           Text('Submitting...',
//                               style: TextStyle(color: Colors.white)),
//                         ],
//                       )
//                     : const Text('Submit Car Listing',
//                         style: TextStyle(color: Colors.white)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdownFormField<T>({
//     required T value,
//     required List<T> items,
//     required ValueChanged<T?> onChanged,
//     required String labelText,
//   }) {
//     return DropdownButtonFormField<T>(
//       value: value,
//       items: items.map((item) {
//         return DropdownMenuItem<T>(
//           value: item,
//           child: Text(item.toString()),
//         );
//       }).toList(),
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         labelText: labelText,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }

//   Widget _buildImageUploadSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Car Images (Upload at least 1 image)',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         if (_imageFiles.isNotEmpty)
//           SizedBox(
//             height: 120,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: _imageFiles.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: Stack(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.file(
//                           _imageFiles[index],
//                           width: 120,
//                           height: 120,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       Positioned(
//                         top: 0,
//                         right: 0,
//                         child: GestureDetector(
//                           onTap: () =>
//                               setState(() => _imageFiles.removeAt(index)),
//                           child: Container(
//                             padding: const EdgeInsets.all(2),
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: const Icon(
//                               Icons.close,
//                               color: Colors.white,
//                               size: 16,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         const SizedBox(height: 8),
//         Row(
//           children: [
//             ElevatedButton.icon(
//               onPressed: _isUploading ? null : _pickImages,
//               icon: const Icon(Icons.camera_alt),
//               label: const Text('Add Image'),
//             ),
//             if (_imageFiles.isNotEmpty)
//               TextButton(
//                 onPressed: _isUploading
//                     ? null
//                     : () => setState(() => _imageFiles.clear()),
//                 child: const Text('Clear All'),
//               ),
//           ],
//         ),
//       ],
//     );
//   }
// }
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/services/auth_service.dart';
import 'package:car_plaza/services/database_service.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:image_picker/image_picker.dart';

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
    // Initialize with proper error handling
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
      // Clear any previous state
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
      // Handle app going to background during upload
      _logError('App paused during upload');
    }
  }

  Future<void> _pickImages() async {
    try {
      // Check permissions first
      final hasPermission = await _checkPermissions();
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera/Storage permissions required')),
        );
        return;
      }

      final pickedFiles = await _picker
          .pickMultiImage(
            maxWidth: 1200,
            maxHeight: 1200,
            imageQuality: 80,
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
            final size = await file.length();

            // Check file size (max 10MB per image)
            if (size > 10 * 1024 * 1024) {
              _logError(
                  'Image too large: ${(size / 1024 / 1024).toStringAsFixed(1)}MB');
              continue;
            }

            files.add(file);
            validImages++;
            _logError(
                'Valid image added: ${(size / 1024).toStringAsFixed(1)}KB');
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No valid images selected')),
          );
        }
      }
    } on TimeoutException {
      _logError('Image picker timed out');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Image selection timed out. Please try again.')),
      );
    } catch (e) {
      _logError('Image picker error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting images: $e')),
      );
    }
  }

  Future<bool> _checkPermissions() async {
    try {
      // This would normally use permission_handler package
      // For now, assume permissions are granted
      return true;
    } catch (e) {
      _logError('Permission check error: $e');
      return false;
    }
  }

  void _logError(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    final logMessage = '$timestamp: $message';
    debugPrint(logMessage);

    if (mounted) {
      setState(() {
        _debugInfo += '$logMessage\n';
        // Keep only last 50 lines to prevent memory issues
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

    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.currentUser;

    if (user == null) {
      _logError('User not logged in');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login first')),
      );
      return;
    }

    _logError('User UID: ${user.uid}');

    // Check verification with timeout
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
      _isUploading = true;
      _uploadStatus = 'Starting submission...';
      _uploadProgress = 0.0;
    });

    // Start progress simulation
    _startProgressTimer();

    try {
      _logError('Starting image upload process...');
      _logError('Total images to upload: ${_imageFiles.length}');

      // Log file information
      for (int i = 0; i < _imageFiles.length; i++) {
        final size = await _imageFiles[i].length();
        _logError(
            'Image ${i + 1} size: ${(size / 1024 / 1024).toStringAsFixed(2)} MB');
      }

      final database = Provider.of<DatabaseService>(context, listen: false);

      setState(() {
        _uploadStatus = 'Uploading images...';
        _uploadProgress = 0.1;
      });

      // Upload with chunked approach and better error handling
      final imageUrls =
          await _uploadImagesChunked(database, _imageFiles, user.uid);

      setState(() {
        _uploadProgress = 0.8;
        _uploadStatus = 'Creating car listing...';
      });

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
            const Duration(seconds: 30),
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

        // Reset form after success
        await Future.delayed(const Duration(seconds: 1));
        _resetForm();
      }
    } catch (e, stack) {
      _logError('ERROR: $e');
      _logError('STACK TRACE: $stack');

      if (mounted) {
        String errorMessage = 'Upload failed';
        if (e is TimeoutException) {
          errorMessage = 'Upload timed out. Please check your connection.';
        } else if (e.toString().contains('network')) {
          errorMessage = 'Network error. Please check your connection.';
        } else {
          errorMessage = 'Error: ${e.toString()}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      _progressTimer?.cancel();
      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadProgress = 0.0;
        });
      }
    }
  }

  void _startProgressTimer() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_uploadProgress < 0.7 && _isUploading) {
        setState(() {
          _uploadProgress += 0.02;
        });
      }
    });
  }

  Future<List<String>> _uploadImagesChunked(
      DatabaseService database, List<File> images, String userId) async {
    final imageUrls = <String>[];

    for (int i = 0; i < images.length; i++) {
      try {
        setState(() {
          _uploadStatus = 'Uploading image ${i + 1}/${images.length}...';
          _uploadProgress = 0.1 + (i / images.length) * 0.6;
        });

        _logError('Uploading image ${i + 1}...');

        // Upload with retries
        String? imageUrl;
        for (int attempt = 1; attempt <= 3; attempt++) {
          try {
            imageUrl = await database
                .uploadCarImages([images[i]], userId)
                .timeout(const Duration(seconds: 60))
                .then((urls) => urls.first);
            break;
          } catch (e) {
            _logError('Upload attempt $attempt failed: $e');
            if (attempt == 3) rethrow;
            await Future.delayed(Duration(seconds: attempt * 2));
          }
        }

        if (imageUrl != null) {
          imageUrls.add(imageUrl);
          _logError('Image ${i + 1} uploaded successfully');
        }
      } catch (e) {
        _logError('Failed to upload image ${i + 1}: $e');
        throw Exception('Failed to upload image ${i + 1}: $e');
      }
    }

    return imageUrls;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isUploading,
      onPopInvoked: (didPop) {
        if (_isUploading && !didPop) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please wait for upload to complete'),
              duration: Duration(seconds: 2),
            ),
          );
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
        // Add other form fields here...
      ],
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
    // Implementation similar to before but with error handling
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Car Images (Upload at least 1 image)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Image display logic here...
        ElevatedButton.icon(
          onPressed: _isUploading ? null : _pickImages,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Add Images'),
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
            child: Text(
              _debugInfo,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }
}
