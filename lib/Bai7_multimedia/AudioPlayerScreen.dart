import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';


class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();

  final List<String> _playlist = [
    'audios/sample1.mp3',
    'audios/sample2.mp3',
    'audios/sample3.mp3',
  ];

  int _currentIndex = 0;
  bool _isPlaying = false;

  // ▶️ Play
  Future<void> _play() async {
    await _player.play(AssetSource(_playlist[_currentIndex]));
    setState(() {
      _isPlaying = true;
    });
  }

  // ⏸ Pause
  Future<void> _pause() async {
    await _player.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  // ⏹ Stop
  Future<void> _stop() async {
    await _player.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  // ⏭ Next
  Future<void> _next() async {
    _currentIndex = (_currentIndex + 1) % _playlist.length;
    await _play();
  }

  // ⏮ Previous
  Future<void> _previous() async {
    _currentIndex =
        (_currentIndex - 1 + _playlist.length) % _playlist.length;
    await _play();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String currentSong =
    _playlist[_currentIndex].split('/').last.replaceAll('.mp3', '');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Audio Player"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🎵 Tên bài
            Text(
              currentSong,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // 🎮 Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _previous,
                  icon: const Icon(Icons.skip_previous),
                  iconSize: 40,
                ),
                IconButton(
                  onPressed: _isPlaying ? _pause : _play,
                  icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 50,
                ),
                IconButton(
                  onPressed: _stop,
                  icon: const Icon(Icons.stop),
                  iconSize: 40,
                ),
                IconButton(
                  onPressed: _next,
                  icon: const Icon(Icons.skip_next),
                  iconSize: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}