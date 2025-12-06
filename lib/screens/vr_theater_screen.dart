import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VRTheaterScreen extends StatefulWidget {
  const VRTheaterScreen({super.key});

  @override
  State<VRTheaterScreen> createState() => _VRTheaterScreenState();
}

class _VRTheaterScreenState extends State<VRTheaterScreen> {
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
  }

  @override
  void dispose() {
    // Restore UI and orientation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          Expanded(child: _buildEyeView(isLeft: true)),
          Container(width: 2, color: Colors.black), // Divider
          Expanded(child: _buildEyeView(isLeft: false)),
        ],
      ),
    );
  }

  Widget _buildEyeView({required bool isLeft}) {
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
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Simulated Content
                Image.network(
                  'https://image.tmdb.org/t/p/w500/8c4a8kE7PizaGQQnditMmI1xbRp.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                const Icon(
                  Icons.play_circle_filled,
                  color: Colors.white,
                  size: 50,
                ),
              ],
            ),
          ),
        ),

        // HUD / Controls (Curved effect simulated by padding)
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
