import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/content.dart';
import '../constants/api_constants.dart';
import '../constants/app_colors.dart';

class ContentCard extends StatelessWidget {
  final Content content;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const ContentCard({
    super.key,
    required this.content,
    this.onTap,
    this.width = 120,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Poster Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: content.posterPath != null
                  ? CachedNetworkImage(
                      imageUrl: ApiConstants.getPosterUrl(content.posterPath),
                      width: width,
                      height: height,
                      memCacheWidth: (width * 2)
                          .toInt(), // Optimize memory usage
                      memCacheHeight: (height * 2).toInt(),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.shimmerBase,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.backgroundLight,
                        child: const Icon(
                          Icons.movie,
                          color: AppColors.textSecondary,
                          size: 40,
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.backgroundLight,
                      child: const Icon(
                        Icons.movie,
                        color: AppColors.textSecondary,
                        size: 40,
                      ),
                    ),
            ),

            // Gradient Overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
            ),

            // Rating Badge
            if (content.voteAverage != null && content.voteAverage! > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        content.rating,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
