import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/download_provider.dart';
import '../providers/auth_provider.dart';
import '../models/download_item.dart';
import '../constants/app_colors.dart';
import '../constants/api_constants.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Downloads',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Consumer2<DownloadProvider, AuthProvider>(
        builder: (context, downloadProvider, authProvider, _) {
          final downloads = downloadProvider.downloads;

          if (downloads.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.download_outlined,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No downloads yet',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Download content to watch offline',
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: downloads.length,
            itemBuilder: (context, index) {
              final download = downloads[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildDownloadCard(
                  context,
                  download,
                  downloadProvider,
                  authProvider.currentUser?.id ?? '',
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDownloadCard(
    BuildContext context,
    DownloadItem download,
    DownloadProvider downloadProvider,
    String userId,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Poster
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: download.posterPath != null
                    ? CachedNetworkImage(
                        imageUrl: ApiConstants.getPosterUrl(
                          download.posterPath!,
                        ),
                        width: 80,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.background,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.background,
                          child: const Icon(
                            Icons.movie,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : Container(
                        width: 80,
                        height: 120,
                        color: AppColors.background,
                        child: const Icon(
                          Icons.movie,
                          color: AppColors.textSecondary,
                        ),
                      ),
              ),

              // Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        download.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              download.quality,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            download.fileSizeFormatted,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildStatusWidget(download, downloadProvider, userId),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Progress bar (only for downloading/paused)
          if (download.status == DownloadStatus.downloading ||
              download.status == DownloadStatus.paused)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        download.progressPercent,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        download.status == DownloadStatus.downloading
                            ? 'Downloading...'
                            : 'Paused',
                        style: TextStyle(
                          color: download.status == DownloadStatus.downloading
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: download.progress,
                      backgroundColor: AppColors.background,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusWidget(
    DownloadItem download,
    DownloadProvider downloadProvider,
    String userId,
  ) {
    switch (download.status) {
      case DownloadStatus.completed:
        return Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 16),
            const SizedBox(width: 4),
            const Text(
              'Downloaded',
              style: TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              color: AppColors.error,
              onPressed: () {
                downloadProvider.deleteDownload(userId, download.id);
              },
            ),
          ],
        );

      case DownloadStatus.downloading:
        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.pause, size: 20),
              color: AppColors.primary,
              onPressed: () {
                downloadProvider.pauseDownload(download.id);
              },
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              color: AppColors.error,
              onPressed: () {
                downloadProvider.cancelDownload(userId, download.id);
              },
            ),
          ],
        );

      case DownloadStatus.paused:
        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow, size: 20),
              color: AppColors.primary,
              onPressed: () {
                downloadProvider.resumeDownload(download.id);
              },
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              color: AppColors.error,
              onPressed: () {
                downloadProvider.cancelDownload(userId, download.id);
              },
            ),
          ],
        );

      case DownloadStatus.failed:
        return const Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 16),
            SizedBox(width: 4),
            Text(
              'Failed',
              style: TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
