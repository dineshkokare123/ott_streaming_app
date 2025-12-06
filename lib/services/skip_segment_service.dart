import 'package:flutter/material.dart';

/// Model for skip segments (intro, outro, recap, credits)
class SkipSegment {
  final String type; // 'intro', 'outro', 'recap', 'credits'
  final int startTime; // in seconds
  final int endTime; // in seconds
  final String label;

  SkipSegment({
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.label,
  });

  bool isInSegment(int currentPosition) {
    return currentPosition >= startTime && currentPosition <= endTime;
  }

  int get duration => endTime - startTime;
}

/// Service to manage skip segments for content
class SkipSegmentService {
  /// Get skip segments for a content item
  /// In production, this would come from your backend/database
  static List<SkipSegment> getSkipSegments(int contentId) {
    // Example data - in production, fetch from API
    // This is just demo data for common skip patterns
    return [
      // Skip intro (typically 0:00 - 1:30)
      SkipSegment(
        type: 'intro',
        startTime: 0,
        endTime: 90,
        label: 'Skip Intro',
      ),
      // Skip recap (typically 1:30 - 2:00)
      SkipSegment(
        type: 'recap',
        startTime: 90,
        endTime: 120,
        label: 'Skip Recap',
      ),
      // Skip credits/outro (typically last 2 minutes)
      SkipSegment(
        type: 'credits',
        startTime: 5400, // 90 minutes - 2 minutes
        endTime: 5520, // 92 minutes
        label: 'Skip Credits',
      ),
    ];
  }

  /// Check if current position is in any skip segment
  static SkipSegment? getCurrentSkipSegment(
    int contentId,
    int currentPosition,
  ) {
    final segments = getSkipSegments(contentId);
    for (final segment in segments) {
      if (segment.isInSegment(currentPosition)) {
        return segment;
      }
    }
    return null;
  }

  /// Get next episode skip segment
  static SkipSegment? getNextEpisodeSegment(
    int currentPosition,
    int videoDuration,
  ) {
    // Show "Next Episode" button in last 30 seconds
    final nextEpisodeStart = videoDuration - 30;
    if (currentPosition >= nextEpisodeStart) {
      return SkipSegment(
        type: 'next_episode',
        startTime: nextEpisodeStart,
        endTime: videoDuration,
        label: 'Next Episode',
      );
    }
    return null;
  }
}

/// Widget to display skip button overlay on video player
class SkipButton extends StatelessWidget {
  final SkipSegment segment;
  final VoidCallback onSkip;
  final bool showCountdown;

  const SkipButton({
    super.key,
    required this.segment,
    required this.onSkip,
    this.showCountdown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSkip,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  segment.label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.fast_forward, color: Colors.black, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget for "Next Episode" button with countdown
class NextEpisodeButton extends StatefulWidget {
  final VoidCallback onTap;
  final int secondsRemaining;

  const NextEpisodeButton({
    super.key,
    required this.onTap,
    required this.secondsRemaining,
  });

  @override
  State<NextEpisodeButton> createState() => _NextEpisodeButtonState();
}

class _NextEpisodeButtonState extends State<NextEpisodeButton> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE50914), // Netflix red
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.skip_next, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Next Episode',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Starting in ${widget.secondsRemaining}s',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Example usage in video player
/// 
/// ```dart
/// // In your video player widget
/// Stack(
///   children: [
///     VideoPlayer(controller),
///     
///     // Add skip button overlay
///     ValueListenableBuilder(
///       valueListenable: controller.position,
///       builder: (context, position, _) {
///         final currentSeconds = position.inSeconds;
///         final skipSegment = SkipSegmentService.getCurrentSkipSegment(
///           contentId,
///           currentSeconds,
///         );
///         
///         if (skipSegment != null) {
///           return SkipButton(
///             segment: skipSegment,
///             onSkip: () {
///               controller.seekTo(Duration(seconds: skipSegment.endTime));
///             },
///           );
///         }
///         
///         // Check for next episode
///         final nextEpisode = SkipSegmentService.getNextEpisodeSegment(
///           currentSeconds,
///           controller.value.duration.inSeconds,
///         );
///         
///         if (nextEpisode != null) {
///           return NextEpisodeButton(
///             onTap: () {
///               // Navigate to next episode
///               Navigator.push(...);
///             },
///             secondsRemaining: nextEpisode.endTime - currentSeconds,
///           );
///         }
///         
///         return const SizedBox.shrink();
///       },
///     ),
///   ],
/// )
/// ```
