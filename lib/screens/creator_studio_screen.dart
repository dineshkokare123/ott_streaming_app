import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
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
        onPressed: () => _showCreateOptions(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Create'),
      ),
      body: RefreshIndicator(
        onRefresh: () => service.fetchLiveStreams(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.background,
              expandedHeight: 200,
              floating: false,
              pinned: true,
              actions: [
                if (service.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => service.fetchLiveStreams(),
                  ),
              ],
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
                          Icons.radar, // Changed to radar/live icon
                          size: 48,
                          color: Colors.redAccent,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Creator Dashboard',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (service.myCreations.isEmpty && !service.isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No content yet. Go Live or Upload!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final creation = service.myCreations[index];
                  final isLive = creation.description == "Live Stream";
                  return Card(
                    color: AppColors.backgroundLight,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 60,
                        height: 40,
                        color: Colors.black54,
                        child: isLive
                            ? const Icon(Icons.sensors, color: Colors.red)
                            : const Icon(
                                Icons.play_circle,
                                color: Colors.white,
                              ),
                      ),
                      title: Text(
                        creation.title,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        isLive
                            ? 'LIVE • ${creation.createdAt.toString().substring(0, 16)}'
                            : '${creation.likes} likes',
                        style: TextStyle(
                          color: isLive ? Colors.redAccent : Colors.grey,
                        ),
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
      ),
    );
  }

  void _showCreateOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundLight,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.video_call, color: Colors.redAccent),
            title: const Text('Go Live', style: TextStyle(color: Colors.white)),
            subtitle: const Text(
              'Start specific live stream',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.pop(ctx);
              _showGoLiveDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file, color: AppColors.primary),
            title: const Text(
              'Upload Video',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Upload a short or video',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.pop(ctx);
              _showUploadDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showGoLiveDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: const Row(
          children: [
            Icon(Icons.sensors, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Go Live', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Stream Title',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.black26,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Check console logs for RTMP Key after creation.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Start Stream'),
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                Provider.of<CreatorStudioService>(
                  context,
                  listen: false,
                ).createLiveStream(titleCtrl.text);
              }
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  void _showUploadDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    String? selectedPath;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.backgroundLight,
            title: const Text(
              'Upload Video',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black26,
                  ),
                ),
                const SizedBox(height: 16),
                if (selectedPath != null)
                  Text(
                    'Selected: ${selectedPath!.split('/').last}',
                    style: const TextStyle(color: Colors.green, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.video);
                    if (result != null) {
                      setState(() {
                        selectedPath = result.files.single.path;
                      });
                    }
                  },
                  icon: const Icon(Icons.video_library),
                  label: const Text('Select Video File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(ctx),
              ),
              ElevatedButton(
                child: const Text('Upload'),
                onPressed: () {
                  if (titleCtrl.text.isNotEmpty) {
                    Provider.of<CreatorStudioService>(
                      context,
                      listen: false,
                    ).uploadCreation(
                      titleCtrl.text,
                      'Uploaded via Creator Studio',
                      filePath: selectedPath,
                    );
                    Navigator.pop(ctx);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Uploading "${titleCtrl.text}"... Check console.',
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
