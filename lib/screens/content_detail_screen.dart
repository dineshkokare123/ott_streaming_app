import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/content.dart';
import '../providers/auth_provider.dart';
import '../providers/recommendations_provider.dart';
import '../providers/download_provider.dart';
import '../providers/reviews_provider.dart';
import '../providers/profile_provider.dart';
import '../services/api_service.dart';
import '../constants/api_constants.dart';
import '../constants/app_colors.dart';
import '../widgets/content_card.dart';
import 'video_player_screen.dart';
import 'full_video_player_screen.dart';
import 'reviews_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/localization_service.dart';

class ContentDetailScreen extends StatelessWidget {
  final Content content;

  const ContentDetailScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final localization = Provider.of<LocalizationService>(context);
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
                  Consumer2<AuthProvider, ProfileProvider>(
                    builder: (context, authProvider, profileProvider, child) {
                      final isInWatchlist = profileProvider.isInWatchlist(
                        content.id,
                      );
                      final isInFavorites = profileProvider.isInFavorites(
                        content.id,
                      );

                      return Column(
                        children: [
                          // Watch Movie Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _showWatchOptions(context);
                              },
                              icon: const Icon(
                                Icons.play_arrow_rounded,
                                size: 28,
                              ),
                              label: Text(
                                content.mediaType == 'movie'
                                    ? '${'play'.tr(localization)} ${'movie'.tr(localization)}'
                                    : '${'play'.tr(localization)} ${'episode'.tr(localization)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              // Trailer Button
                              Expanded(
                                flex: 2,
                                child: OutlinedButton.icon(
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
                                              content: Text(
                                                'No trailer available',
                                              ),
                                              backgroundColor: AppColors.error,
                                            ),
                                          );
                                        }
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        Navigator.pop(context); // Hide loading
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
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
                                  icon: const Icon(
                                    Icons.movie_creation_outlined,
                                  ),
                                  label: Text('trailer'.tr(localization)),
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

                              // Watchlist Button
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final user = authProvider.currentUser;
                                    if (user == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please sign in to use this feature',
                                          ),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                      return;
                                    }

                                    var profile =
                                        profileProvider.currentProfile;

                                    // Auto-select first profile if none selected but profiles exist
                                    if (profile == null &&
                                        profileProvider.profiles.isNotEmpty) {
                                      profile = profileProvider.profiles.first;
                                      profileProvider.switchProfile(profile);
                                    }

                                    if (profile == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'select_profile_first'.tr(
                                              localization,
                                            ),
                                          ),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                      return;
                                    }

                                    try {
                                      if (isInWatchlist) {
                                        await profileProvider
                                            .removeFromWatchlist(
                                              user.id,
                                              profile.id,
                                              content.id,
                                            );
                                      } else {
                                        await profileProvider.addToWatchlist(
                                          user.id,
                                          profile.id,
                                          content.id,
                                        );
                                      }

                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              isInWatchlist
                                                  ? 'removed_from_list'.tr(
                                                      localization,
                                                    )
                                                  : 'added_to_list'.tr(
                                                      localization,
                                                    ),
                                            ),
                                            duration: const Duration(
                                              seconds: 2,
                                            ),
                                            backgroundColor: AppColors.primary,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text('Error: $e'),
                                            backgroundColor: AppColors.error,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  icon: Icon(
                                    isInWatchlist ? Icons.check : Icons.add,
                                    color: isInWatchlist
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                  ),
                                  label: Text(
                                    'my_list'.tr(localization),
                                    style: TextStyle(
                                      color: isInWatchlist
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: isInWatchlist
                                          ? AppColors.primary
                                          : AppColors.textSecondary,
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
                                onPressed: () async {
                                  final user = authProvider.currentUser;
                                  if (user == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please sign in to use this feature',
                                        ),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                    return;
                                  }

                                  var profile = profileProvider.currentProfile;

                                  // Auto-select first profile if none selected but profiles exist
                                  if (profile == null &&
                                      profileProvider.profiles.isNotEmpty) {
                                    profile = profileProvider.profiles.first;
                                    profileProvider.switchProfile(profile);
                                  }

                                  if (profile == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'select_profile_first'.tr(
                                            localization,
                                          ),
                                        ),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                    return;
                                  }

                                  try {
                                    if (isInFavorites) {
                                      await profileProvider.removeFromFavorites(
                                        user.id,
                                        profile.id,
                                        content.id,
                                      );
                                    } else {
                                      await profileProvider.addToFavorites(
                                        user.id,
                                        profile.id,
                                        content.id,
                                      );
                                    }

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            isInFavorites
                                                ? 'removed_from_favorites'.tr(
                                                    localization,
                                                  )
                                                : 'added_to_favorites'.tr(
                                                    localization,
                                                  ),
                                          ),
                                          duration: const Duration(seconds: 2),
                                          backgroundColor: AppColors.primary,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Error: $e'),
                                          duration: const Duration(seconds: 3),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                    }
                                  }
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
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Download Button
                  Consumer2<DownloadProvider, AuthProvider>(
                    builder: (context, downloadProvider, authProvider, _) {
                      final isDownloaded = downloadProvider.isDownloaded(
                        content.id.toString(),
                      );
                      final isDownloading = downloadProvider.isDownloading(
                        content.id.toString(),
                      );
                      final download = downloadProvider.getDownload(
                        content.id.toString(),
                      );

                      return SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            if (isDownloaded) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Already downloaded'),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                              return;
                            }

                            if (isDownloading) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Download in progress'),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                              return;
                            }

