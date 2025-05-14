import 'package:flutter/material.dart';
import 'package:car_plaza/utils/responsive.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: responsive.gridColumnCount,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: responsive.isMobile ? 0.75 : 0.9,
      ),
      itemCount: 6, // Show 6 shimmer items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: responsive.isMobile ? 120 : 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  width: 100,
                  height: 14,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 80,
                  height: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
