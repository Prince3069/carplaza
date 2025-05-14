import 'package:flutter/widgets.dart';
import 'package:car_plaza/services/device_service.dart';

class Responsive {
  final BuildContext context;

  Responsive.of(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  double get textScaleFactor => MediaQuery.of(context).textScaleFactor;
  double get pixelRatio => MediaQuery.of(context).devicePixelRatio;

  bool get isMobile => width < 600 || DeviceService.isMobile;
  bool get isTablet => width >= 600 && width < 900;
  bool get isDesktop => width >= 900 || DeviceService.isDesktop;
  bool get isWeb => DeviceService.isWeb;

  int get gridColumnCount {
    if (width > 1200) return 4;
    if (width > 900) return 3;
    if (width > 600) return 2;
    return 1;
  }

  double wp(double percent) => width * (percent / 100);
  double hp(double percent) => height * (percent / 100);

  double rp(double size) {
    final scale = isMobile
        ? 0.8
        : isTablet
            ? 0.9
            : 1.0;
    return size * scale;
  }

  // Add this new getter for carousel viewport fraction
  double get carouselViewportFraction {
    if (isDesktop) return 0.7;
    if (isTablet) return 0.85;
    return 0.9;
  }
}
