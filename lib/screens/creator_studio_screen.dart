import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/creator_studio_service.dart';
import '../constants/app_colors.dart';

class CreatorStudioScreen extends StatelessWidget {
  const CreatorStudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<CreatorStudioService>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUploadDialog(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.video_call),
        label: const Text('Create'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.background,
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Creator Studio'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade900, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.video_library,
                        size: 48,
                        color: Colors.white54,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '0 Subscribers',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (service.myCreations.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'Start creating content!',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final creation = service.myCreations[index];
                return Card(
                  color: AppColors.backgroundLight,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      color: Colors.black54,
                      child: const Icon(Icons.play_circle, color: Colors.white),
                    ),
                    title: Text(
                      creation.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${creation.likes} likes',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => service.deleteCreation(creation.id),
                    ),
                  ),
                );
              }, childCount: service.myCreations.length),
            ),
        ],
      ),
    );
  }

  void _showUploadDialog(BuildContext context) {
    // Basic mock upload dialog
    final titleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: const Text(
          'Upload Short',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: titleCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Title',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: const Text('Upload'),
            onPressed: () {
              Provider.of<CreatorStudioService>(
                context,
                listen: false,
              ).uploadCreation(titleCtrl.text, 'No description');
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}
