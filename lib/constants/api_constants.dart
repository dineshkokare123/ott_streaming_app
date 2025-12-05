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
  static const String apiKey = '5119b1bb88f8b1133a139578c96a70f4';

  // RapidAPI Configuration
  static const String rapidApiKey =
      'a62b366bf9msh4a0cffa8591d6b5p1d13cajsn95e07bc2814a';
  static const String rapidApiHost = 'ott-details.p.rapidapi.com';
  static const String rapidApiBaseUrl = 'https://ott-details.p.rapidapi.com';

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
  static const String discoverMovie = '/discover/movie';

  // Genre IDs
  static const int genreAction = 28;
  static const int genreComedy = 35;
  static const int genreHorror = 27;
  static const int genreSciFi = 878;
  static const int genreRomance = 10749;
  static const int genreAnimation = 16;
  static const int genreCrime = 80;
  static const int genreDrama = 18;

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
