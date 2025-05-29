import 'package:flutter/material.dart';
import 'package:car_plaza/widgets/mobile_scaffold.dart';
import 'package:car_plaza/widgets/tablet_scaffold.dart';
import 'package:car_plaza/widgets/desktop_scaffold.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return const MobileScaffold();
        } else if (constraints.maxWidth < 1200) {
          return const TabletScaffold();
        } else {
          return const DesktopScaffold();
        }
      },
    );
  }
}
