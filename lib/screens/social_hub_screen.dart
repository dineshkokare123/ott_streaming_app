import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/social_service.dart';
import '../constants/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class SocialHubScreen extends StatelessWidget {
  const SocialHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Community'),
          backgroundColor: Colors.transparent,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Activity Feed'),
              Tab(text: 'Friends'),
            ],
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: const TabBarView(children: [_ActivityFeedTab(), _FriendsTab()]),
      ),
    );
  }
}

class _ActivityFeedTab extends StatelessWidget {
  const _ActivityFeedTab();

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<SocialService>(context);

    if (service.feed.isEmpty) {
      return const Center(
        child: Text('No activity yet.', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: service.feed.length,
      itemBuilder: (context, index) {
        final item = service.feed[index];
        return Card(
          color: AppColors.backgroundLight,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(item.user.avatarUrl),
                  radius: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                              text: item.user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' ${item.action} '),
                            TextSpan(
                              text: item.contentTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeago.format(item.timestamp),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      if (item.contentImageUrl != null) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.contentImageUrl!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FriendsTab extends StatelessWidget {
  const _FriendsTab();

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<SocialService>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Quick add friend mock
          // In real app, open search
          Provider.of<SocialService>(
            context,
            listen: false,
          ).addFriend('New Friend ${DateTime.now().second}');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.person_add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: service.friends.length,
        itemBuilder: (context, index) {
          final friend = service.friends[index];
          return ListTile(
            leading: Stack(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(friend.avatarUrl)),
                if (friend.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              friend.name,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              friend.isOnline ? 'Online' : 'Offline',
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.blue),
              onPressed: () {},
            ),
          );
        },
      ),
    );
  }
}
