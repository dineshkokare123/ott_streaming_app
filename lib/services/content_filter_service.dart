import 'package:flutter/material.dart';
import '../models/content.dart';

/// Content filter options
class ContentFilter {
  final List<String> genres;
  final List<int> years;
  final double? minRating;
  final double? maxRating;
  final String? mediaType; // 'movie' or 'tv'
  final int? minDuration; // in minutes
  final int? maxDuration; // in minutes
  final String? language;
  final bool? includeAdult;
  final SortOption sortBy;

  ContentFilter({
    this.genres = const [],
    this.years = const [],
    this.minRating,
    this.maxRating,
    this.mediaType,
    this.minDuration,
    this.maxDuration,
    this.language,
    this.includeAdult,
    this.sortBy = SortOption.popularity,
  });

  ContentFilter copyWith({
    List<String>? genres,
    List<int>? years,
    double? minRating,
    double? maxRating,
    String? mediaType,
    int? minDuration,
    int? maxDuration,
    String? language,
    bool? includeAdult,
    SortOption? sortBy,
  }) {
    return ContentFilter(
      genres: genres ?? this.genres,
      years: years ?? this.years,
      minRating: minRating ?? this.minRating,
      maxRating: maxRating ?? this.maxRating,
      mediaType: mediaType ?? this.mediaType,
      minDuration: minDuration ?? this.minDuration,
      maxDuration: maxDuration ?? this.maxDuration,
      language: language ?? this.language,
      includeAdult: includeAdult ?? this.includeAdult,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get hasActiveFilters {
    return genres.isNotEmpty ||
        years.isNotEmpty ||
        minRating != null ||
        maxRating != null ||
        mediaType != null ||
        minDuration != null ||
        maxDuration != null ||
        language != null ||
        includeAdult != null;
  }

  int get activeFilterCount {
    int count = 0;
    if (genres.isNotEmpty) count++;
    if (years.isNotEmpty) count++;
    if (minRating != null || maxRating != null) count++;
    if (mediaType != null) count++;
    if (minDuration != null || maxDuration != null) count++;
    if (language != null) count++;
    if (includeAdult != null) count++;
    return count;
  }

  ContentFilter clear() {
    return ContentFilter(sortBy: sortBy);
  }
}

/// Sort options for content
enum SortOption {
  popularity('Popularity', Icons.trending_up),
  rating('Rating', Icons.star),
  releaseDate('Release Date', Icons.calendar_today),
  title('Title (A-Z)', Icons.sort_by_alpha),
  newest('Newest First', Icons.new_releases),
  oldest('Oldest First', Icons.history);

  final String label;
  final IconData icon;

  const SortOption(this.label, this.icon);
}

/// Service to filter and sort content
class ContentFilterService {
  /// Apply filters to content list
  static List<Content> applyFilters(
    List<Content> content,
    ContentFilter filter,
  ) {
    var filtered = content;

    // Filter by media type
    if (filter.mediaType != null) {
      filtered = filtered
          .where((c) => c.mediaType == filter.mediaType)
          .toList();
    }

    // Filter by genres
    if (filter.genres.isNotEmpty) {
      filtered = filtered.where((c) {
        if (c.genreIds == null) return false;
        // Check if content has any of the selected genres
        return filter.genres.any((genre) {
          // In production, you'd map genre names to IDs
          return c.genreIds!.contains(int.tryParse(genre) ?? 0);
        });
      }).toList();
    }

    // Filter by year
    if (filter.years.isNotEmpty) {
      filtered = filtered.where((c) {
        if (c.releaseDate == null) return false;
        final year = int.tryParse(c.year);
        return year != null && filter.years.contains(year);
      }).toList();
    }

    // Filter by rating
    if (filter.minRating != null) {
      filtered = filtered
          .where(
            (c) => c.voteAverage != null && c.voteAverage! >= filter.minRating!,
          )
          .toList();
    }
    if (filter.maxRating != null) {
      filtered = filtered
          .where(
            (c) => c.voteAverage != null && c.voteAverage! <= filter.maxRating!,
          )
          .toList();
    }

    // Filter by language
    if (filter.language != null) {
      filtered = filtered
          .where((c) => c.originalLanguage == filter.language)
          .toList();
    }

    // Filter by adult content
    if (filter.includeAdult != null && !filter.includeAdult!) {
      filtered = filtered.where((c) => c.adult != true).toList();
    }

    // Apply sorting
    filtered = sortContent(filtered, filter.sortBy);

    return filtered;
  }

  /// Sort content by specified option
  static List<Content> sortContent(List<Content> content, SortOption sortBy) {
    final sorted = List<Content>.from(content);

    switch (sortBy) {
      case SortOption.popularity:
        sorted.sort((a, b) {
          final popA = a.popularity ?? 0;
          final popB = b.popularity ?? 0;
          return popB.compareTo(popA);
        });
        break;

      case SortOption.rating:
        sorted.sort((a, b) {
          final ratingA = a.voteAverage ?? 0;
          final ratingB = b.voteAverage ?? 0;
          return ratingB.compareTo(ratingA);
        });
        break;

      case SortOption.releaseDate:
      case SortOption.newest:
        sorted.sort((a, b) {
          if (a.releaseDate == null) return 1;
          if (b.releaseDate == null) return -1;
          return b.releaseDate!.compareTo(a.releaseDate!);
        });
        break;

      case SortOption.oldest:
        sorted.sort((a, b) {
          if (a.releaseDate == null) return 1;
          if (b.releaseDate == null) return -1;
          return a.releaseDate!.compareTo(b.releaseDate!);
        });
        break;

      case SortOption.title:
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    return sorted;
  }

  /// Get available years from content
  static List<int> getAvailableYears(List<Content> content) {
    final years = <int>{};
    for (final item in content) {
      final year = int.tryParse(item.year);
      if (year != null) years.add(year);
    }
    final sortedYears = years.toList()..sort((a, b) => b.compareTo(a));
    return sortedYears;
  }

  /// Get available languages from content
  static List<String> getAvailableLanguages(List<Content> content) {
    final languages = <String>{};
    for (final item in content) {
      if (item.originalLanguage != null) {
        languages.add(item.originalLanguage!);
      }
    }
    return languages.toList()..sort();
  }
}

/// Common genre IDs from TMDB
class GenreIds {
  static const Map<String, int> movie = {
    'Action': 28,
    'Adventure': 12,
    'Animation': 16,
    'Comedy': 35,
    'Crime': 80,
    'Documentary': 99,
    'Drama': 18,
    'Family': 10751,
    'Fantasy': 14,
    'History': 36,
    'Horror': 27,
    'Music': 10402,
    'Mystery': 9648,
    'Romance': 10749,
    'Science Fiction': 878,
    'TV Movie': 10770,
    'Thriller': 53,
    'War': 10752,
    'Western': 37,
  };

  static const Map<String, int> tv = {
    'Action & Adventure': 10759,
    'Animation': 16,
    'Comedy': 35,
    'Crime': 80,
    'Documentary': 99,
    'Drama': 18,
    'Family': 10751,
    'Kids': 10762,
    'Mystery': 9648,
    'News': 10763,
    'Reality': 10764,
    'Sci-Fi & Fantasy': 10765,
    'Soap': 10766,
    'Talk': 10767,
    'War & Politics': 10768,
    'Western': 37,
  };

  static List<String> getGenreNames(String mediaType) {
    return mediaType == 'movie' ? movie.keys.toList() : tv.keys.toList();
  }

  static int? getGenreId(String genreName, String mediaType) {
    return mediaType == 'movie' ? movie[genreName] : tv[genreName];
  }
}
