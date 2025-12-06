import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/content_extras_service.dart';
import '../constants/app_colors.dart';

class SoundtrackFinderScreen extends StatefulWidget {
  const SoundtrackFinderScreen({super.key});

  @override
  State<SoundtrackFinderScreen> createState() => _SoundtrackFinderScreenState();
}

class _SoundtrackFinderScreenState extends State<SoundtrackFinderScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isListening = false;
  MusicTrack? _foundTrack;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleListening() async {
    setState(() {
      _isListening = !_isListening;
      _foundTrack = null;
    });

    if (_isListening) {
      _controller.repeat(reverse: true);

      // Simulate listening delay
      final service = Provider.of<ContentExtrasService>(context, listen: false);
      final track = await service.identifyNowPlaying();

      if (mounted) {
        setState(() {
          _isListening = false;
          _foundTrack = track;
        });
        _controller.stop();
      }
    } else {
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Soundtrack Discovery'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_foundTrack != null)
              _buildTrackCard(_foundTrack!)
            else ...[
              const Text(
                'Tap to Identify Music',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: _toggleListening,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width: 150 + (_controller.value * 20),
                      height: 150 + (_controller.value * 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isListening
                            ? AppColors.primary.withValues(alpha: 0.5)
                            : Colors.grey.withValues(alpha: 0.2),
                        boxShadow: _isListening
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.6,
                                  ),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ]
                            : [],
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.mic,
                        size: 60,
                        color: _isListening ? Colors.white : Colors.white54,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              if (_isListening)
                const Text(
                  'Listening...',
                  style: TextStyle(color: AppColors.primary),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTrackCard(MusicTrack track) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Image.network(
            track.albumArtUrl,
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            track.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            track.artist,
            style: const TextStyle(color: Colors.grey, fontSize: 18),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.play_circle_fill,
                  color: AppColors.primary,
                  size: 48,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
