import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';


class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();

  final List<String> _playlist = [
    'audios/sample1.mp3',
    'audios/sample2.mp3',
    'audios/sample3.mp3',
  ];

  int _currentIndex = 0;
  bool _isPlaying = false;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    _player.onDurationChanged.listen((d) {
      setState(() => _duration = d);
    });

    _player.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });

    _player.onPlayerComplete.listen((event) {
      _next();
    });
  }

  Future<void> _play() async {
    await _player.play(AssetSource(_playlist[_currentIndex]));
    setState(() => _isPlaying = true);
  }

  Future<void> _pause() async {
    await _player.pause();
    setState(() => _isPlaying = false);
  }

  Future<void> _seek(double value) async {
    await _player.seek(Duration(seconds: value.toInt()));
  }

  Future<void> _next() async {
    _currentIndex = (_currentIndex + 1) % _playlist.length;
    await _play();
  }

  Future<void> _previous() async {
    _currentIndex =
        (_currentIndex - 1 + _playlist.length) % _playlist.length;
    await _play();
  }

  String formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}";
  }

  Widget _circleButton(IconData icon, VoidCallback onTap,
      {double size = 55, bool isPrimary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Nếu là nút Play chính thì cho màu nổi hơn
          color: isPrimary ? Colors.white : Colors.white.withOpacity(0.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
            icon,
            color: isPrimary ? const Color(0xFFB91372) : Colors.white,
            size: size * 0.5
        ),
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String currentSong = _playlist[_currentIndex]
        .split('/')
        .last
        .replaceAll('.mp3', '');

    return Scaffold(
      // Sử dụng màu nền tối sâu để làm nổi bật Gradient
      backgroundColor: const Color(0xFF1A1A1A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E0854), Color(0xFF8E0E56)],
            // Màu tím đậm sang hồng ruby
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                "ALBUM",
                style: TextStyle(
                    color: Colors.white70, letterSpacing: 2, fontSize: 12),
              ),
              const SizedBox(height: 40),

              // 📀 Đĩa nhạc (Album Art)
              Center(
                child: Container(
                  width: 260,
                  height: 260,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.transparent
                      ],
                      begin: Alignment.topLeft,
                    ),
                    border: Border.all(color: Colors.white12, width: 2),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://api.dicebear.com/7.x/identicon/png?seed=music"),
                        // Ảnh giả lập
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24, width: 2),
                        ),
                        child: const Icon(Icons.music_note, color: Colors
                            .white),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 🎵 Thông tin bài hát
              Text(
                currentSong.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const Text(
                "ARTIST",
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),

              const SizedBox(height: 30),

              // 🎚 Slider tối giản
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 14),
                      ),
                      child: Slider(
                        min: 0,
                        max: _duration.inSeconds.toDouble(),
                        value: _position.inSeconds
                            .clamp(0, _duration.inSeconds)
                            .toDouble(),
                        onChanged: _seek,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatTime(_position), style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                          Text(formatTime(_duration), style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🎮 Bộ điều khiển
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _circleButton(Icons.skip_previous_rounded, () => _previous()),
                  const SizedBox(width: 25),
                  _circleButton(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        () => _isPlaying ? _pause() : _play(),
                    size: 80,
                    isPrimary: true,
                  ),
                  const SizedBox(width: 25),
                  _circleButton(Icons.skip_next_rounded, () => _next()),
                ],
              ),

              const SizedBox(height: 30),

              // 📜 Danh sách nhạc (Phần dưới cùng)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(35)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(35)),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: _playlist.length,
                      separatorBuilder: (_, __) =>
                      const Divider(color: Colors.white10, height: 1),
                      itemBuilder: (context, index) {
                        bool isSelected = index == _currentIndex;
                        String songName = _playlist[index]
                            .split('/')
                            .last
                            .replaceAll('.mp3', '');

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          leading: Text(
                            (index + 1).toString().padLeft(2, '0'),
                            style: TextStyle(
                                color: isSelected ? Colors.pinkAccent : Colors
                                    .white38),
                          ),
                          title: Text(
                            songName,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          subtitle: const Text("Artist", style: TextStyle(
                              color: Colors.white30, fontSize: 12)),
                          trailing: Icon(
                            isSelected ? Icons.equalizer : Icons.more_vert,
                            color: isSelected ? Colors.pinkAccent : Colors
                                .white38,
                          ),
                          onTap: () {
                            _currentIndex = index;
                            _play();
                          },
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}