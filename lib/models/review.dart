class Review {
  final String id;
  final String contentId;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final double rating; // 1-5 stars
  final String? reviewText;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int helpfulCount;
  final List<String> helpfulBy; // User IDs who marked as helpful

  Review({
    required this.id,
    required this.contentId,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.rating,
    this.reviewText,
    required this.createdAt,
    this.updatedAt,
    this.helpfulCount = 0,
    this.helpfulBy = const [],
  });

  Review copyWith({
    String? id,
    String? contentId,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    double? rating,
    String? reviewText,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? helpfulCount,
    List<String>? helpfulBy,
  }) {
    return Review(
      id: id ?? this.id,
      contentId: contentId ?? this.contentId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      helpfulBy: helpfulBy ?? this.helpfulBy,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contentId': contentId,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'rating': rating,
      'reviewText': reviewText,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'helpfulCount': helpfulCount,
      'helpfulBy': helpfulBy,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      contentId: json['contentId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userPhotoUrl: json['userPhotoUrl'] as String?,
      rating: (json['rating'] as num).toDouble(),
      reviewText: json['reviewText'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      helpfulCount: json['helpfulCount'] as int? ?? 0,
      helpfulBy:
          (json['helpfulBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}

class ContentRating {
  final String contentId;
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // Star count -> number of ratings

  ContentRating({
    required this.contentId,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  factory ContentRating.fromJson(Map<String, dynamic> json) {
    return ContentRating(
      contentId: json['contentId'] as String,
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: json['totalReviews'] as int,
      ratingDistribution: (json['ratingDistribution'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(int.parse(key), value as int)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contentId': contentId,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'ratingDistribution': ratingDistribution.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
    };
  }
}
