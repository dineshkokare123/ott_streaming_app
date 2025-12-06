import 'package:flutter/foundation.dart';
import '../models/content.dart';
import '../models/user_profile.dart';

/// Advanced recommendation engine for personalized content suggestions
class RecommendationEngine {
  /// Generate personalized recommendations based on user behavior
  static List<Content> generateRecommendations({
    required List<Content> allContent,
    required List<int> watchHistory,
    required List<int> watchlist,
    required List<int> favorites,
    required Map<int, double> ratings,
    UserProfile? profile,
    int limit = 20,
  }) {
    final scoredContent = <Content, double>{};

    for (final content in allContent) {
      // Skip already watched content
      if (watchHistory.contains(content.id)) continue;

      double score = 0.0;

      // 1. Content-based filtering (genre similarity)
      score += _calculateGenreScore(
        content,
        allContent,
        watchHistory,
        favorites,
      );

      // 2. Popularity score
      score += _calculatePopularityScore(content);

      // 3. Rating score
      score += _calculateRatingScore(content);

      // 4. Collaborative filtering (similar users)
      score += _calculateCollaborativeScore(content, ratings, watchHistory);

      // 5. Recency boost (newer content gets slight boost)
      score += _calculateRecencyScore(content);

      // 6. Profile-based filtering
      if (profile != null) {
        score += _calculateProfileScore(content, profile);
      }

      scoredContent[content] = score;
    }

    // Sort by score and return top recommendations
    final sortedContent = scoredContent.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedContent.take(limit).map((entry) => entry.key).toList();
  }

  /// Calculate genre-based similarity score
  static double _calculateGenreScore(
    Content content,
    List<Content> allContent,
    List<int> watchHistory,
    List<int> favorites,
  ) {
    if (content.genreIds == null || content.genreIds!.isEmpty) return 0.0;

    // Get genres from watch history and favorites
    final userGenres = <int, int>{};

    for (final id in [...watchHistory, ...favorites]) {
      final watchedContent = allContent.firstWhere(
        (c) => c.id == id,
        orElse: () => content,
      );

      if (watchedContent.genreIds != null) {
        for (final genreId in watchedContent.genreIds!) {
          userGenres[genreId] = (userGenres[genreId] ?? 0) + 1;
        }
      }
    }

    // Calculate overlap
    double genreScore = 0.0;
    for (final genreId in content.genreIds!) {
      if (userGenres.containsKey(genreId)) {
        genreScore += userGenres[genreId]! * 2.0; // Weight by frequency
      }
    }

    return genreScore;
  }

  /// Calculate popularity score
  static double _calculatePopularityScore(Content content) {
    if (content.popularity == null) return 0.0;
    // Normalize popularity (typically 0-1000) to 0-10 range
    return (content.popularity! / 100).clamp(0.0, 10.0);
  }

  /// Calculate rating score
  static double _calculateRatingScore(Content content) {
    if (content.voteAverage == null) return 0.0;
    // Vote average is already 0-10
    return content.voteAverage! * 1.5; // Boost highly rated content
  }

  /// Calculate collaborative filtering score
  static double _calculateCollaborativeScore(
    Content content,
    Map<int, double> userRatings,
    List<int> watchHistory,
  ) {
    // Simple collaborative filtering based on similar content
    double score = 0.0;

    // If user has rated similar content highly, boost this content
    if (content.genreIds != null) {
      for (final id in watchHistory) {
        if (userRatings.containsKey(id) && userRatings[id]! >= 4.0) {
          score += 2.0;
        }
      }
    }

    return score;
  }

  /// Calculate recency score (boost newer content)
  static double _calculateRecencyScore(Content content) {
    if (content.releaseDate == null || content.releaseDate!.isEmpty) {
      return 0.0;
    }

    try {
      final releaseDate = DateTime.parse(content.releaseDate!);
      final now = DateTime.now();
      final daysSinceRelease = now.difference(releaseDate).inDays;

      // Boost content released in the last year
      if (daysSinceRelease < 365) {
        return 5.0 - (daysSinceRelease / 365 * 5.0);
      }
    } catch (e) {
      debugPrint('Error parsing release date: $e');
    }

    return 0.0;
  }

  /// Calculate profile-based score
  static double _calculateProfileScore(Content content, UserProfile profile) {
    double score = 0.0;

    // Age-appropriate content
    if (profile.isKidsProfile) {
      // Boost family-friendly content
      if (content.adult == false) {
        score += 10.0;
      } else {
        score -= 50.0; // Heavily penalize adult content for kids
      }
    }

    return score;
  }

  /// Get trending recommendations (based on popularity and recency)
  static List<Content> getTrendingRecommendations(
    List<Content> allContent, {
    int limit = 10,
  }) {
    final scored = allContent.map((content) {
      final popularityScore = _calculatePopularityScore(content);
      final recencyScore = _calculateRecencyScore(content);
      final ratingScore = _calculateRatingScore(content);

      return MapEntry(content, popularityScore + recencyScore + ratingScore);
    }).toList()..sort((a, b) => b.value.compareTo(a.value));

    return scored.take(limit).map((e) => e.key).toList();
  }

  /// Get similar content based on a specific content item
  static List<Content> getSimilarContent(
    Content targetContent,
    List<Content> allContent, {
    int limit = 10,
  }) {
    final scored = <Content, double>{};

    for (final content in allContent) {
      if (content.id == targetContent.id) continue;

      double score = 0.0;

      // Same media type (movie/tv)
      if (content.mediaType == targetContent.mediaType) {
        score += 5.0;
      }

      // Genre overlap
      if (content.genreIds != null && targetContent.genreIds != null) {
        final overlap = content.genreIds!
            .where((id) => targetContent.genreIds!.contains(id))
            .length;
        score += overlap * 10.0;
      }

      // Similar rating
      if (content.voteAverage != null && targetContent.voteAverage != null) {
        final ratingDiff = (content.voteAverage! - targetContent.voteAverage!)
            .abs();
        score += (10 - ratingDiff).clamp(0.0, 10.0);
      }

      // Similar popularity
      if (content.popularity != null && targetContent.popularity != null) {
        final popDiff = (content.popularity! - targetContent.popularity!).abs();
        score += (100 - popDiff / 10).clamp(0.0, 10.0);
      }

      scored[content] = score;
    }

    final sorted = scored.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(limit).map((e) => e.key).toList();
  }

  /// Get "Because you watched X" recommendations
  static List<Content> getBecauseYouWatchedRecommendations(
    Content watchedContent,
    List<Content> allContent,
    List<int> watchHistory, {
    int limit = 10,
  }) {
    return getSimilarContent(
      watchedContent,
      allContent.where((c) => !watchHistory.contains(c.id)).toList(),
      limit: limit,
    );
  }

  /// Get top picks for user
  static List<Content> getTopPicks({
    required List<Content> allContent,
    required List<int> watchHistory,
    required List<int> favorites,
    int limit = 10,
  }) {
    // Combine highly rated and popular content that matches user preferences
    final scored = allContent.map((content) {
      if (watchHistory.contains(content.id)) {
        return MapEntry(content, 0.0);
      }

      final genreScore = _calculateGenreScore(
        content,
        allContent,
        watchHistory,
        favorites,
      );
      final ratingScore = _calculateRatingScore(content);
      final popularityScore = _calculatePopularityScore(content);

      return MapEntry(content, genreScore + ratingScore * 2 + popularityScore);
    }).toList()..sort((a, b) => b.value.compareTo(a.value));

    return scored.take(limit).map((e) => e.key).toList();
  }
}
