import 'package:flutter/foundation.dart';
import '../models/content.dart';
import '../services/api_service.dart';

class RecommendationsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final Map<int, List<Content>> _similarContentCache = {};
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Content> getSimilarContent(int contentId) {
    return _similarContentCache[contentId] ?? [];
  }

  Future<void> loadSimilarContent(int contentId, String mediaType) async {
    if (_similarContentCache.containsKey(contentId)) {
      return; // Already loaded
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Use ApiService method to get similar content
      final similarContent = await _apiService.getSimilarContent(
        contentId,
        mediaType,
      );

      _similarContentCache[contentId] = similarContent.take(10).toList();
    } catch (e) {
      debugPrint('Error loading similar content: $e');
      _similarContentCache[contentId] = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearCache() {
    _similarContentCache.clear();
    notifyListeners();
  }
}
