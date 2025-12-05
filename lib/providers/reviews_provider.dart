import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';

class ReviewsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, List<Review>> _reviewsCache = {};
  final Map<String, ContentRating> _ratingsCache = {};
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Review> getReviews(String contentId) {
    return _reviewsCache[contentId] ?? [];
  }

  ContentRating? getRating(String contentId) {
    return _ratingsCache[contentId];
  }

  Review? getUserReview(String contentId, String userId) {
    final reviews = _reviewsCache[contentId] ?? [];
    try {
      return reviews.firstWhere((r) => r.userId == userId);
    } catch (e) {
      return null;
    }
  }

  Future<void> loadReviews(String contentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('content_reviews')
          .doc(contentId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      _reviewsCache[contentId] = snapshot.docs
          .map((doc) => Review.fromJson(doc.data()))
          .toList();

      // Load rating summary
      await _loadRatingSummary(contentId);
    } catch (e) {
      debugPrint('Error loading reviews: $e');
      _reviewsCache[contentId] = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadRatingSummary(String contentId) async {
    try {
      final doc = await _firestore
          .collection('content_ratings')
          .doc(contentId)
          .get();

      if (doc.exists) {
        _ratingsCache[contentId] = ContentRating.fromJson(doc.data()!);
      } else {
        // Calculate from reviews if not exists
        final reviews = _reviewsCache[contentId] ?? [];
        if (reviews.isNotEmpty) {
          final avgRating =
              reviews.map((r) => r.rating).reduce((a, b) => a + b) /
              reviews.length;
          final distribution = <int, int>{};
          for (var i = 1; i <= 5; i++) {
            distribution[i] = reviews
                .where((r) => r.rating.round() == i)
                .length;
          }

          _ratingsCache[contentId] = ContentRating(
            contentId: contentId,
            averageRating: avgRating,
            totalReviews: reviews.length,
            ratingDistribution: distribution,
          );
        }
      }
    } catch (e) {
      debugPrint('Error loading rating summary: $e');
    }
  }

  Future<void> submitReview({
    required String contentId,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required double rating,
    String? reviewText,
  }) async {
    try {
      final reviewId = DateTime.now().millisecondsSinceEpoch.toString();

      final review = Review(
        id: reviewId,
        contentId: contentId,
        userId: userId,
        userName: userName,
        userPhotoUrl: userPhotoUrl,
        rating: rating,
        reviewText: reviewText,
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore
          .collection('content_reviews')
          .doc(contentId)
          .collection('reviews')
          .doc(reviewId)
          .set(review.toJson());

      // Update local cache
      if (_reviewsCache[contentId] == null) {
        _reviewsCache[contentId] = [];
      }
      _reviewsCache[contentId]!.insert(0, review);

      // Update rating summary
      await _updateRatingSummary(contentId);

      notifyListeners();
    } catch (e) {
      debugPrint('Error submitting review: $e');
      rethrow;
    }
  }

  Future<void> updateReview({
    required String contentId,
    required String reviewId,
    required double rating,
    String? reviewText,
  }) async {
    try {
      await _firestore
          .collection('content_reviews')
          .doc(contentId)
          .collection('reviews')
          .doc(reviewId)
          .update({
            'rating': rating,
            'reviewText': reviewText,
            'updatedAt': DateTime.now().toIso8601String(),
          });

      // Update local cache
      final reviews = _reviewsCache[contentId];
      if (reviews != null) {
        final index = reviews.indexWhere((r) => r.id == reviewId);
        if (index != -1) {
          reviews[index] = reviews[index].copyWith(
            rating: rating,
            reviewText: reviewText,
            updatedAt: DateTime.now(),
          );
        }
      }

      // Update rating summary
      await _updateRatingSummary(contentId);

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating review: $e');
      rethrow;
    }
  }

  Future<void> deleteReview(String contentId, String reviewId) async {
    try {
      await _firestore
          .collection('content_reviews')
          .doc(contentId)
          .collection('reviews')
          .doc(reviewId)
          .delete();

      // Update local cache
      _reviewsCache[contentId]?.removeWhere((r) => r.id == reviewId);

      // Update rating summary
      await _updateRatingSummary(contentId);

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting review: $e');
      rethrow;
    }
  }

  Future<void> markHelpful(
    String contentId,
    String reviewId,
    String userId,
  ) async {
    try {
      final reviews = _reviewsCache[contentId];
      if (reviews == null) return;

      final index = reviews.indexWhere((r) => r.id == reviewId);
      if (index == -1) return;

      final review = reviews[index];
      final isAlreadyHelpful = review.helpfulBy.contains(userId);

      List<String> newHelpfulBy;
      int newCount;

      if (isAlreadyHelpful) {
        // Remove helpful
        newHelpfulBy = List.from(review.helpfulBy)..remove(userId);
        newCount = review.helpfulCount - 1;
      } else {
        // Add helpful
        newHelpfulBy = List.from(review.helpfulBy)..add(userId);
        newCount = review.helpfulCount + 1;
      }

      await _firestore
          .collection('content_reviews')
          .doc(contentId)
          .collection('reviews')
          .doc(reviewId)
          .update({'helpfulBy': newHelpfulBy, 'helpfulCount': newCount});

      // Update local cache
      reviews[index] = review.copyWith(
        helpfulBy: newHelpfulBy,
        helpfulCount: newCount,
      );

      notifyListeners();
    } catch (e) {
      debugPrint('Error marking helpful: $e');
    }
  }

  Future<void> _updateRatingSummary(String contentId) async {
    try {
      final reviews = _reviewsCache[contentId] ?? [];

      if (reviews.isEmpty) {
        // Delete rating summary if no reviews
        await _firestore.collection('content_ratings').doc(contentId).delete();
        _ratingsCache.remove(contentId);
        return;
      }

      final avgRating =
          reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
      final distribution = <int, int>{};

      for (var i = 1; i <= 5; i++) {
        distribution[i] = reviews.where((r) => r.rating.round() == i).length;
      }

      final rating = ContentRating(
        contentId: contentId,
        averageRating: avgRating,
        totalReviews: reviews.length,
        ratingDistribution: distribution,
      );

      await _firestore
          .collection('content_ratings')
          .doc(contentId)
          .set(rating.toJson());

      _ratingsCache[contentId] = rating;
    } catch (e) {
      debugPrint('Error updating rating summary: $e');
    }
  }

  void clearCache() {
    _reviewsCache.clear();
    _ratingsCache.clear();
    notifyListeners();
  }
}
