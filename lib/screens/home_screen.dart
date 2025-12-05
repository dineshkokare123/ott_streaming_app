import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/content_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/content_row.dart';
import '../widgets/animated_bottom_nav.dart';
import '../widgets/shimmer_loading.dart';
import 'content_detail_screen.dart';
import 'search_screen.dart';
import 'watchlist_screen.dart';
import 'profile_screen.dart';
import '../models/content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load content when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContentProvider>(context, listen: false).loadAllContent();
    });
  }

  void _onNavigationTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const _HomeTab(),
      const SearchScreen(),
      const WatchlistScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: screens[_selectedIndex],
      ),
      bottomNavigationBar: AnimatedBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavigationTapped,
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  void _navigateToDetail(BuildContext context, Content content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContentDetailScreen(content: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContentProvider>(
      builder: (context, contentProvider, child) {
        if (contentProvider.isLoading) {
          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                backgroundColor: AppColors.background,
                elevation: 0,
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.play_circle_filled,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'StreamVibe',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Shimmer Loading
              SliverToBoxAdapter(
                child: Column(
                  children: const [
                    SizedBox(height: 16),
                    ShimmerContentRow(),
                    SizedBox(height: 24),
                    ShimmerContentRow(),
                    SizedBox(height: 24),
                    ShimmerContentRow(),
                    SizedBox(height: 24),
                    ShimmerContentRow(),
                  ],
                ),
              ),
            ],
          );
        }

        if (contentProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  contentProvider.error!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => contentProvider.refreshContent(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: contentProvider.refreshContent,
          color: AppColors.primary,
          backgroundColor: AppColors.backgroundLight,
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                backgroundColor: AppColors.background,
                elevation: 0,
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.play_circle_filled,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'StreamVibe',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Trending Content
                    ContentRow(
                      title: 'Trending Now',
                      content: contentProvider.trendingContent,
                      onContentTap: (content) =>
                          _navigateToDetail(context, content),
                    ),

                    const SizedBox(height: 24),

                    // Popular Movies
                    ContentRow(
                      title: 'Popular Movies',
                      content: contentProvider.popularMovies,
                      onContentTap: (content) =>
                          _navigateToDetail(context, content),
                    ),

                    const SizedBox(height: 24),

                    // Top Rated Movies
                    ContentRow(
                      title: 'Top Rated Movies',
                      content: contentProvider.topRatedMovies,
                      onContentTap: (content) =>
                          _navigateToDetail(context, content),
                    ),

                    const SizedBox(height: 24),

                    // Popular TV Shows
                    ContentRow(
                      title: 'Popular TV Shows',
                      content: contentProvider.popularTVShows,
                      onContentTap: (content) =>
                          _navigateToDetail(context, content),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
