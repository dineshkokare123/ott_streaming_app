import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/content.dart';
import '../constants/api_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Get Trending Content
  Future<List<Content>> getTrendingContent() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.trending}?api_key=${ApiConstants.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((json) => Content.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load trending content');
      }
    } catch (e) {
      debugPrint('Error fetching trending content: $e');
      return _getMockContent('movie');
    }
  }

  // Get Popular Movies
  Future<List<Content>> getPopularMovies() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.popularMovies}?api_key=${ApiConstants.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((json) {
          json['media_type'] = 'movie';
          return Content.fromJson(json);
        }).toList();
      } else {
        throw Exception('Failed to load popular movies');
      }
    } catch (e) {
      debugPrint('Error fetching popular movies: $e');
      return _getMockContent('movie');
    }
  }

  // Get Top Rated Movies
  Future<List<Content>> getTopRatedMovies() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.topRatedMovies}?api_key=${ApiConstants.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((json) {
          json['media_type'] = 'movie';
          return Content.fromJson(json);
        }).toList();
      } else {
        throw Exception('Failed to load top rated movies');
      }
    } catch (e) {
      debugPrint('Error fetching top rated movies: $e');
      return _getMockContent('movie');
    }
  }

  // Get Popular TV Shows
  Future<List<Content>> getPopularTVShows() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.popularTVShows}?api_key=${ApiConstants.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((json) {
          json['media_type'] = 'tv';
          return Content.fromJson(json);
        }).toList();
      } else {
        throw Exception('Failed to load popular TV shows');
      }
    } catch (e) {
      debugPrint('Error fetching popular TV shows: $e');
      return _getMockContent('tv');
    }
  }

  // Get Movies by Genre
  Future<List<Content>> getMoviesByGenre(int genreId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.discoverMovie}?api_key=${ApiConstants.apiKey}&with_genres=$genreId',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((json) {
          json['media_type'] = 'movie';
          return Content.fromJson(json);
        }).toList();
      } else {
        throw Exception('Failed to load movies for genre $genreId');
      }
    } catch (e) {
      debugPrint('Error fetching movies for genre $genreId: $e');
      return _getMockContent('movie');
    }
  }

  // Search Content
  Future<List<Content>> searchContent(String query) async {
    if (query.isEmpty) return [];

    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url =
          '${ApiConstants.baseUrl}${ApiConstants.search}?api_key=${ApiConstants.apiKey}&query=$encodedQuery';
      debugPrint('Searching URL: $url');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        final filteredResults = results
            .where(
              (json) =>
                  json['media_type'] == 'movie' || json['media_type'] == 'tv',
            )
            .map((json) => Content.fromJson(json))
            .toList();
        debugPrint('Found ${filteredResults.length} results for query: $query');
        return filteredResults;
      } else {
        throw Exception('Failed to search content: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error searching content: $e');
      return [];
    }
  }

  // Get Content Details
  Future<Map<String, dynamic>> getContentDetails(
    int id,
    String mediaType,
  ) async {
    try {
      final endpoint = mediaType == 'movie'
          ? '${ApiConstants.movieDetails}/$id'
          : '${ApiConstants.tvDetails}/$id';

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}$endpoint?api_key=${ApiConstants.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load content details');
      }
    } catch (e) {
      debugPrint('Error fetching content details: $e');
      return {};
    }
  }

  // Get Content Videos (Trailers)
  Future<List<String>> getContentVideos(int id, String mediaType) async {
    try {
      final endpoint = mediaType == 'movie'
          ? '${ApiConstants.movieDetails}/$id/videos'
          : '${ApiConstants.tvDetails}/$id/videos';

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}$endpoint?api_key=${ApiConstants.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        // Filter for YouTube videos, preferably trailers
        final videos = results
            .where(
              (video) =>
                  video['site'] == 'YouTube' &&
                  (video['type'] == 'Trailer' || video['type'] == 'Teaser'),
            )
            .toList();

        if (videos.isNotEmpty) {
          return videos.map((v) => v['key'] as String).toList();
        }

        // If no trailers, return any YouTube video
        final anyVideo = results
            .where((video) => video['site'] == 'YouTube')
            .toList();
        return anyVideo.map((v) => v['key'] as String).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching content videos: $e');
      return [];
    }
  }

  // Get Content By ID (Try Movie then TV)
  Future<Content?> getContentById(int id) async {
    try {
      // Try fetching as movie first
      try {
        final movieResponse = await http.get(
          Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.movieDetails}/$id?api_key=${ApiConstants.apiKey}',
          ),
        );

        if (movieResponse.statusCode == 200) {
          final data = json.decode(movieResponse.body);
          data['media_type'] = 'movie';
          return Content.fromJson(data);
        }
      } catch (_) {}

      // If not movie, try TV show
      final tvResponse = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.tvDetails}/$id?api_key=${ApiConstants.apiKey}',
        ),
      );

      if (tvResponse.statusCode == 200) {
        final data = json.decode(tvResponse.body);
        data['media_type'] = 'tv';
        return Content.fromJson(data);
      }

      return null;
    } catch (e) {
      debugPrint('Error fetching content by ID $id: $e');
      return null;
    }
  }

  // Get IMDb ID
  Future<String?> getImdbId(int id, String type) async {
    try {
      final endpoint = type == 'movie'
          ? ApiConstants.movieDetails
          : ApiConstants.tvDetails;
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}$endpoint/$id/external_ids?api_key=${ApiConstants.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['imdb_id'] as String?;
      }
    } catch (e) {
      debugPrint('Error getting IMDb ID: $e');
    }
    return null;
  }

  // Get OTT Details
  Future<Map<String, dynamic>?> getOttDetails(String imdbId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.rapidApiBaseUrl}/gettitleDetails?imdbid=$imdbId',
        ),
        headers: {
          'X-RapidAPI-Key': ApiConstants.rapidApiKey,
          'X-RapidAPI-Host': ApiConstants.rapidApiHost,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        debugPrint('RapidAPI Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error getting OTT details: $e');
    }
    return null;
  }

  List<Content> _getMockContent(String mediaType) {
    return List.generate(10, (index) {
      return Content(
        id: index + 1000,
        title: '${mediaType == "movie" ? "Movie" : "TV Show"} ${index + 1}',
        overview:
            'This is a sample description for ${mediaType == "movie" ? "Movie" : "TV Show"} ${index + 1}. The real content could not be loaded due to network issues.',
        posterPath: null,
        backdropPath: null,
        voteAverage: 7.5 + (index % 3),
        voteCount: 100 + index * 10,
        releaseDate: '2024-01-0${index + 1}',
        mediaType: mediaType,
        genreIds: const [28, 12],
        popularity: 100.0 + index,
        originalLanguage: 'en',
      );
    });
  }
}
