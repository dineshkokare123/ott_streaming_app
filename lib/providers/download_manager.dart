import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/content.dart';

enum DownloadStatus { notDownloaded, downloading, downloaded, failed }

class DownloadItem {
  final Content content;
  DownloadStatus status;
  double progress;
  String? localPath;
  DateTime? downloadedAt;

  DownloadItem({
    required this.content,
    this.status = DownloadStatus.notDownloaded,
    this.progress = 0.0,
    this.localPath,
    this.downloadedAt,
  });

  Map<String, dynamic> toJson() => {
    'contentId': content.id,
    'title': content.title,
    'posterPath': content.posterPath,
    'mediaType': content.mediaType,
    'status': status.index,
    'progress': progress,
    'localPath': localPath,
    'downloadedAt': downloadedAt?.toIso8601String(),
  };
}

class DownloadManager extends ChangeNotifier {
  final Map<int, DownloadItem> _downloads = {};

  List<DownloadItem> get downloads => _downloads.values.toList();
  List<DownloadItem> get downloadedItems => _downloads.values
      .where((d) => d.status == DownloadStatus.downloaded)
      .toList();
  List<DownloadItem> get downloadingItems => _downloads.values
      .where((d) => d.status == DownloadStatus.downloading)
      .toList();

  bool isDownloaded(int contentId) {
    return _downloads[contentId]?.status == DownloadStatus.downloaded;
  }

  bool isDownloading(int contentId) {
    return _downloads[contentId]?.status == DownloadStatus.downloading;
  }

  DownloadStatus getStatus(int contentId) {
    return _downloads[contentId]?.status ?? DownloadStatus.notDownloaded;
  }

  double getProgress(int contentId) {
    return _downloads[contentId]?.progress ?? 0.0;
  }

  // Simulated download (in real app, use dio or http for actual downloads)
  Future<void> downloadContent(Content content) async {
    if (_downloads[content.id]?.status == DownloadStatus.downloading) {
      return; // Already downloading
    }

    final downloadItem = DownloadItem(
      content: content,
      status: DownloadStatus.downloading,
    );
    _downloads[content.id] = downloadItem;
    notifyListeners();

    try {
      // Simulate download progress
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 500));
        downloadItem.progress = i / 100;
        notifyListeners();
      }

      // Get app directory
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/downloads/${content.id}.mp4';

      // In real app, save actual video file here
      // For simulation, just mark as downloaded
      downloadItem.status = DownloadStatus.downloaded;
      downloadItem.localPath = path;
      downloadItem.downloadedAt = DateTime.now();
      downloadItem.progress = 1.0;

      notifyListeners();
      debugPrint('Downloaded: ${content.title}');
    } catch (e) {
      downloadItem.status = DownloadStatus.failed;
      notifyListeners();
      debugPrint('Download failed: $e');
    }
  }

  // Delete downloaded content
  Future<void> deleteDownload(int contentId) async {
    final downloadItem = _downloads[contentId];
    if (downloadItem == null) return;

    try {
      // In real app, delete the actual file
      if (downloadItem.localPath != null) {
        final file = File(downloadItem.localPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }

      _downloads.remove(contentId);
      notifyListeners();
      debugPrint('Deleted download: ${downloadItem.content.title}');
    } catch (e) {
      debugPrint('Error deleting download: $e');
    }
  }

  // Cancel ongoing download
  void cancelDownload(int contentId) {
    final downloadItem = _downloads[contentId];
    if (downloadItem?.status == DownloadStatus.downloading) {
      _downloads.remove(contentId);
      notifyListeners();
    }
  }

  // Get total downloaded size (simulated)
  String getTotalDownloadedSize() {
    final count = downloadedItems.length;
    final estimatedSize = count * 1.5; // Assume 1.5GB per movie
    return '${estimatedSize.toStringAsFixed(1)} GB';
  }

  // Clear all downloads
  Future<void> clearAllDownloads() async {
    for (var item in downloadedItems) {
      await deleteDownload(item.content.id);
    }
  }
}
