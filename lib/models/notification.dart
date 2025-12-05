class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type; // 'new_content', 'reminder', 'update', 'promo'
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
    this.actionUrl,
    this.metadata,
  });

  // Create a copy with updated fields
  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    DateTime? timestamp,
    bool? isRead,
    String? imageUrl,
    String? actionUrl,
    Map<String, dynamic>? metadata,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'imageUrl': imageUrl,
      'actionUrl': actionUrl,
      'metadata': metadata,
    };
  }

  // Create from JSON
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
      actionUrl: json['actionUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  // Get icon based on notification type
  String getIconEmoji() {
    switch (type) {
      case 'new_content':
        return '🎬';
      case 'reminder':
        return '⏰';
      case 'update':
        return '🔔';
      case 'promo':
        return '🎁';
      default:
        return '📢';
    }
  }

  // Get time ago string
  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${difference.inDays ~/ 7}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
