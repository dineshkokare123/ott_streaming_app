// API Configuration Guide
//
// This file contains all the API endpoints and configuration for the OTT platform.
// API keys are now loaded from the .env file for security.
//
// HOW TO SET UP YOUR API KEYS:
// 1. Copy .env.example to .env
// 2. Get a FREE TMDB API key from https://www.themoviedb.org/settings/api
// 3. Get a RapidAPI key from https://rapidapi.com/gox-ai-gox-ai-default/api/ott-details
// 4. Add your keys to the .env file
// 5. NEVER commit the .env file to version control!

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // Base URL - You can replace this with your actual API
  static const String baseUrl = 'https://api.themoviedb.org/3';

  // ⚠️ IMPORTANT: API keys are now loaded from .env file
  // Make sure to set up your .env file before running the app
  static String get apiKey => dotenv.env['TMDB_API_KEY'] ?? '';

  // RapidAPI Configuration
  static String get rapidApiKey => dotenv.env['RAPID_API_KEY'] ?? '';
  static String get rapidApiHost =>
      dotenv.env['RAPID_API_HOST'] ?? 'ott-details.p.rapidapi.com';
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
