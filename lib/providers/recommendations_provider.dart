import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/content.dart';
import '../constants/api_constants.dart';

class RecommendationsProvider extends ChangeNotifier {
  final Map<int, List<Content>> _similarContentCache = {};
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Content> getSimilarContent(int contentId) {
    return _similarContentCache[contentId] ?? [];
  }

  Future<void> loadSimilarContent(int contentId, String mediaType) async {
    if (_similarContentCache.containsKey(contentId)) {
      return; // Already loaded
    }

    _isLoading = true;
    notifyListeners();

    try {
      final endpoint = mediaType == 'movie'
          ? '/movie/$contentId/similar'
          : '/tv/$contentId/similar';

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}$endpoint?api_key=${ApiConstants.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        _similarContentCache[contentId] = results.take(10).map((json) {
          json['media_type'] = mediaType;
          return Content.fromJson(json);
        }).toList();
      }
    } catch (e) {
      debugPrint('Error loading similar content: $e');
      _similarContentCache[contentId] = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearCache() {
    _similarContentCache.clear();
    notifyListeners();
  }
}
