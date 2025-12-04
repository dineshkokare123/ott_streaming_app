import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import '../constants/app_colors.dart';

class ParallaxHeader extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final double height;
  final ScrollController scrollController;

  const ParallaxHeader({
    super.key,
    required this.imageUrl,
    required this.title,
    this.height = 400,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        final offset = scrollController.hasClients
            ? scrollController.offset
            : 0.0;
        final parallaxOffset = offset * 0.5;

        return SizedBox(
          height: height,
          child: Stack(
            children: [
              // Parallax Background Image
              Positioned(
                top: -parallaxOffset,
                left: 0,
                right: 0,
                height: height + 100,
                child: imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: imageUrl!,
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
                    : Container(
                        color: AppColors.backgroundLight,
                        child: const Icon(
                          Icons.movie,
                          size: 80,
                          color: AppColors.textSecondary,
                        ),
                      ),
              ),

              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.background.withValues(alpha: 0.5),
                        AppColors.background,
                      ],
                      stops: const [0.0, 0.7, 1.0],
                    ),
                  ),
                ),
              ),

              // Blur Effect on Scroll
              if (offset > 0)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: (offset / 50).clamp(0, 10),
                      sigmaY: (offset / 50).clamp(0, 10),
                    ),
                    child: Container(
                      color: Colors.black.withValues(
                        alpha: (offset / 200).clamp(0, 0.5),
                      ),
                    ),
                  ),
                ),

              // Title at Bottom
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: Opacity(
                  opacity: (1 - (offset / 200)).clamp(0, 1),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, blurRadius: 20)],
                    ),
                  ),
                ),
              ),

              // Back Button
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