                            // Show quality selection
                            final quality = await showDialog<String>(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: AppColors.backgroundLight,
                                title: const Text(
                                  'Select Quality',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: const Text(
                                        'SD',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      subtitle: const Text(
                                        '~500MB',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      onTap: () => Navigator.pop(context, 'SD'),
                                    ),
                                    ListTile(
                                      title: const Text(
                                        'HD',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      subtitle: const Text(
                                        '~1.2GB',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      onTap: () => Navigator.pop(context, 'HD'),
                                    ),
                                    ListTile(
                                      title: const Text(
                                        'FHD',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      subtitle: const Text(
                                        '~2.5GB',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      onTap: () =>
                                          Navigator.pop(context, 'FHD'),
                                    ),
                                  ],
                                ),
                              ),
                            );

                            if (quality != null &&
                                authProvider.currentUser != null) {
                              await downloadProvider.startDownload(
                                authProvider.currentUser!.id,
                                content,
                                quality: quality,
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Downloading in $quality quality',
                                    ),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                              }
                            }
                          },
                          icon: Icon(
                            isDownloaded
                                ? Icons.download_done
                                : isDownloading
                                ? Icons.downloading
                                : Icons.download,
                          ),
                          label: Text(
                            isDownloaded
                                ? 'downloaded'.tr(localization)
                                : isDownloading
                                ? download?.progressPercent ?? "0%"
                                : 'download'.tr(localization),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDownloaded
                                ? Colors.green
                                : AppColors.textPrimary,
                            side: BorderSide(
                              color: isDownloaded
                                  ? Colors.green
                                  : AppColors.textSecondary,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Reviews & Ratings Button
                  Consumer<ReviewsProvider>(
                    builder: (context, reviewsProvider, _) {
                      final rating = reviewsProvider.getRating(
                        content.id.toString(),
                      );

                      return SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReviewsScreen(content: content),
                              ),
                            );
                          },
                          icon: const Icon(Icons.star_outline),
                          label: Text(
                            rating != null
                                ? '${rating.averageRating.toStringAsFixed(1)} ★ (${rating.totalReviews} reviews)'
                                : 'rate_review'.tr(localization),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(
                              color: AppColors.textSecondary,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Overview
                  if (content.overview != null &&
                      content.overview!.isNotEmpty) ...[
                    Text(
                      'overview'.tr(localization),
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

                  // Similar Content Section
                  Consumer<RecommendationsProvider>(
                    builder: (context, recommendationsProvider, _) {
                      final similarContent = recommendationsProvider
                          .getSimilarContent(content.id);

                      if (similarContent.isEmpty &&
                          !recommendationsProvider.isLoading) {
                        // Load similar content
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          recommendationsProvider.loadSimilarContent(
                            content.id,
                            content.mediaType,
                          );
                        });
                      }

                      if (similarContent.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'more_like_this'.tr(localization),
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: similarContent.length,
                              itemBuilder: (context, index) {
                                final item = similarContent[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: index == similarContent.length - 1
                                        ? 0
                                        : 12,
                                  ),
                                  child: ContentCard(
                                    content: item,
                                    width: 120,
                                    height: 180,
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ContentDetailScreen(
                                                content: item,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      );
                    },
                  ),
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

  void _showWatchOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Watch Options',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.play_circle_filled,
                color: AppColors.primary,
                size: 30,
              ),
              title: const Text(
                'Play Demo Video',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Simulated full-length playback',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Navigator.pop(context);
                _playSampleVideo(context);
              },
            ),
            Divider(color: Colors.grey[800]),
            ListTile(
              leading: const Icon(Icons.search, color: Colors.blue, size: 30),
              title: const Text(
                'Find Streaming Sources',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Search Netflix, Amazon via Gox-AI API',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Navigator.pop(context);
                _searchStreamingLinks(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _playSampleVideo(BuildContext context) {
    final sampleVideos = [
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoy.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4',
    ];

    final videoUrl = sampleVideos[content.id % sampleVideos.length];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FullVideoPlayerScreen(videoUrl: videoUrl, title: content.title),
      ),
    );
  }

  Future<void> _searchStreamingLinks(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      final apiService = ApiService();
      final imdbId = await apiService.getImdbId(content.id, content.mediaType);

      if (imdbId == null) {
        if (context.mounted) Navigator.pop(context);
        if (context.mounted) _showError(context, 'Could not find IMDb ID');
        return;
      }

      final details = await apiService.getOttDetails(imdbId);
      if (context.mounted) Navigator.pop(context);

      if (details != null && context.mounted) {
        _showStreamingDialog(context, details);
      } else {
        if (context.mounted) _showError(context, 'No streaming details found');
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) _showError(context, 'Error: $e');
    }
  }

  void _showStreamingDialog(
    BuildContext context,
    Map<String, dynamic> details,
  ) {
    if (details['streamingAvailability'] == null ||
        details['streamingAvailability']['country'] == null) {
      _showError(context, 'No streaming links found for this title.');
      return;
    }

    final countries =
        details['streamingAvailability']['country'] as Map<String, dynamic>;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Streaming Links',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: countries.keys.length,
                itemBuilder: (context, index) {
                  final countryCode = countries.keys.elementAt(index);
                  final platforms = countries[countryCode] as List;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Country: $countryCode',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...platforms.map<Widget>((p) {
                        return ListTile(
                          leading: const Icon(Icons.tv, color: Colors.white),
                          title: Text(
                            p['platform'].toString().toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: const Icon(
                            Icons.open_in_new,
                            color: Colors.grey,
                          ),
                          onTap: () async {
                            final url = Uri.parse(p['url']);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              if (context.mounted) {
                                _showError(context, 'Could not launch URL');
                              }
                            }
                          },
                        );
                      }),
                      Divider(color: Colors.grey[800]),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }
}
