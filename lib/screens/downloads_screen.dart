import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/download_manager.dart';
import '../constants/app_colors.dart';
import '../widgets/glass_container.dart';
import 'content_detail_screen.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Downloads',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<DownloadManager>(
            builder: (context, downloadManager, _) {
              if (downloadManager.downloadedItems.isEmpty) {
                return const SizedBox.shrink();
              }
              return PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
                color: AppColors.backgroundLight,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text(
                      'Clear All Downloads',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    onTap: () async {
                      await downloadManager.clearAllDownloads();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('All downloads cleared'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<DownloadManager>(
        builder: (context, downloadManager, _) {
          final downloads = downloadManager.downloads;

          if (downloads.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.download_outlined,
                    size: 100,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No Downloads Yet',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Download movies and shows to watch offline',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Storage info
              if (downloadManager.downloadedItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GlassContainer(
                    padding: const EdgeInsets.all(16),
                    borderRadius: BorderRadius.circular(12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.storage,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Storage Used',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              downloadManager.getTotalDownloadedSize(),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          '${downloadManager.downloadedItems.length} items',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Downloads list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: downloads.length,
                  itemBuilder: (context, index) {
                    final download = downloads[index];
                    return _DownloadItem(download: download);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DownloadItem extends StatelessWidget {
  final DownloadItem download;

  const _DownloadItem({required this.download});

  @override
  Widget build(BuildContext context) {
    final downloadManager = Provider.of<DownloadManager>(
      context,
      listen: false,
    );

    return GestureDetector(
      onTap: () {
        if (download.status == DownloadStatus.downloaded) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ContentDetailScreen(content: download.content),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: GlassContainer(
          padding: const EdgeInsets.all(12),
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              // Poster
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 120,
                  color: AppColors.backgroundLight,
                  child: const Icon(
                    Icons.movie,
                    color: AppColors.textSecondary,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      download.content.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    _buildStatusWidget(),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Action button
              _buildActionButton(context, downloadManager),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusWidget() {
    switch (download.status) {
      case DownloadStatus.downloading:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${(download.progress * 100).toInt()}%',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: download.progress,
                backgroundColor: AppColors.backgroundLight,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                minHeight: 4,
              ),
            ),
          ],
        );
      case DownloadStatus.downloaded:
        return Text(
          'Downloaded • ${download.downloadedAt != null ? _formatDate(download.downloadedAt!) : ""}',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        );
      case DownloadStatus.failed:
        return const Text(
          'Download failed',
          style: TextStyle(color: AppColors.error, fontSize: 12),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActionButton(
    BuildContext context,
    DownloadManager downloadManager,
  ) {
    switch (download.status) {
      case DownloadStatus.downloading:
        return IconButton(
          icon: const Icon(Icons.close, color: AppColors.error),
          onPressed: () {
            downloadManager.cancelDownload(download.content.id);
          },
        );
      case DownloadStatus.downloaded:
        return IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.error),
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: AppColors.backgroundLight,
                title: const Text(
                  'Delete Download?',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                content: Text(
                  'Are you sure you want to delete "${download.content.title}"?',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              await downloadManager.deleteDownload(download.content.id);
            }
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
