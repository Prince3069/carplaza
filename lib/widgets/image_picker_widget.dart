// =================== lib/widgets/image_picker_widget.dart ===================

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(List<File>) onImagesSelected;

  const ImagePickerWidget({Key? key, required this.onImagesSelected})
      : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((file) => File(file.path)).toList();
      });
      widget.onImagesSelected(_images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upload Images'),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _pickImages,
          child: const Text('Select Images'),
        ),
        const SizedBox(height: 8),
        _images.isEmpty
            ? const Text('No images selected')
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _images
                    .map((img) => Image.file(img, width: 80, height: 80))
                    .toList(),
              ),
      ],
    );
  }
}

// =============================================================
