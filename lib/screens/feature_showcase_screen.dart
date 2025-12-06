import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/subscription_service.dart';
import '../services/smart_notification_service.dart';

import 'soundtrack_finder_screen.dart';
import 'shared_watchlist_screen.dart';
import 'creator_studio_screen.dart';
import 'trailer_feed_screen.dart';
import 'bonus_content_screen.dart';
import 'vr_theater_screen.dart';
import '../services/smart_download_service.dart';
import 'social_hub_screen.dart';
import 'watch_party_live_screen.dart';

class FeatureShowcaseScreen extends StatelessWidget {
  const FeatureShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('New Features 🚀'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildThemeSection(context),
          const SizedBox(height: 24),
          _buildSubscriptionSection(context),
          const SizedBox(height: 24),
          _buildSocialSection(context),
          const SizedBox(height: 24),
          _buildNotificationSection(context),
          const SizedBox(height: 24),
          _buildUpcomingFeatures(context),
        ],
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🎨 Appearance',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              _buildThemeOption(
                context,
                themeService,
                'Netflix Red (Dark)',
                AppThemeMode.dark,
              ),
              _buildThemeOption(
                context,
                themeService,
                'Light Mode',
                AppThemeMode.light,
              ),
              _buildThemeOption(
                context,
                themeService,
                'Ocean Blue',
                AppThemeMode.oceanBlue,
              ),
              _buildThemeOption(
                context,
                themeService,
                'Midnight Purple',
                AppThemeMode.midnightPurple,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeService service,
    String title,
    AppThemeMode mode,
  ) {
    return RadioListTile<AppThemeMode>(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
      value: mode,
      // ignore: deprecated_member_use
      groupValue: service.currentMode,
      // ignore: deprecated_member_use
      onChanged: (value) {
        if (value != null) service.setTheme(value);
      },
      activeColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildSubscriptionSection(BuildContext context) {
    final subscriptionService = Provider.of<SubscriptionService>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '💳 Subscription',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (subscriptionService.isPremium)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.amber, Colors.orange]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Premium Active',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Plan: ${subscriptionService.currentPlanId?.toUpperCase()}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => subscriptionService.cancelSubscription(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subscriptionService.plans.length,
              itemBuilder: (context, index) {
                final plan = subscriptionService.plans[index];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: plan.isPopular
                        ? Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Column(
                    children: [
                      if (plan.isPopular)
                        Text(
                          'BEST VALUE',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      Text(
                        plan.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '${plan.currency}${plan.price}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => subscriptionService.subscribe(plan.id),
                        child: const Text('Select'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildNotificationSection(BuildContext context) {
    final notifService = Provider.of<SmartNotificationService>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '🔔 Smart Alerts',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () =>
                  notifService.generatePersonalizedAlert('Action Movies'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (notifService.notifications.isEmpty)
          const Text(
            'No new alerts. Tap refresh to simulate.',
            style: TextStyle(color: Colors.grey),
          )
        else
          Column(
            children: notifService.notifications
                .map(
                  (n) => Card(
                    color: Theme.of(context).colorScheme.surface,
                    child: ListTile(
                      leading: const Icon(
                        Icons.movie_filter,
                        color: Colors.blue,
                      ),
                      title: Text(n.title),
                      subtitle: Text(n.body),
                      trailing: n.isRead
                          ? null
                          : const CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.red,
                            ),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildSocialSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '👥 Social Community',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildFeatureTile(
          context,
          Icons.hub,
          'Social Hub (Feed & Friends)',
          'New',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SocialHubScreen()),
          ),
        ),
        _buildFeatureTile(
          context,
          Icons.live_tv,
          'Live Watch Party',
          'Demo',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WatchPartyLiveScreen()),
          ),
        ),
        _buildFeatureTile(
          context,
          Icons.comment,
          'Discussion & Comments',
          'Active',
          () {
            // Mock opening a content detail with comments
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Open a movie to see comments!')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildUpcomingFeatures(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🚀 Roadmap & Beta',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildFeatureTile(
          context,
          Icons.music_note,
          'Soundtrack Discovery',
          'Beta',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SoundtrackFinderScreen()),
          ),
        ),
        _buildFeatureTile(
          context,
          Icons.group_add,
          'Watch Parties',
          'Alpha',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SharedWatchlistScreen()),
          ),
        ),
        _buildFeatureTile(
          context,
          Icons.video_call,
          'Creator Studio',
          'Alpha',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatorStudioScreen()),
          ),
        ),
        _buildFeatureTile(
          context,
          Icons.play_circle_filled,
          'Trailer Feed',
          'Beta',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TrailerFeedScreen()),
          ),
        ),
        _buildFeatureTile(
          context,
          Icons.movie_filter,
          'Behind the Scenes',
          'New',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BonusContentScreen()),
          ),
        ),
        _buildFeatureTile(
          context,
          Icons.view_in_ar,
          'VR Theater Mode',
          'Beta',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const VRTheaterScreen()),
          ),
        ),
        const SizedBox(height: 12),
        Consumer<SmartDownloadService>(
          builder: (context, service, _) {
            return SwitchListTile(
              title: const Text(
                'Smart Downloads',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Auto-download next episode when on Wi-Fi'),
              value: service.isEnabled,
              secondary: const Icon(Icons.download_for_offline),
              onChanged: (val) => service.toggleSmartDownloads(val),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeatureTile(
    BuildContext context,
    IconData icon,
    String title,
    String status,
    VoidCallback? onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
      trailing: Chip(
        label: Text(status, style: const TextStyle(fontSize: 10)),
        backgroundColor: status == 'Coming Soon'
            ? Colors.grey.withValues(alpha: 0.2)
            : Theme.of(context).primaryColor.withValues(alpha: 0.2),
      ),
    );
  }
}
