// API Configuration Guide
//
// This file contains all the API endpoints and configuration for the OTT platform.
// You need to get a FREE API key from TMDB to use this app.
//
// HOW TO GET YOUR API KEY:
// 1. Go to https://www.themoviedb.org/
// 2. Sign up for a free account
// 3. Go to Settings → API
// 4. Request an API key (instant approval)
// 5. Copy your API key and paste it below
//
// REPLACE 'YOUR_TMDB_API_KEY' with your actual API key

class ApiConstants {
  // Base URL - You can replace this with your actual API
  static const String baseUrl = 'https://api.themoviedb.org/3';

  // ⚠️ IMPORTANT: Replace YOUR_TMDB_API_KEY with your actual API key
  // Get it from: https://www.themoviedb.org/settings/api
  static const String apiKey = 'YOUR_TMDB_API_KEY';

  // API Endpoints
  static const String trending = '/trending/all/week';
  static const String popularMovies = '/movie/popular';
  static const String topRatedMovies = '/movie/top_rated';
  static const String upcomingMovies = '/movie/upcoming';
  static const String popularTVShows = '/tv/popular';
  static const String topRatedTVShows = '/tv/top_rated';
  static const String search = '/search/multi';
  static const String movieDetails = '/movie';
  static const String tvDetails = '/tv';

  // Image Base URLs
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';
  static const String posterSize = 'w500';
  static const String backdropSize = 'w780';
  static const String originalSize = 'original';

  // Helper methods to construct image URLs
  static String getPosterUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '$imageBaseUrl/$posterSize$path';
  }

  static String getBackdropUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '$imageBaseUrl/$backdropSize$path';
  }

  static String getOriginalImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '$imageBaseUrl/$originalSize$path';
  }
}
