import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
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
                  _buildPendingSellersList(),
                  _buildAllListingsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingSellersList() {
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
              title: Text(user['name']),
              subtitle: Text(user['email']),
              trailing: IconButton(
                icon: const Icon(Icons.verified),
                onPressed: () => _verifySeller(user.id),
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
              title: Text(listing['title']),
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

  Future<void> _verifySeller(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'isVerifiedSeller': true});
  }

  Future<void> _deleteListing(String listingId) async {
    await FirebaseFirestore.instance
        .collection('listings')
        .doc(listingId)
        .delete();
  }
}
