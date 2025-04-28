// =================== lib/widgets/video_picker_widget.dart ===================

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPickerWidget extends StatefulWidget {
  final Function(File?) onVideoSelected;

  const VideoPickerWidget({Key? key, required this.onVideoSelected})
      : super(key: key);

  @override
  State<VideoPickerWidget> createState() => _VideoPickerWidgetState();
}

class _VideoPickerWidgetState extends State<VideoPickerWidget> {
  final ImagePicker _picker = ImagePicker();
  File? _videoFile;
  VideoPlayerController? _controller;

  Future<void> _pickVideo() async {
    final XFile? pickedFile =
        await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
        _controller = VideoPlayerController.file(_videoFile!)
          ..initialize().then((_) {
            setState(() {});
          });
      });
      widget.onVideoSelected(_videoFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upload 360° Video'),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _pickVideo,
          child: const Text('Select Video'),
        ),
        const SizedBox(height: 8),
        _videoFile == null
            ? const Text('No video selected')
            : _controller != null && _controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : const CircularProgressIndicator(),
      ],
    );
  }
}

// =============================================================
