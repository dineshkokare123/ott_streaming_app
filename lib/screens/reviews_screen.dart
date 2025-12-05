import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/reviews_provider.dart';
import '../providers/auth_provider.dart';
import '../models/review.dart';
import '../models/content.dart';
import '../constants/app_colors.dart';

class ReviewsScreen extends StatefulWidget {
  final Content content;

  const ReviewsScreen({super.key, required this.content});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReviewsProvider>(
        context,
        listen: false,
      ).loadReviews(widget.content.id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Reviews & Ratings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Consumer2<ReviewsProvider, AuthProvider>(
        builder: (context, reviewsProvider, authProvider, _) {
          final reviews = reviewsProvider.getReviews(
            widget.content.id.toString(),
          );
          final rating = reviewsProvider.getRating(
            widget.content.id.toString(),
          );
          final userReview = reviewsProvider.getUserReview(
            widget.content.id.toString(),
            authProvider.currentUser?.id ?? '',
          );

          return CustomScrollView(
            slivers: [
              // Rating Summary
              if (rating != null)
                SliverToBoxAdapter(child: _buildRatingSummary(rating)),

              // Write Review Button
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () => _showReviewDialog(
                      context,
                      reviewsProvider,
                      authProvider,
                      userReview,
                    ),
                    icon: Icon(
                      userReview != null ? Icons.edit : Icons.rate_review,
                    ),
                    label: Text(
                      userReview != null
                          ? 'Edit Your Review'
                          : 'Write a Review',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),

              // Reviews List
              if (reviews.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.rate_review_outlined,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No reviews yet',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Be the first to review!',
                          style: TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final review = reviews[index];
                    return _buildReviewCard(
                      review,
                      reviewsProvider,
                      authProvider.currentUser?.id ?? '',
                    );
                  }, childCount: reviews.length),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRatingSummary(ContentRating rating) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Average Rating
              Expanded(
                child: Column(
                  children: [
                    Text(
                      rating.averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildStars(rating.averageRating),
                    const SizedBox(height: 8),
                    Text(
                      '${rating.totalReviews} ${rating.totalReviews == 1 ? 'review' : 'reviews'}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              // Rating Distribution
              Expanded(
                flex: 2,
                child: Column(
                  children: List.generate(5, (index) {
                    final star = 5 - index;
                    final count = rating.ratingDistribution[star] ?? 0;
                    final percentage = rating.totalReviews > 0
                        ? count / rating.totalReviews
                        : 0.0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Text(
                            '$star',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.star,
                            color: AppColors.primary,
                            size: 12,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: percentage,
                                backgroundColor: AppColors.background,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 30,
                            child: Text(
                              count.toString(),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(
    Review review,
    ReviewsProvider provider,
    String currentUserId,
  ) {
    final isCurrentUser = review.userId == currentUserId;
    final isHelpful = review.helpfulBy.contains(currentUserId);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary,
                backgroundImage: review.userPhotoUrl != null
                    ? CachedNetworkImageProvider(review.userPhotoUrl!)
                    : null,
                child: review.userPhotoUrl == null
                    ? Text(
                        review.userName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      review.timeAgo,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCurrentUser)
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppColors.textSecondary,
                  ),
                  color: AppColors.backgroundLight,
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showReviewDialog(
                        context,
                        provider,
                        Provider.of<AuthProvider>(context, listen: false),
                        review,
                      );
                    } else if (value == 'delete') {
                      _deleteReview(context, provider, review);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Edit',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: AppColors.error),
                          SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Rating Stars
          _buildStars(review.rating),

          if (review.reviewText != null && review.reviewText!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              review.reviewText!,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Helpful Button
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  provider.markHelpful(
                    widget.content.id.toString(),
                    review.id,
                    currentUserId,
                  );
                },
                icon: Icon(
                  isHelpful ? Icons.thumb_up : Icons.thumb_up_outlined,
                  size: 16,
                  color: isHelpful
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                label: Text(
                  'Helpful (${review.helpfulCount})',
                  style: TextStyle(
                    color: isHelpful
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: AppColors.primary, size: 16);
        } else if (index < rating) {
          return const Icon(
            Icons.star_half,
            color: AppColors.primary,
            size: 16,
          );
        } else {
          return const Icon(
            Icons.star_outline,
            color: AppColors.primary,
            size: 16,
          );
        }
      }),
    );
  }

  void _showReviewDialog(
    BuildContext context,
    ReviewsProvider provider,
    AuthProvider authProvider,
    Review? existingReview,
  ) {
    double rating = existingReview?.rating ?? 0;
    final textController = TextEditingController(
      text: existingReview?.reviewText ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppColors.backgroundLight,
          title: Text(
            existingReview != null ? 'Edit Review' : 'Write a Review',
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Rating',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_outline,
                        color: AppColors.primary,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          rating = (index + 1).toDouble();
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your Review (Optional)',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: textController,
                  maxLines: 5,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Share your thoughts...',
                    hintStyle: const TextStyle(color: AppColors.textTertiary),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: rating > 0
                  ? () async {
                      try {
                        if (existingReview != null) {
                          await provider.updateReview(
                            contentId: widget.content.id.toString(),
                            reviewId: existingReview.id,
                            rating: rating,
                            reviewText: textController.text.trim().isEmpty
                                ? null
                                : textController.text.trim(),
                          );
                        } else {
                          await provider.submitReview(
                            contentId: widget.content.id.toString(),
                            userId: authProvider.currentUser!.id,
                            userName: authProvider.currentUser!.displayName,
                            userPhotoUrl: authProvider.currentUser!.photoUrl,
                            rating: rating,
                            reviewText: textController.text.trim().isEmpty
                                ? null
                                : textController.text.trim(),
                          );
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                existingReview != null
                                    ? 'Review updated!'
                                    : 'Review submitted!',
                              ),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteReview(
    BuildContext context,
    ReviewsProvider provider,
    Review review,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: const Text(
          'Delete Review',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to delete your review?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await provider.deleteReview(
                  widget.content.id.toString(),
                  review.id,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Review deleted'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
