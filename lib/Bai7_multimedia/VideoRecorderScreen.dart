
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoRecorderScreen extends StatefulWidget {
  const VideoRecorderScreen({super.key});

  @override
  State<VideoRecorderScreen> createState() => _VideoRecorderScreen();
}

class _VideoRecorderScreen extends State<VideoRecorderScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _video;
  VideoPlayerController? _controller;

  // 🎬 Chọn video từ gallery
  Future<void> pickVideoGallery() async {
    final picked = await _picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      _video = File(picked.path);
      initVideo();
    }
  }

  // 🎥 Quay video
  Future<void> captureVideo() async {
    final picked = await _picker.pickVideo(source: ImageSource.camera);
    if (picked != null) {
      _video = File(picked.path);
      initVideo();
    }
  }

  void initVideo() {
    _controller?.dispose();
    _controller = VideoPlayerController.file(_video!)
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
      });
  }
  //xóa
  void clearMedia() {
    _controller?.dispose();
    _controller = null;

    setState(() {
      _video = null;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Record & Preview"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: (_video != null &&
                    _controller != null &&
                    _controller!.value.isInitialized)
                    ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                )
                    : const Text("Chưa có video"),
              ),
            ),
            const SizedBox(height: 15),

            // 📂 Nút chọn từ gallery
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: pickVideoGallery,
                child: const Text("Chọn video từ Gallery"),
              ),
            ),

            const SizedBox(height: 10),

            // 📸 Nút chụp ảnh
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: captureVideo,
                child: const Text("Quay video từ Camera"),
              ),
            ),

            const SizedBox(height: 10),

            // ❌ Nút xóa ảnh (chỉ hiện khi có ảnh)
            if (_video != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: clearMedia,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Xóa video"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

