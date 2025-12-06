import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Watch session model
class WatchSession {
  final String id;
  final int contentId;
  final String contentTitle;
  final String contentType; // 'movie' or 'tv'
  final String? genre;
  final int watchTimeMinutes;
  final DateTime startTime;
  final DateTime endTime;
  final bool completed;

  WatchSession({
    required this.id,
    required this.contentId,
    required this.contentTitle,
    required this.contentType,
    this.genre,
    required this.watchTimeMinutes,
    required this.startTime,
    required this.endTime,
    this.completed = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'contentId': contentId,
    'contentTitle': contentTitle,
    'contentType': contentType,
    'genre': genre,
    'watchTimeMinutes': watchTimeMinutes,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'completed': completed,
  };

  factory WatchSession.fromJson(Map<String, dynamic> json) => WatchSession(
    id: json['id'],
    contentId: json['contentId'],
    contentTitle: json['contentTitle'],
    contentType: json['contentType'],
    genre: json['genre'],
    watchTimeMinutes: json['watchTimeMinutes'],
    startTime: DateTime.parse(json['startTime']),
    endTime: DateTime.parse(json['endTime']),
    completed: json['completed'] ?? false,
  );
}

/// Daily watch stats
class DailyStats {
  final DateTime date;
  final int watchTimeMinutes;
  final int sessionsCount;
  final List<String> genresWatched;

  DailyStats({
    required this.date,
    required this.watchTimeMinutes,
    required this.sessionsCount,
    required this.genresWatched,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'watchTimeMinutes': watchTimeMinutes,
    'sessionsCount': sessionsCount,
    'genresWatched': genresWatched,
  };

  factory DailyStats.fromJson(Map<String, dynamic> json) => DailyStats(
    date: DateTime.parse(json['date']),
    watchTimeMinutes: json['watchTimeMinutes'],
    sessionsCount: json['sessionsCount'],
    genresWatched: List<String>.from(json['genresWatched']),
  );
}

/// Genre statistics
class GenreStats {
  final String genre;
  final int watchTimeMinutes;
  final int contentCount;
  final double percentage;

  GenreStats({
    required this.genre,
    required this.watchTimeMinutes,
    required this.contentCount,
    required this.percentage,
  });

  Map<String, dynamic> toJson() => {
    'genre': genre,
    'watchTimeMinutes': watchTimeMinutes,
    'contentCount': contentCount,
    'percentage': percentage,
  };

  factory GenreStats.fromJson(Map<String, dynamic> json) => GenreStats(
    genre: json['genre'],
    watchTimeMinutes: json['watchTimeMinutes'],
    contentCount: json['contentCount'],
    percentage: json['percentage'].toDouble(),
  );
}

/// Viewing pattern (time of day)
class ViewingPattern {
  final String timeSlot; // 'morning', 'afternoon', 'evening', 'night'
  final int watchTimeMinutes;
  final int sessionsCount;

  ViewingPattern({
    required this.timeSlot,
    required this.watchTimeMinutes,
    required this.sessionsCount,
  });

  Map<String, dynamic> toJson() => {
    'timeSlot': timeSlot,
    'watchTimeMinutes': watchTimeMinutes,
    'sessionsCount': sessionsCount,
  };

  factory ViewingPattern.fromJson(Map<String, dynamic> json) => ViewingPattern(
    timeSlot: json['timeSlot'],
    watchTimeMinutes: json['watchTimeMinutes'],
    sessionsCount: json['sessionsCount'],
  );
}

/// Year in review data (Spotify Wrapped style)
class YearInReview {
  final int year;
  final int totalWatchTimeMinutes;
  final int totalWatchTimeHours;
  final int moviesWatched;
  final int showsWatched;
  final int episodesWatched;
  final String topGenre;
  final List<GenreStats> topGenres;
  final String favoriteMovie;
  final String favoriteShow;
  final String mostWatchedDay;
  final String preferredTimeSlot;
  final int longestStreak;
  final double averageRating;
  final List<String> achievements;
  final Map<String, int> monthlyWatchTime;

