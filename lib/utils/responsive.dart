import 'package:flutter/widgets.dart';

class Responsive {
  final BuildContext context;

  Responsive.of(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  double get textScaleFactor => MediaQuery.of(context).textScaleFactor;

  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 900;
  bool get isDesktop => width >= 900;

  double wp(double percent) => width * (percent / 100);
  double hp(double percent) => height * (percent / 100);
}
