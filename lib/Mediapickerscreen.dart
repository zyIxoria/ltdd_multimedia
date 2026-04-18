import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class MediaPickerScreen extends StatefulWidget {
  const MediaPickerScreen({super.key});
  @override
  _MediaPickerScreenState createState() => _MediaPickerScreenState();
}

class _MediaPickerScreenState extends State<MediaPickerScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  File? _video;
  VideoPlayerController? _controller;

  // 📸 Chọn ảnh từ gallery
  Future<void> pickImageGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _video = null;
      });
    }
  }

  // 📷 Chụp ảnh
  Future<void> captureImage() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);

    if (picked == null) {
      print("User đã thoát camera");
      return;
    }

    setState(() {
      _image = File(picked.path);
      _video = null;
    });
  }

  // 🎬 Chọn video từ gallery
  Future<void> pickVideoGallery() async {
    final picked = await _picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      _video = File(picked.path);
      _image = null;
      initVideo();
    }
  }

  // 🎥 Quay video
  Future<void> captureVideo() async {
    final picked = await _picker.pickVideo(source: ImageSource.camera);
    if (picked != null) {
      _video = File(picked.path);
      _image = null;
      initVideo();
    }
  }



  //xóa
  void clearMedia() {
    _controller?.dispose();
    _controller = null;

    setState(() {
      _image = null;
      _video = null;
    });
  }

  void initVideo() {
    _controller?.dispose();
    _controller = VideoPlayerController.file(_video!)
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // 🎨 UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Media Picker App"),
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),

          Text("Chưa chọn ảnh hoặc video"),

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: pickImageGallery,
            child: Text("Chọn ảnh từ Gallery"),
          ),

          ElevatedButton(
            onPressed: captureImage,
            child: Text("Chụp ảnh từ Camera"),
          ),

          ElevatedButton(
            onPressed: pickVideoGallery,
            child: Text("Chọn video từ Gallery"),
          ),

          ElevatedButton(
            onPressed: captureVideo,
            child: Text("Quay video từ Camera"),
          ),

          SizedBox(height: 20),

          // 📺 Hiển thị ảnh
          if (_image != null)
            Image.file(_image!, height: 200),

          // 🎥 Hiển thị video
          if (_video != null &&
              _controller != null &&
              _controller!.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          if (_image != null || _video != null)
            ElevatedButton(
              onPressed: clearMedia,
              child: Text("Xóa ảnh / video"),
            ),
        ],
      ),
    );
  }
}