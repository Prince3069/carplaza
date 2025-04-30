// CUSTOM TEXT FIELD WIDGET
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final void Function()? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.validator,
    this.suffixIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      validator: validator,
      onTap: onTap,
    );
  }
}
