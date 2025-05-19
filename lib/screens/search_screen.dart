// import 'package:flutter/material.dart';
// import 'package:car_plaza/widgets/responsive_layout.dart';

// class SearchScreen extends StatelessWidget {
//   const SearchScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveLayout(
//       mobileBody: SearchContent(),
//       tabletBody: SearchContent(),
//       desktopBody: SearchContent(),
//     );
//   }
// }

// class SearchContent extends StatefulWidget {
//   @override
//   _SearchContentState createState() => _SearchContentState();
// }

// class _SearchContentState extends State<SearchContent> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               hintText: 'Search for cars...',
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.search),
//                 onPressed: () {
//                   setState(() {
//                     _searchQuery = _searchController.text;
//                   });
//                 },
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             onSubmitted: (value) {
//               setState(() {
//                 _searchQuery = value;
//               });
//             },
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: _buildSearchResults(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchResults() {
//     // In a real app, you would query Firestore with the search query
//     if (_searchQuery.isEmpty) {
//       return const Center(
//         child: Text('Enter a search term to find cars'),
//       );
//     }

//     // Mock search results - replace with actual Firestore query
//     return ListView(
//       children: [
//         ListTile(
//           leading: const Icon(Icons.car_rental),
//           title: Text('Toyota Camry - $_searchQuery'),
//           subtitle: const Text('₦5,000,000 - Lagos'),
//         ),
//         ListTile(
//           leading: const Icon(Icons.car_rental),
//           title: Text('Honda Accord - $_searchQuery'),
//           subtitle: const Text('₦4,500,000 - Abuja'),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
// }

// ignore_for_file: library_private_types_in_public_api, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/services/database_service.dart';
import 'package:car_plaza/models/car_model.dart';
import 'package:car_plaza/widgets/car_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  List<Car> _searchResults = [];

  Future<void> _search() async {
    if (_searchController.text.isEmpty) return;

    setState(() => _isSearching = true);

    try {
      final database = Provider.of<DatabaseService>(context, listen: false);
      final results = await database.searchCars(_searchController.text.trim());
      setState(() => _searchResults = results);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search failed: $e')),
      );
    } finally {
      setState(() => _isSearching = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by brand...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: _search,
            ),
          ),
          onSubmitted: (_) => _search(),
        ),
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? const Center(child: Text('No results found'))
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return CarItem(car: _searchResults[index]);
                  },
                ),
    );
  }
}
