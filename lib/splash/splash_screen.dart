// import 'package:car_plaza/screens/auth/login_screen.dart';
// import 'package:car_plaza/widgets/bottom_nav_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:car_plaza/main.dart'; // To navigate to BottomNav after login
// import 'package:firebase_auth/firebase_auth.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigate();
//   }

//   void _navigate() async {
//     await Future.delayed(const Duration(seconds: 3));

//     User? user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const BottomNavBar()),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/images/logo.png', height: 120),
//             const SizedBox(height: 20),
//             const CircularProgressIndicator(color: Colors.blueAccent),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CarPlaz'),
      ),
      body: Center(
        child: Text('Selected index: ${widget.currentIndex}'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex, // Use the passed currentIndex
        onTap: widget.onTap, // Use the passed onTap function
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Sell',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