  YearInReview({
    required this.year,
    required this.totalWatchTimeMinutes,
    required this.moviesWatched,
    required this.showsWatched,
    required this.episodesWatched,
    required this.topGenre,
    required this.topGenres,
    required this.favoriteMovie,
    required this.favoriteShow,
    required this.mostWatchedDay,
    required this.preferredTimeSlot,
    required this.longestStreak,
    required this.averageRating,
    required this.achievements,
    required this.monthlyWatchTime,
  }) : totalWatchTimeHours = totalWatchTimeMinutes ~/ 60;

  Map<String, dynamic> toJson() => {
    'year': year,
    'totalWatchTimeMinutes': totalWatchTimeMinutes,
    'totalWatchTimeHours': totalWatchTimeHours,
    'moviesWatched': moviesWatched,
    'showsWatched': showsWatched,
    'episodesWatched': episodesWatched,
    'topGenre': topGenre,
    'topGenres': topGenres.map((g) => g.toJson()).toList(),
    'favoriteMovie': favoriteMovie,
    'favoriteShow': favoriteShow,
    'mostWatchedDay': mostWatchedDay,
    'preferredTimeSlot': preferredTimeSlot,
    'longestStreak': longestStreak,
    'averageRating': averageRating,
    'achievements': achievements,
    'monthlyWatchTime': monthlyWatchTime,
  };

  factory YearInReview.fromJson(Map<String, dynamic> json) => YearInReview(
    year: json['year'],
    totalWatchTimeMinutes: json['totalWatchTimeMinutes'],
    moviesWatched: json['moviesWatched'],
    showsWatched: json['showsWatched'],
    episodesWatched: json['episodesWatched'],
    topGenre: json['topGenre'],
    topGenres: (json['topGenres'] as List)
        .map((g) => GenreStats.fromJson(g))
        .toList(),
    favoriteMovie: json['favoriteMovie'],
    favoriteShow: json['favoriteShow'],
    mostWatchedDay: json['mostWatchedDay'],
    preferredTimeSlot: json['preferredTimeSlot'],
    longestStreak: json['longestStreak'],
    averageRating: json['averageRating'].toDouble(),
    achievements: List<String>.from(json['achievements']),
    monthlyWatchTime: Map<String, int>.from(json['monthlyWatchTime']),
  );
}

/// Personalized insight
class PersonalizedInsight {
  final String id;
  final String type; // 'trend', 'recommendation', 'achievement', 'milestone'
  final String title;
  final String description;
  final String icon;
  final DateTime generatedAt;

  PersonalizedInsight({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.generatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'title': title,
    'description': description,
    'icon': icon,
    'generatedAt': generatedAt.toIso8601String(),
  };

  factory PersonalizedInsight.fromJson(Map<String, dynamic> json) =>
      PersonalizedInsight(
        id: json['id'],
        type: json['type'],
        title: json['title'],
        description: json['description'],
        icon: json['icon'],
        generatedAt: DateTime.parse(json['generatedAt']),
      );
}

/// Analytics Provider with API integration
class AnalyticsProvider extends ChangeNotifier {
  final String baseUrl;
  final String userId;

  List<WatchSession> _sessions = [];
  Map<DateTime, DailyStats> _dailyStats = {};
  List<GenreStats> _genreStats = [];
  List<ViewingPattern> _viewingPatterns = [];
  YearInReview? _yearInReview;
  List<PersonalizedInsight> _insights = [];

  bool _isLoading = false;
  String? _error;

  AnalyticsProvider({required this.baseUrl, required this.userId}) {
    _loadAnalytics();
  }

  // Getters
  List<WatchSession> get sessions => _sessions;
  Map<DateTime, DailyStats> get dailyStats => _dailyStats;
  List<GenreStats> get genreStats => _genreStats;
  List<ViewingPattern> get viewingPatterns => _viewingPatterns;
  YearInReview? get yearInReview => _yearInReview;
  List<PersonalizedInsight> get insights => _insights;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Computed stats
  int get totalWatchTimeMinutes =>
      _sessions.fold(0, (sum, session) => sum + session.watchTimeMinutes);

  int get totalWatchTimeHours => totalWatchTimeMinutes ~/ 60;

