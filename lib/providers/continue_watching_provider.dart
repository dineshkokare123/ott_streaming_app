import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/content.dart';

class WatchHistoryItem {
  final String contentId;
  final String title;
  final String? posterPath;
  final int watchedDuration; // in seconds
  final int totalDuration; // in seconds
  final DateTime lastWatched;
  final String mediaType;

  WatchHistoryItem({
    required this.contentId,
    required this.title,
    this.posterPath,
    required this.watchedDuration,
    required this.totalDuration,
    required this.lastWatched,
    required this.mediaType,
  });

  double get progress =>
      totalDuration > 0 ? watchedDuration / totalDuration : 0;

  Map<String, dynamic> toJson() => {
    'contentId': contentId,
    'title': title,
    'posterPath': posterPath,
    'watchedDuration': watchedDuration,
    'totalDuration': totalDuration,
    'lastWatched': lastWatched.toIso8601String(),
    'mediaType': mediaType,
  };

  factory WatchHistoryItem.fromJson(Map<String, dynamic> json) {
    return WatchHistoryItem(
      contentId: json['contentId'] as String,
      title: json['title'] as String,
      posterPath: json['posterPath'] as String?,
      watchedDuration: json['watchedDuration'] as int,
      totalDuration: json['totalDuration'] as int,
      lastWatched: DateTime.parse(json['lastWatched'] as String),
      mediaType: json['mediaType'] as String,
    );
  }
}

class ContinueWatchingProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<WatchHistoryItem> _continueWatching = [];
  bool _isLoading = false;

  List<WatchHistoryItem> get continueWatching => _continueWatching;
  bool get isLoading => _isLoading;

  // Load continue watching for user
  Future<void> loadContinueWatching(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('watch_history')
          .orderBy('lastWatched', descending: true)
          .limit(20)
          .get();

      _continueWatching = snapshot.docs
          .map((doc) => WatchHistoryItem.fromJson(doc.data()))
          .where(
            (item) => item.progress < 0.95,
          ) // Only show if not fully watched
          .toList();
    } catch (e) {
      debugPrint('Error loading continue watching: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update watch progress
  Future<void> updateWatchProgress({
    required String userId,
    required Content content,
    required int watchedDuration,
    required int totalDuration,
  }) async {
    try {
      final item = WatchHistoryItem(
        contentId: content.id.toString(),
        title: content.title,
        posterPath: content.posterPath,
        watchedDuration: watchedDuration,
        totalDuration: totalDuration,
        lastWatched: DateTime.now(),
        mediaType: content.mediaType,
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('watch_history')
          .doc(content.id.toString())
          .set(item.toJson());

      // Update local list
      final index = _continueWatching.indexWhere(
        (w) => w.contentId == content.id.toString(),
      );
      if (index != -1) {
        _continueWatching[index] = item;
      } else {
        _continueWatching.insert(0, item);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating watch progress: $e');
    }
  }

  // Remove from continue watching
  Future<void> removeFromContinueWatching(
    String userId,
    String contentId,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('watch_history')
          .doc(contentId)
          .delete();

      _continueWatching.removeWhere((item) => item.contentId == contentId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing from continue watching: $e');
    }
  }
}
