import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/download_item.dart';
import '../models/content.dart';

class DownloadProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<DownloadItem> _downloads = [];
  final Map<String, Timer> _downloadTimers = {};

  List<DownloadItem> get downloads => _downloads;

  List<DownloadItem> get activeDownloads =>
      _downloads.where((d) => d.status == DownloadStatus.downloading).toList();

  List<DownloadItem> get completedDownloads =>
      _downloads.where((d) => d.status == DownloadStatus.completed).toList();

  List<DownloadItem> get queuedDownloads =>
      _downloads.where((d) => d.status == DownloadStatus.queued).toList();

  bool isDownloaded(String contentId) {
    return _downloads.any(
      (d) => d.contentId == contentId && d.status == DownloadStatus.completed,
    );
  }

  bool isDownloading(String contentId) {
    return _downloads.any(
      (d) =>
          d.contentId == contentId &&
          (d.status == DownloadStatus.downloading ||
              d.status == DownloadStatus.queued),
    );
  }

  DownloadItem? getDownload(String contentId) {
    try {
      return _downloads.firstWhere((d) => d.contentId == contentId);
    } catch (e) {
      return null;
    }
  }

  Future<void> loadDownloads(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('downloads')
          .get();

      _downloads.clear();
      for (var doc in snapshot.docs) {
        final download = DownloadItem.fromJson(doc.data());
        _downloads.add(download);

        // Resume downloading if it was in progress
        if (download.status == DownloadStatus.downloading) {
          _startDownloadSimulation(download.id);
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading downloads: $e');
    }
  }

  Future<void> startDownload(
    String userId,
    Content content, {
    String quality = 'HD',
  }) async {
    // Check if already downloading or downloaded
    if (isDownloading(content.id.toString()) ||
        isDownloaded(content.id.toString())) {
      return;
    }

    final downloadId = DateTime.now().millisecondsSinceEpoch.toString();

    // Simulate file size based on quality
    int fileSize;
    switch (quality) {
      case 'SD':
        fileSize = Random().nextInt(500) + 300; // 300-800 MB
        break;
      case 'FHD':
        fileSize = Random().nextInt(2000) + 1500; // 1.5-3.5 GB
        break;
      default: // HD
        fileSize = Random().nextInt(1000) + 800; // 800-1800 MB
    }

    final download = DownloadItem(
      id: downloadId,
      contentId: content.id.toString(),
      title: content.title,
      posterPath: content.posterPath,
      mediaType: content.mediaType,
      startedAt: DateTime.now(),
      fileSize: fileSize,
      quality: quality,
      status: DownloadStatus.downloading,
    );

    _downloads.insert(0, download);
    notifyListeners();

    // Save to Firestore
    await _saveDownload(userId, download);

    // Start download simulation
    _startDownloadSimulation(downloadId);
  }

  void _startDownloadSimulation(String downloadId) {
    // Simulate download progress
    _downloadTimers[downloadId] = Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) {
        final index = _downloads.indexWhere((d) => d.id == downloadId);
        if (index == -1) {
          timer.cancel();
          _downloadTimers.remove(downloadId);
          return;
        }

        final download = _downloads[index];

        if (download.status != DownloadStatus.downloading) {
          timer.cancel();
          _downloadTimers.remove(downloadId);
          return;
        }

        // Increment progress (simulate varying download speeds)
        final increment =
            (Random().nextDouble() * 0.05) + 0.02; // 2-7% per tick
        final newProgress = (download.progress + increment).clamp(0.0, 1.0);

        if (newProgress >= 1.0) {
          // Download complete
          _downloads[index] = download.copyWith(
            progress: 1.0,
            status: DownloadStatus.completed,
            completedAt: DateTime.now(),
          );
          timer.cancel();
          _downloadTimers.remove(downloadId);

          // Save completion to Firestore
          _updateDownloadProgress(download.id, 1.0, DownloadStatus.completed);
        } else {
          _downloads[index] = download.copyWith(progress: newProgress);

          // Periodically save progress
          if ((newProgress * 100).toInt() % 10 == 0) {
            _updateDownloadProgress(download.id, newProgress, null);
          }
        }

        notifyListeners();
      },
    );
  }

  Future<void> pauseDownload(String downloadId) async {
    final index = _downloads.indexWhere((d) => d.id == downloadId);
    if (index == -1) return;

    _downloadTimers[downloadId]?.cancel();
    _downloadTimers.remove(downloadId);

    _downloads[index] = _downloads[index].copyWith(
      status: DownloadStatus.paused,
    );
    notifyListeners();

    await _updateDownloadProgress(
      downloadId,
      _downloads[index].progress,
      DownloadStatus.paused,
    );
  }

  Future<void> resumeDownload(String downloadId) async {
    final index = _downloads.indexWhere((d) => d.id == downloadId);
    if (index == -1) return;

    _downloads[index] = _downloads[index].copyWith(
      status: DownloadStatus.downloading,
    );
    notifyListeners();

    await _updateDownloadProgress(
      downloadId,
      _downloads[index].progress,
      DownloadStatus.downloading,
    );

    _startDownloadSimulation(downloadId);
  }

  Future<void> cancelDownload(String userId, String downloadId) async {
    final index = _downloads.indexWhere((d) => d.id == downloadId);
    if (index == -1) return;

    _downloadTimers[downloadId]?.cancel();
    _downloadTimers.remove(downloadId);

    // Remove from list
    _downloads.removeAt(index);
    notifyListeners();

    // Remove from Firestore
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('downloads')
          .doc(downloadId)
          .delete();
    } catch (e) {
      debugPrint('Error deleting download: $e');
    }
  }

  Future<void> deleteDownload(String userId, String downloadId) async {
    await cancelDownload(userId, downloadId);
  }

  Future<void> _saveDownload(String userId, DownloadItem download) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('downloads')
          .doc(download.id)
          .set(download.toJson());
    } catch (e) {
      debugPrint('Error saving download: $e');
    }
  }

  Future<void> _updateDownloadProgress(
    String downloadId,
    double progress,
    DownloadStatus? status,
  ) async {
    // This would update Firestore in a real app
    // For now, we'll skip to avoid too many writes
  }

  @override
  void dispose() {
    for (var timer in _downloadTimers.values) {
      timer.cancel();
    }
    _downloadTimers.clear();
    super.dispose();
  }
}
