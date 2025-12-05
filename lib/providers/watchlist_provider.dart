import 'package:flutter/foundation.dart';
import '../models/content.dart';
import '../services/api_service.dart';

class WatchlistProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Content> _watchlistContent = [];
  bool _isLoading = false;

  List<Content> get watchlistContent => _watchlistContent;
  bool get isLoading => _isLoading;

  Future<void> loadWatchlist(List<int> ids) async {
    if (ids.isEmpty) {
      _watchlistContent = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final List<Content> loadedContent = [];

      // Fetch details for each ID in parallel
      // Fetch details for each ID in parallel
      final List<Future<Content?>> futures = ids
          .map((id) => _apiService.getContentById(id))
          .toList();
      final List<Content?> results = await Future.wait(futures);

      for (var content in results) {
        if (content != null) {
          loadedContent.add(content);
        }
      }

      _watchlistContent = loadedContent;
    } catch (e) {
      debugPrint('Error loading watchlist: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
