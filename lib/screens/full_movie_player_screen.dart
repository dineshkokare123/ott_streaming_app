import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../constants/app_colors.dart';
import '../models/content.dart';

class FullMoviePlayerScreen extends StatefulWidget {
  final Content content;
  final int? resumePosition; // Resume from continue watching

  const FullMoviePlayerScreen({
    super.key,
    required this.content,
    this.resumePosition,
  });

  @override
  State<FullMoviePlayerScreen> createState() => _FullMoviePlayerScreenState();
}

class _FullMoviePlayerScreenState extends State<FullMoviePlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    // Set landscape orientation
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // For demo purposes, using a sample video URL
    // In production, this would be your actual movie streaming URL
    const sampleVideoUrl =
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(sampleVideoUrl),
    );

    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.primary,
        handleColor: AppColors.primary,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.grey.shade700,
      ),
      placeholder: Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      autoInitialize: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 64),
              const SizedBox(height: 16),
              Text(
                'Error loading video',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );

    // Resume from saved position if available
    if (widget.resumePosition != null && widget.resumePosition! > 0) {
      _videoPlayerController.seekTo(Duration(seconds: widget.resumePosition!));
    }

    setState(() {
      _isInitialized = true;
    });

    // Listen for video completion
    _videoPlayerController.addListener(_videoListener);
  }

  void _videoListener() {
    if (_videoPlayerController.value.position >=
        _videoPlayerController.value.duration) {
      // Video completed
      _onVideoCompleted();
    }
  }

  void _onVideoCompleted() {
    // In real app, update watch history, remove from continue watching
    debugPrint('Video completed: ${widget.content.title}');
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(_videoListener);
    _videoPlayerController.dispose();
    _chewieController?.dispose();

    // Reset orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _isInitialized && _chewieController != null
            ? Stack(
                children: [
                  Center(child: Chewie(controller: _chewieController!)),
                  // Custom back button
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          // Save current position before exiting
                          final position =
                              _videoPlayerController.value.position.inSeconds;
                          final duration =
                              _videoPlayerController.value.duration.inSeconds;

                          // In real app, save to continue watching if not completed
                          if (position < duration - 10) {
                            debugPrint('Saving position: $position seconds');
                          }

                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  // Title overlay
                  Positioned(
                    top: 16,
                    left: 72,
                    right: 16,
                    child: Text(
                      widget.content.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
      ),
    );
  }
}
