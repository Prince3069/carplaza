import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/services/auth_service.dart';

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
                  _buildPendingSellersList(context),
                  _buildAllListingsList(),
                ],
              ),
            ),
          ],
        ),
      ),
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
              title: Text(user['name'] ?? 'No Name'),
              subtitle: Text(user['email'] ?? 'No Email'),
              trailing: IconButton(
                icon: const Icon(Icons.verified, color: Colors.green),
                onPressed: () => _verifySeller(context, user.id),
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
              title: Text(listing['title'] ?? 'No Title'),
              subtitle: Text('₦${listing['price']} - ${listing['location']}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteListing(listing.id),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _verifySeller(BuildContext context, String userId) async {
    try {
      await Provider.of<AuthService>(context, listen: false)
          .verifySeller(userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seller verified successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying seller: $e')),
      );
    }
  }

  Future<void> _deleteListing(String listingId) async {
    await FirebaseFirestore.instance
        .collection('listings')
        .doc(listingId)
        .delete();
  }
}
