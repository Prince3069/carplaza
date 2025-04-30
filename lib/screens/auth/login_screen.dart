// // LOGIN SCREEN
// import 'package:car_plaza/constants/strings.dart';
// import 'package:car_plaza/providers/auth_provider.dart';
// import 'package:car_plaza/utils/validators.dart';
// import 'package:car_plaza/widgets/custom_button.dart';
// import 'package:car_plaza/widgets/custom_textfield.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.signInWithEmail(
//         _emailController.text.trim(),
//         _passwordController.text.trim(),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Login failed: ${e.toString()}')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _signInWithGoogle() async {
//     setState(() => _isLoading = true);

//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.signInWithGoogle();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Google sign in failed: ${e.toString()}')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 32),
//               Text(
//                 AppStrings.welcomeBack,
//                 style: Theme.of(context).textTheme.headlineMedium,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 AppStrings.loginToContinue,
//                 style: Theme.of(context).textTheme.bodyMedium,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 32),
//               CustomTextField(
//                 controller: _emailController,
//                 labelText: AppStrings.email,
//                 keyboardType: TextInputType.emailAddress,
//                 validator: Validators.validateEmail,
//               ),
//               const SizedBox(height: 16),
//               CustomTextField(
//                 controller: _passwordController,
//                 labelText: AppStrings.password,
//                 obscureText: true,
//                 validator: Validators.validatePassword,
//               ),
//               const SizedBox(height: 8),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/forgot-password');
//                   },
//                   child: const Text(AppStrings.forgotPassword),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               CustomButton(
//                 onPressed: _isLoading ? null : _login,
//                 text: AppStrings.login,
//                 isLoading: _isLoading,
//                 color: Colors.cyan,
//               ),
//               const SizedBox(height: 16),
//               const Center(child: Text(AppStrings.or)),
//               const SizedBox(height: 16),
//               CustomButton(
//                 onPressed: _isLoading ? null : _signInWithGoogle,
//                 text: AppStrings.continueWithGoogle,
//                 icon: Image.asset(
//                   'assets/images/google_logo.png',
//                   height: 24,
//                   width: 24,
//                 ),
//                 backgroundColor: Colors.white,
//                 textColor: Colors.black87,
//                 borderColor: Colors.grey.shade300,
//                 color: Colors.cyan,
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(AppStrings.dontHaveAccount),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/register');
//                     },
//                     child: const Text(AppStrings.register),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/constants/strings.dart';
import 'package:car_plaza/providers/auth_provider.dart';
import 'package:car_plaza/utils/validators.dart';
import 'package:car_plaza/widgets/custom_button.dart';
import 'package:car_plaza/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate() || !mounted) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign in failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Text(
                AppStrings.welcomeBack,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.loginToContinue,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _emailController,
                labelText: AppStrings.email,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                labelText: AppStrings.password,
                obscureText: true,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgot-password');
                  },
                  child: const Text(AppStrings.forgotPassword),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                onPressed: _isLoading ? null : _login,
                text: AppStrings.login,
                isLoading: _isLoading,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              const Center(child: Text(AppStrings.or)),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: _isLoading ? null : _signInWithGoogle,
                text: AppStrings.continueWithGoogle,
                icon: Image.asset(
                  'assets/images/google_logo.png',
                  height: 24,
                  width: 24,
                ),
                backgroundColor: Colors.white,
                textColor: Colors.black87,
                borderColor: Colors.grey.shade300,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(AppStrings.dontHaveAccount),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(AppStrings.register),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
