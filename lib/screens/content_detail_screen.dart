import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/content.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../constants/api_constants.dart';
import '../constants/app_colors.dart';
import 'video_player_screen.dart';

class ContentDetailScreen extends StatelessWidget {
  final Content content;

  const ContentDetailScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Backdrop
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Backdrop Image
                  if (content.backdropPath != null)
                    CachedNetworkImage(
                      imageUrl: ApiConstants.getBackdropUrl(
                        content.backdropPath,
                      ),
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: AppColors.backgroundLight),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.backgroundLight,
                        child: const Icon(
                          Icons.movie,
                          size: 80,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  else
                    Container(color: AppColors.backgroundLight),

                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.background.withValues(alpha: 0.8),
                          AppColors.background,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    content.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Year, Rating, Media Type
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          content.year,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (content.voteAverage != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              content.rating,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          content.mediaType.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      final isInWatchlist = authProvider.isInWatchlist(
                        content.id,
                      );
                      final isInFavorites = authProvider.isInFavorites(
                        content.id,
                      );

                      return Row(
                        children: [
                          // Play Button
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                // Show loading
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                );

                                try {
                                  final videos = await ApiService()
                                      .getContentVideos(
                                        content.id,
                                        content.mediaType,
                                      );

                                  if (context.mounted) {
                                    Navigator.pop(context); // Hide loading

                                    if (videos.isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VideoPlayerScreen(
                                                videoId: videos.first,
                                              ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('No trailer available'),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    Navigator.pop(context); // Hide loading
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Error loading video: $e',
                                        ),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Play Trailer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Watchlist Button
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                authProvider.toggleWatchlist(content.id);
                              },
                              icon: Icon(
                                isInWatchlist
                                    ? Icons.bookmark
                                    : Icons.bookmark_outline,
                              ),
                              label: const Text('List'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.textPrimary,
                                side: const BorderSide(
                                  color: AppColors.textSecondary,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Favorite Button
                          IconButton(
                            onPressed: () {
                              authProvider.toggleFavorites(content.id);
                            },
                            icon: Icon(
                              isInFavorites
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: isInFavorites
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.backgroundLight,
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Overview
                  if (content.overview != null &&
                      content.overview!.isNotEmpty) ...[
                    const Text(
                      'Overview',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      content.overview!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Additional Info
                  if (content.popularity != null)
                    _buildInfoRow(
                      'Popularity',
                      content.popularity!.toStringAsFixed(1),
                    ),

                  if (content.voteCount != null)
                    _buildInfoRow('Vote Count', content.voteCount.toString()),

                  if (content.originalLanguage != null)
                    _buildInfoRow(
                      'Language',
                      content.originalLanguage!.toUpperCase(),
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
