import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/services/auth_service.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Provider.of<AuthService>(context, listen: false).isAdmin(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!) {
          return const Scaffold(
            body: Center(child: Text('Admin access required')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Admin Panel')),
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'Pending Sellers'),
                    Tab(text: 'All Listings'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildPendingSellersList(context),
                      _buildAllListingsList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPendingSellersList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('isVerifiedSeller', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final user = snapshot.data!.docs[index];
            return ListTile(
              title: Text(user['name'] ?? 'No name'),
              subtitle: Text(user['email'] ?? 'No email'),
              trailing: IconButton(
                icon: const Icon(Icons.verified),
                onPressed: () =>
                    Provider.of<AuthService>(context, listen: false)
                        .verifySeller(user.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAllListingsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('listings')
          .orderBy('postedDate', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final listing = snapshot.data!.docs[index];
            return ListTile(
              title: Text(listing['title'] ?? 'No title'),
              subtitle: Text('₦${listing['price']} - ${listing['location']}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteListing(listing.id),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteListing(String listingId) async {
    await FirebaseFirestore.instance
        .collection('listings')
        .doc(listingId)
        .delete();
  }
}
