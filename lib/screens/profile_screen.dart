import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/glass_container.dart';
import 'login_screen.dart';
import 'watchlist_screen.dart';
import 'edit_profile_screen.dart';
import 'watch_history_screen.dart';
import 'downloads_screen.dart';
import 'profile_selection_screen.dart';
import 'parental_controls_screen.dart';
import 'notifications_screen.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.currentUser;

          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: AppColors.background,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF2A2D3E), AppColors.background],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 32),

                          // Profile Switcher
                          Consumer<ProfileProvider>(
                            builder: (context, profileProvider, _) {
                              final currentProfile =
                                  profileProvider.currentProfile;

                              if (currentProfile == null) {
                                return const SizedBox.shrink();
                              }

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileSelectionScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      // Current Profile Avatar
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: AppColors.background,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            currentProfile.avatarUrl,
                                            style: const TextStyle(
                                              fontSize: 28,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Current Profile',
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              currentProfile.name,
                                              style: const TextStyle(
                                                color: AppColors.textPrimary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.textSecondary,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 32),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                              image: user.photoUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(user.photoUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: user.photoUrl == null
                                ? const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: AppColors.textSecondary,
                                  )
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user.displayName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user.email,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Account',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMenuItem(
                        icon: Icons.person_outline,
                        title: 'Edit Profile',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.security,
                        title: 'Privacy & Security',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ParentalControlsScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'Content',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMenuItem(
                        icon: Icons.playlist_play,
                        title: 'My List',
                        onTap: () {
                          // Navigate to Watchlist (if not already on tab)
                          // Or push WatchlistScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WatchlistScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.history,
                        title: 'Watch History',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WatchHistoryScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.download_done,
                        title: 'Downloads',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DownloadsScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () async {
                            await authProvider.signOut();
                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.error),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Sign Out',
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(12),
      blur: 10,
      opacity: 0.05,
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text(
          feature,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'This feature is coming soon!',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
