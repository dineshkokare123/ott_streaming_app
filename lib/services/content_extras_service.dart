import 'package:flutter/foundation.dart';

class MusicTrack {
  final String id;
  final String title;
  final String artist;
  final String albumArtUrl;
  final String previewUrl;
  final Duration timestamp;

  MusicTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumArtUrl,
    required this.previewUrl,
    required this.timestamp,
  });
}

class BonusContent {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final String type; // 'interview', 'bloopers', 'making_of'

  BonusContent({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.type,
  });
}

class ContentExtrasService extends ChangeNotifier {
  // Mock Data for Soundtracks
  final List<MusicTrack> _soundtracks = [
    MusicTrack(
      id: 't1',
      title: 'Running Up That Hill',
      artist: 'Kate Bush',
      albumArtUrl:
          'https://upload.wikimedia.org/wikipedia/en/b/b3/Kate_Bush_-_Running_Up_That_Hill.png',
      previewUrl: '',
      timestamp: const Duration(minutes: 15, seconds: 30),
    ),
    MusicTrack(
      id: 't2',
      title: 'Master of Puppets',
      artist: 'Metallica',
      albumArtUrl:
          'https://upload.wikimedia.org/wikipedia/en/b/b2/Metallica_-_Master_of_Puppets_cover.jpg',
      previewUrl: '',
      timestamp: const Duration(minutes: 45, seconds: 10),
    ),
  ];

  // Mock Data for Bonus Content
  final List<BonusContent> _bonusContent = [
    BonusContent(
      id: 'b1',
      title: 'Behind the VFX',
      description: 'See how the monsters were created.',
      thumbnailUrl: 'https://placeholder.com/vfx.jpg',
      videoUrl: '',
      type: 'making_of',
    ),
    BonusContent(
      id: 'b2',
      title: 'Cast Interviews',
      description: 'The cast talks about season 4.',
      thumbnailUrl: 'https://placeholder.com/cast.jpg',
      videoUrl: '',
      type: 'interview',
    ),
  ];

  List<MusicTrack> getSoundtracksForContent(String contentId) {
    // In a real app, filter by contentId
    return _soundtracks;
  }

  List<BonusContent> getBonusContent(String contentId) {
    return _bonusContent;
  }

  // Simulate "Shazam-style" discovery
  Future<MusicTrack?> identifyNowPlaying() async {
    await Future.delayed(const Duration(seconds: 2));
    // Simulate finding a track
    return _soundtracks.first;
  }
}
