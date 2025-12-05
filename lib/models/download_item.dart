class DownloadItem {
  final String id;
  final String contentId;
  final String title;
  final String? posterPath;
  final String mediaType;
  final double progress; // 0.0 to 1.0
  final DownloadStatus status;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int fileSize; // in MB
  final String quality; // SD, HD, FHD

  DownloadItem({
    required this.id,
    required this.contentId,
    required this.title,
    this.posterPath,
    required this.mediaType,
    this.progress = 0.0,
    this.status = DownloadStatus.queued,
    required this.startedAt,
    this.completedAt,
    this.fileSize = 0,
    this.quality = 'HD',
  });

  DownloadItem copyWith({
    String? id,
    String? contentId,
    String? title,
    String? posterPath,
    String? mediaType,
    double? progress,
    DownloadStatus? status,
    DateTime? startedAt,
    DateTime? completedAt,
    int? fileSize,
    String? quality,
  }) {
    return DownloadItem(
      id: id ?? this.id,
      contentId: contentId ?? this.contentId,
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
      mediaType: mediaType ?? this.mediaType,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      fileSize: fileSize ?? this.fileSize,
      quality: quality ?? this.quality,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contentId': contentId,
      'title': title,
      'posterPath': posterPath,
      'mediaType': mediaType,
      'progress': progress,
      'status': status.toString(),
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'fileSize': fileSize,
      'quality': quality,
    };
  }

  factory DownloadItem.fromJson(Map<String, dynamic> json) {
    return DownloadItem(
      id: json['id'] as String,
      contentId: json['contentId'] as String,
      title: json['title'] as String,
      posterPath: json['posterPath'] as String?,
      mediaType: json['mediaType'] as String,
      progress: (json['progress'] as num).toDouble(),
      status: DownloadStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => DownloadStatus.queued,
      ),
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      fileSize: json['fileSize'] as int,
      quality: json['quality'] as String? ?? 'HD',
    );
  }

  String get progressPercent => '${(progress * 100).toStringAsFixed(0)}%';

  String get fileSizeFormatted {
    if (fileSize < 1024) {
      return '${fileSize}MB';
    } else {
      return '${(fileSize / 1024).toStringAsFixed(1)}GB';
    }
  }
}

enum DownloadStatus {
  queued,
  downloading,
  paused,
  completed,
  failed,
  cancelled,
}
