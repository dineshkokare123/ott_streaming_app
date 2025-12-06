import 'package:flutter/foundation.dart';

enum NotificationType {
  newRelease,
  recommendation,
  watchlistAlert,
  subscription,
  social,
  system,
}

class SmartNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final NotificationType type;
  final String? imageUrl;
  final String? actionUrl;
  final Map<String, dynamic>? payload;
  bool isRead;

  SmartNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    this.imageUrl,
    this.actionUrl,
    this.payload,
    this.isRead = false,
  });
}

class SmartNotificationService extends ChangeNotifier {
  final List<SmartNotification> _notifications = [];

  List<SmartNotification> get notifications =>
      List.unmodifiable(_notifications);

  List<SmartNotification> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  int get unreadCount => unreadNotifications.length;

  // Mock checking for "Smart" notifications
  Future<void> checkForUpdates() async {
    // In a real app, this would check backend for personalized alerts
    // For demo, we'll simulate a random intelligent notification
    await Future.delayed(const Duration(milliseconds: 500));

    // Example: "Inception is now available in 4K" if user likes Sci-Fi
    // logic based on analytics would trigger this
  }

  void addNotification(SmartNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  // Generate a Personalized Notification based on user behavior (Mock)
  void generatePersonalizedAlert(String userTopGenre) {
    final notification = SmartNotification(
      id: DateTime.now().toString(),
      title: 'New in $userTopGenre',
      body:
          'Since you love $userTopGenre, check out "The Matrix Resurrections"!',
      timestamp: DateTime.now(),
      type: NotificationType.recommendation,
      imageUrl:
          'https://image.tmdb.org/t/p/w500/8c4a8kE7PizaGQQnditMmI1xbRp.jpg', // Matrix poster
    );
    addNotification(notification);
  }
}
