
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  // 📸 Chụp ảnh từ camera
  Future<void> _pickFromCamera() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // 🖼️ Chọn ảnh từ gallery
  Future<void> _pickFromGallery() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // ❌ Xóa ảnh
  void _deleteImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo Capture & Preview"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🖼️ Hiển thị ảnh hoặc text
            _image == null
                ? const Text(
              "Chưa có ảnh nào được chọn",
              style: TextStyle(fontSize: 16),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _image!,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 30),

            // 📂 Nút chọn từ gallery
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _pickFromGallery,
                child: const Text("Chọn ảnh từ Gallery"),
              ),
            ),

            const SizedBox(height: 10),

            // 📸 Nút chụp ảnh
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _pickFromCamera,
                child: const Text("Chụp ảnh từ Camera"),
              ),
            ),

            const SizedBox(height: 10),

            // ❌ Nút xóa ảnh (chỉ hiện khi có ảnh)
            if (_image != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _deleteImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Xóa ảnh"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}