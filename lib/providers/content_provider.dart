import 'package:flutter/foundation.dart';
import '../models/content.dart';
import '../services/api_service.dart';
import '../constants/api_constants.dart';

class ContentProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Content> _trendingContent = [];
  List<Content> _popularMovies = [];
  List<Content> _topRatedMovies = [];
  List<Content> _popularTVShows = [];
  List<Content> _actionMovies = [];
  List<Content> _comedyMovies = [];
  List<Content> _horrorMovies = [];
  List<Content> _scifiMovies = [];
  List<Content> _searchResults = [];

  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;

  // Getters
  List<Content> get trendingContent => _trendingContent;
  List<Content> get popularMovies => _popularMovies;
  List<Content> get topRatedMovies => _topRatedMovies;
  List<Content> get popularTVShows => _popularTVShows;
  List<Content> get actionMovies => _actionMovies;
  List<Content> get comedyMovies => _comedyMovies;
  List<Content> get horrorMovies => _horrorMovies;
  List<Content> get scifiMovies => _scifiMovies;
  List<Content> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get error => _error;

  // Load all content progressively
  Future<void> loadAllContent() async {
    // Only show full loading state if we have no content at all
    if (_trendingContent.isEmpty && _popularMovies.isEmpty) {
      _isLoading = true;
      notifyListeners();
    }

    _error = null;

    try {
      // 1. Critical Content (Above the fold) - Sequential load to avoid network issues
      final trending = await _apiService.getTrendingContent();
      _trendingContent = trending;
      notifyListeners(); // Update UI immediately with trending

      await Future.delayed(const Duration(milliseconds: 200));

      final popular = await _apiService.getPopularMovies();
      _popularMovies = popular;
      _isLoading = false;
      notifyListeners();

      // 2. Secondary Content - Load in parallel but don't block UI
      // We start these requests and update state as they finish group by group

      // Group A: Top Rated & TV Shows - Wait a bit before starting
      await Future.delayed(const Duration(milliseconds: 200));
      Future.wait([
        _apiService.getTopRatedMovies(),
        _apiService.getPopularTVShows(),
      ]).then((results) {
        _topRatedMovies = results[0];
        _popularTVShows = results[1];
        notifyListeners();
      });

      // Group B: Genres (staggered to avoid connection resets)
      // We load them one by one or in small batches

      await Future.delayed(const Duration(milliseconds: 500));
      _apiService
          .getMoviesByGenre(ApiConstants.genreAction)
          .then((results) async {
            _actionMovies = results;
            notifyListeners();

            await Future.delayed(const Duration(milliseconds: 200));
            return _apiService.getMoviesByGenre(ApiConstants.genreSciFi);
          })
          .then((results) async {
            _scifiMovies = results;
            notifyListeners();

            await Future.delayed(const Duration(milliseconds: 200));
            return _apiService.getMoviesByGenre(ApiConstants.genreComedy);
          })
          .then((results) async {
            _comedyMovies = results;
            notifyListeners();

            await Future.delayed(const Duration(milliseconds: 200));
            return _apiService.getMoviesByGenre(ApiConstants.genreHorror);
          })
          .then((results) {
            _horrorMovies = results;
            notifyListeners();
          });
    } catch (e) {
      _error = 'Failed to load content: $e';
      debugPrint(_error);
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search content
  Future<void> searchContent(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      _searchResults = await _apiService.searchContent(query);
    } catch (e) {
      debugPrint('Error searching content: $e');
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  // Clear search
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  // Refresh content
  Future<void> refreshContent() async {
    await loadAllContent();
  }
}
