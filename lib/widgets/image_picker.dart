import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_plaza/providers/car_provider.dart';
import 'package:car_plaza/utils/responsive.dart';

class CarImagePicker extends StatelessWidget {
  const CarImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final carProvider = Provider.of<CarProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ...carProvider.carImages.map((image) {
              return Stack(
                children: [
                  Container(
                    width: responsive.wp(20),
                    height: responsive.wp(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: MemoryImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () => carProvider.removeImage(image),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
            if (carProvider.carImages.length < 10)
              GestureDetector(
                onTap: () => carProvider.pickImages(),
                child: Container(
                  width: responsive.wp(20),
                  height: responsive.wp(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (carProvider.carImages.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: responsive.hp(1)),
            child: const Text(
              'Upload at least 1 image of your car',
              style: TextStyle(color: Colors.grey),
            ),
          ),
      ],
    );
  }
}
