import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/content.dart';
import '../constants/api_constants.dart';
import '../constants/app_colors.dart';

class AnimatedContentCard extends StatefulWidget {
  final Content content;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const AnimatedContentCard({
    super.key,
    required this.content,
    this.onTap,
    this.width = 140,
    this.height = 200,
  });

  @override
  State<AnimatedContentCard> createState() => _AnimatedContentCardState();
}

class _AnimatedContentCardState extends State<AnimatedContentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 12.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverChange(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverChange(true),
      onExit: (_) => _onHoverChange(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Hero(
                tag: 'content_${widget.content.id}',
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: _elevationAnimation.value,
                        offset: Offset(0, _elevationAnimation.value / 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Poster Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: widget.content.posterPath != null
                            ? CachedNetworkImage(
                                imageUrl: ApiConstants.getPosterUrl(
                                  widget.content.posterPath,
                                ),
                                width: widget.width,
                                height: widget.height,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppColors.shimmerBase,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
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
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: _isHovered ? 80 : 60,
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
                                Colors.black.withValues(alpha: 0.9),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Rating Badge
                      if (widget.content.voteAverage != null &&
                          widget.content.voteAverage! > 0)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: AnimatedOpacity(
                            opacity: _isHovered ? 1.0 : 0.9,
                            duration: const Duration(milliseconds: 200),
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
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.content.rating,
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
                        ),

                      // Play Icon on Hover
                      if (_isHovered)
                        Positioned.fill(
                          child: Center(
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 200),
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.9,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
