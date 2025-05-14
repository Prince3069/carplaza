import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static double responsiveFontSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) return 14;
    if (width < 1200) return 16;
    return 18;
  }
}
