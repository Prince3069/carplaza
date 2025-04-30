// // =================== lib/screens/sell/sell_screen.dart ===================

// import 'dart:io';

// import 'package:car_plaza/models/car.dart';
// import 'package:car_plaza/services/car_service.dart';
// import 'package:car_plaza/services/auth_service.dart';
// import 'package:car_plaza/widgets/image_picker_widget.dart';
// import 'package:car_plaza/widgets/video_picker_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../widgets/bottom_nav_bar.dart';

// class SellScreen extends StatefulWidget {
//   const SellScreen({Key? key}) : super(key: key);

//   @override
//   State<SellScreen> createState() => _SellScreenState();
// }

// class _SellScreenState extends State<SellScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String _title = '';
//   String _description = '';
//   double _price = 0.0;
//   String _make = '';
//   String _model = '';
//   int _year = 0;
//   int _mileage = 0;
//   List<File> _images = [];
//   File? _video;

//   bool _isUploading = false;
//   int _currentIndex = 2;

//   final CarService _carService = CarService();

//   void _onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });

//     switch (index) {
//       case 0:
//         Navigator.pushNamed(context, '/');
//         break;
//       case 1:
//         Navigator.pushNamed(context, '/search');
//         break;
//       case 2:
//         break; // Already on Sell
//       case 3:
//         Navigator.pushNamed(context, '/messages');
//         break;
//       case 4:
//         Navigator.pushNamed(context, '/profile');
//         break;
//     }
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate() || _images.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Please fill all fields and upload images')),
//       );
//       return;
//     }

//     _formKey.currentState!.save();
//     setState(() => _isUploading = true);

//     final userId =
//         Provider.of<AuthService>(context, listen: false).currentUser?.uid ?? '';

//     Car car = Car(
//       id: '',
//       title: _title,
//       description: _description,
//       price: _price,
//       make: _make,
//       model: _model,
//       year: _year,
//       mileage: _mileage,
//       imageUrls: [],
//       videoUrl: '',
//       sellerId: userId,
//       postedAt: DateTime.now() as dynamic, // Timestamp will be set in service
//     );

//     await _carService.uploadCar(car: car, images: _images, video: _video);

//     setState(() => _isUploading = false);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Car uploaded successfully!')),
//     );
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sell Your Car'),
//         centerTitle: true,
//       ),
//       body: _isUploading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(12),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       decoration: const InputDecoration(labelText: 'Title'),
//                       validator: (value) =>
//                           value!.isEmpty ? 'Enter title' : null,
//                       onSaved: (value) => _title = value!,
//                     ),
//                     TextFormField(
//                       decoration:
//                           const InputDecoration(labelText: 'Description'),
//                       validator: (value) =>
//                           value!.isEmpty ? 'Enter description' : null,
//                       onSaved: (value) => _description = value!,
//                     ),
//                     TextFormField(
//                       decoration: const InputDecoration(labelText: 'Price'),
//                       keyboardType: TextInputType.number,
//                       validator: (value) =>
//                           value!.isEmpty ? 'Enter price' : null,
//                       onSaved: (value) => _price = double.parse(value!),
//                     ),
//                     TextFormField(
//                       decoration: const InputDecoration(labelText: 'Make'),
//                       validator: (value) =>
//                           value!.isEmpty ? 'Enter make' : null,
//                       onSaved: (value) => _make = value!,
//                     ),
//                     TextFormField(
//                       decoration: const InputDecoration(labelText: 'Model'),
//                       validator: (value) =>
//                           value!.isEmpty ? 'Enter model' : null,
//                       onSaved: (value) => _model = value!,
//                     ),
//                     TextFormField(
//                       decoration: const InputDecoration(labelText: 'Year'),
//                       keyboardType: TextInputType.number,
//                       validator: (value) =>
//                           value!.isEmpty ? 'Enter year' : null,
//                       onSaved: (value) => _year = int.parse(value!),
//                     ),
//                     TextFormField(
//                       decoration:
//                           const InputDecoration(labelText: 'Mileage (km)'),
//                       keyboardType: TextInputType.number,
//                       validator: (value) =>
//                           value!.isEmpty ? 'Enter mileage' : null,
//                       onSaved: (value) => _mileage = int.parse(value!),
//                     ),
//                     const SizedBox(height: 12),
//                     ImagePickerWidget(
//                       onImagesSelected: (files) {
//                         setState(() => _images = files);
//                       },
//                     ),
//                     const SizedBox(height: 8),
//                     VideoPickerWidget(
//                       onVideoSelected: (file) {
//                         setState(() => _video = file);
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: _submit,
//                       child: const Text('Post Car'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//       bottomNavigationBar: BottomNavBar(
//         currentIndex: _currentIndex,
//         onTap: _onTabTapped,
//       ),
//     );
//   }
// }

// // =============================================================
