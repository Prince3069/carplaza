// CUSTOM BUTTON WIDGET
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final bool isLoading;
  final bool outline;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Widget? icon;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.outline = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: outline
            ? Colors.transparent
            : backgroundColor ?? Theme.of(context).primaryColor,
        foregroundColor: textColor ??
            (outline ? Theme.of(context).primaryColor : Colors.white),
        side: outline
            ? BorderSide(
                color: borderColor ?? Theme.of(context).primaryColor,
                width: 1,
              )
            : null,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor ??
                        (outline
                            ? Theme.of(context).primaryColor
                            : Colors.white),
                  ),
                ),
              ],
            ),
    );
  }
}
