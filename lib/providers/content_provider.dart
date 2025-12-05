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

  // Load all content
  Future<void> loadAllContent() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.getTrendingContent(),
        _apiService.getPopularMovies(),
        _apiService.getTopRatedMovies(),
        _apiService.getPopularTVShows(),
        _apiService.getMoviesByGenre(ApiConstants.genreAction),
        _apiService.getMoviesByGenre(ApiConstants.genreComedy),
        _apiService.getMoviesByGenre(ApiConstants.genreHorror),
        _apiService.getMoviesByGenre(ApiConstants.genreSciFi),
      ]);

      _trendingContent = results[0];
      _popularMovies = results[1];
      _topRatedMovies = results[2];
      _popularTVShows = results[3];
      _actionMovies = results[4];
      _comedyMovies = results[5];
      _horrorMovies = results[6];
      _scifiMovies = results[7];
    } catch (e) {
      _error = 'Failed to load content: $e';
      debugPrint(_error);
    } finally {
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
