import 'package:flutter/foundation.dart';
import '../models/content.dart';
import '../services/api_service.dart';

class RecommendationEngine extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Content> _recommendations = [];
  bool _isLoading = false;

  List<Content> get recommendations => _recommendations;
  bool get isLoading => _isLoading;

  // Generate recommendations based on user's watch history and favorites
  Future<void> generateRecommendations({
    required List<int> watchedContentIds,
    required List<int> favoriteContentIds,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // In a real app, this would use ML/AI algorithms
      // For now, we'll use a simple approach:
      // 1. Get trending content
      // 2. Filter out already watched
      // 3. Prioritize similar genres

      final trending = await _apiService.getTrendingContent();
      final popular = await _apiService.getPopularMovies();
      final topRated = await _apiService.getTopRatedMovies();

      // Combine and deduplicate
      final allContent = <int, Content>{};
      for (var content in [...trending, ...popular, ...topRated]) {
        if (!watchedContentIds.contains(content.id)) {
          allContent[content.id] = content;
        }
      }

      // Simple scoring algorithm
      _recommendations = allContent.values.toList()
        ..sort((a, b) {
          // Prioritize favorites' similar content
          final aScore = _calculateScore(a, favoriteContentIds);
          final bScore = _calculateScore(b, favoriteContentIds);
          return bScore.compareTo(aScore);
        });

      // Limit to top 20
      if (_recommendations.length > 20) {
        _recommendations = _recommendations.sublist(0, 20);
      }
    } catch (e) {
      debugPrint('Error generating recommendations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  double _calculateScore(Content content, List<int> favoriteIds) {
    double score = 0;

    // Base score from rating
    if (content.voteAverage != null) {
      score += content.voteAverage! * 10;
    }

    // Boost for popularity
    if (content.popularity != null) {
      score += content.popularity! / 10;
    }

    // Boost if similar to favorites (simplified)
    if (favoriteIds.isNotEmpty) {
      score += 20; // In real app, check genre similarity
    }

    return score;
  }

  // Get similar content based on a specific content item
  Future<List<Content>> getSimilarContent(Content content) async {
    try {
      // In real app, use TMDB's similar/recommendations endpoint
      // For now, return trending of same type
      if (content.mediaType == 'movie') {
        return await _apiService.getPopularMovies();
      } else {
        return await _apiService.getPopularTVShows();
      }
    } catch (e) {
      debugPrint('Error getting similar content: $e');
      return [];
    }
  }

  // Get personalized homepage sections
  Map<String, List<Content>> getPersonalizedSections() {
    return {
      'Recommended For You': _recommendations.take(10).toList(),
      'Trending Now': _recommendations.skip(10).take(10).toList(),
    };
  }
}
