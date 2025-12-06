import 'package:flutter/foundation.dart';
import '../providers/download_provider.dart';
import '../models/content.dart';

class SmartDownloadService extends ChangeNotifier {
  final DownloadProvider _downloadProvider;
  bool _isSmartDownloadsEnabled = true;

  SmartDownloadService(this._downloadProvider);

  bool get isEnabled => _isSmartDownloadsEnabled;

  void toggleSmartDownloads(bool value) {
    _isSmartDownloadsEnabled = value;
    notifyListeners();
  }

  // Called when an episode is finished
  Future<void> onEpisodeFinished(String userId, Content currentEpisode) async {
    if (!_isSmartDownloadsEnabled) return;

    // Logic to find next episode would go here.
    // For demo, we will simulate finding "Episode N+1"

    debugPrint('Smart Downloads: Analyzing for next episode...');

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // Create a mock "Next Episode"
    final nextEpisode = Content(
      id: currentEpisode.id + 1,
      title: 'Next Episode: ${currentEpisode.title}',
      posterPath: currentEpisode.posterPath,
      backdropPath: currentEpisode.backdropPath,
      overview: 'The story continues...',
      mediaType: 'tv',
      voteAverage: 8.5,
      releaseDate: DateTime.now().toString(),
      genreIds: currentEpisode.genreIds,
    );

    debugPrint('Smart Downloads: Auto-downloading ${nextEpisode.title}');

    // Trigger download via the provider
    // Using a default quality of 'HD'
    await _downloadProvider.startDownload(userId, nextEpisode, quality: 'HD');

    // Also, delete the watched episode to save space (Standard Smart Download behavior)
    // _downloadProvider.deleteDownload(userId, currentEpisode.id);
  }
}
