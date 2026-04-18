import 'dart:io';
import 'package:flutter/material.dart';
import 'Mediapickerscreen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MediaPickerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}