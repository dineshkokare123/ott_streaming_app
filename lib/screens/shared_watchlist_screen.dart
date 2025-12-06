import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/social_watching_service.dart';
import '../constants/app_colors.dart';

class SharedWatchlistScreen extends StatelessWidget {
  const SharedWatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<SocialWatchingService>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Collab Watchlists'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateDialog(context),
          ),
        ],
      ),
      body: service.sharedLists.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.group_add, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No shared lists yet',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _showCreateDialog(context),
                    child: const Text('Create One'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: service.sharedLists.length,
              itemBuilder: (context, index) {
                final list = service.sharedLists[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.list)),
                  title: Text(
                    list.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '${list.memberIds.length} members • ${list.contentIds.length} items',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    // Navigate to details
                  },
                );
              },
            ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: const Text(
          'New Shared List',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'List Name (e.g. Movie Night)',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: const Text('Create'),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<SocialWatchingService>(
                  context,
                  listen: false,
                ).createSharedList(controller.text);
                Navigator.pop(ctx);
              }
            },
          ),
        ],
      ),
    );
  }
}
