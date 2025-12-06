import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VRTheaterScreen extends StatefulWidget {
  const VRTheaterScreen({super.key});

  @override
  State<VRTheaterScreen> createState() => _VRTheaterScreenState();
}

class _VRTheaterScreenState extends State<VRTheaterScreen> {
  late YoutubePlayerController _leftController;
  late YoutubePlayerController _rightController;
  final String _videoId = 'd9My665987w'; // Interstellar Trailer

  @override
  void initState() {
    super.initState();
    // Hide status bar for immersion
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Force landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _leftController = YoutubePlayerController(
      initialVideoId: _videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        hideControls: true,
        enableCaption: false,
        isLive: false,
        forceHD: true,
      ),
    );

    _rightController = YoutubePlayerController(
      initialVideoId: _videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true, // Mute one side to prevent echo and performance handling
        hideControls: true,
        enableCaption: false,
        isLive: false,
        forceHD: true,
      ),
    );
  }

  @override
  void dispose() {
    // Restore UI and orientation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          Expanded(child: _buildEyeView(_leftController)),
          Container(width: 2, color: Colors.black), // Divider
          Expanded(child: _buildEyeView(_rightController)),
        ],
      ),
    );
  }

  Widget _buildEyeView(YoutubePlayerController controller) {
    return Stack(
      children: [
        // Virtual Environment Background (Cinema)
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.8,
              colors: [
                Colors.purple.shade900.withValues(alpha: 0.2),
                Colors.black,
              ],
            ),
          ),
        ),

        // The "Screen" in VR
        Center(
          child: Container(
            width: 300,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
              border: Border.all(color: Colors.white10, width: 2),
            ),
            child: YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: false,
              aspectRatio: 16 / 9,
            ),
          ),
        ),

        // HUD / Controls
        Positioned(
          bottom: 20,
          left: 50,
          right: 50,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'VR Theater Mode',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