  int get totalMoviesWatched =>
      _sessions.where((s) => s.contentType == 'movie').length;

  int get totalShowsWatched =>
      _sessions.where((s) => s.contentType == 'tv').length;

  double get averageSessionLength =>
      _sessions.isEmpty ? 0 : totalWatchTimeMinutes / _sessions.length;

  /// Load all analytics data
  Future<void> _loadAnalytics() async {
    if (userId.isEmpty) return;

    // Skip analytics if using placeholder URL
    if (baseUrl.contains('example.com')) return;

    await Future.wait([
      fetchWatchSessions(),
      fetchDailyStats(),
      fetchGenreStats(),
      fetchViewingPatterns(),
      fetchInsights(),
    ]);
  }

  /// Fetch watch sessions from API
  Future<void> fetchWatchSessions({int? limit}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/analytics/sessions?userId=$userId${limit != null ? '&limit=$limit' : ''}',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _sessions = (data['sessions'] as List)
            .map((s) => WatchSession.fromJson(s))
            .toList();
      } else {
        _error = 'Failed to load watch sessions';
      }
    } catch (e) {
      _error = 'Error: $e';
      debugPrint('Error fetching watch sessions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Record new watch session
  Future<void> recordWatchSession(WatchSession session) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/analytics/sessions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId, ...session.toJson()}),
      );

      if (response.statusCode == 201) {
        _sessions.insert(0, session);
        notifyListeners();

        // Refresh stats
        await Future.wait([
          fetchDailyStats(),
          fetchGenreStats(),
          fetchViewingPatterns(),
        ]);
      }
    } catch (e) {
      debugPrint('Error recording watch session: $e');
    }
  }

  /// Fetch daily stats
  Future<void> fetchDailyStats({int? days}) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/analytics/daily?userId=$userId${days != null ? '&days=$days' : ''}',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _dailyStats = Map.fromEntries(
          (data['dailyStats'] as List).map((s) {
            final stat = DailyStats.fromJson(s);
            return MapEntry(stat.date, stat);
          }),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching daily stats: $e');
    }
  }

  /// Fetch genre statistics
  Future<void> fetchGenreStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/analytics/genres?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _genreStats = (data['genreStats'] as List)
            .map((g) => GenreStats.fromJson(g))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching genre stats: $e');
    }
  }

  /// Fetch viewing patterns
  Future<void> fetchViewingPatterns() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/analytics/patterns?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _viewingPatterns = (data['patterns'] as List)
            .map((p) => ViewingPattern.fromJson(p))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching viewing patterns: $e');
    }
  }

  /// Fetch year in review
  Future<void> fetchYearInReview(int year) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/analytics/year-in-review?userId=$userId&year=$year',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _yearInReview = YearInReview.fromJson(data);
      }
    } catch (e) {
      debugPrint('Error fetching year in review: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch personalized insights
  Future<void> fetchInsights() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/analytics/insights?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _insights = (data['insights'] as List)
            .map((i) => PersonalizedInsight.fromJson(i))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching insights: $e');
    }
  }

  /// Get watch time for specific period
  int getWatchTimeForPeriod(DateTime start, DateTime end) {
    return _sessions
        .where((s) => s.startTime.isAfter(start) && s.startTime.isBefore(end))
        .fold(0, (sum, s) => sum + s.watchTimeMinutes);
  }

  /// Get most watched genre
  String? getMostWatchedGenre() {
    if (_genreStats.isEmpty) return null;
    _genreStats.sort(
      (a, b) => b.watchTimeMinutes.compareTo(a.watchTimeMinutes),
    );
    return _genreStats.first.genre;
  }

  /// Get preferred viewing time
  String? getPreferredViewingTime() {
    if (_viewingPatterns.isEmpty) return null;
    _viewingPatterns.sort(
      (a, b) => b.watchTimeMinutes.compareTo(a.watchTimeMinutes),
    );
    return _viewingPatterns.first.timeSlot;
  }

  /// Refresh all analytics
  Future<void> refresh() async {
    await _loadAnalytics();
  }
}
