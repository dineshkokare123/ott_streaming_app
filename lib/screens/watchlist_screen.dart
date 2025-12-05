import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/watchlist_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/content_card.dart';
import 'content_detail_screen.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  void initState() {
    super.initState();
    _loadWatchlist();
  }

  void _loadWatchlist() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final watchlistProvider = Provider.of<WatchlistProvider>(
      context,
      listen: false,
    );

    if (authProvider.currentUser != null) {
      watchlistProvider.loadWatchlist(authProvider.currentUser!.watchlist);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Consumer2<AuthProvider, WatchlistProvider>(
        builder: (context, authProvider, watchlistProvider, _) {
          if (authProvider.currentUser == null) {
            return const Center(
              child: Text(
                'Please sign in to view your watchlist',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          if (watchlistProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (watchlistProvider.watchlistContent.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.playlist_add,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your watchlist is empty',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add movies and shows to watch later',
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadWatchlist();
            },
            color: AppColors.primary,
            backgroundColor: AppColors.backgroundLight,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: watchlistProvider.watchlistContent.length,
              itemBuilder: (context, index) {
                final content = watchlistProvider.watchlistContent[index];
                return ContentCard(
                  content: content,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ContentDetailScreen(content: content),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
