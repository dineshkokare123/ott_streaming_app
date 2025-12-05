import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/notification.dart';

class NotificationProvider with ChangeNotifier {
  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  String? _error;

  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get unread count
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  // Get notifications by type
  List<AppNotification> getNotificationsByType(String type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  NotificationProvider() {
    loadNotifications();
    _generateSampleNotifications();
  }

  // Load notifications from local storage
  Future<void> loadNotifications() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getString('notifications');

      if (notificationsJson != null) {
        final List<dynamic> decoded = json.decode(notificationsJson);
        _notifications = decoded
            .map((item) => AppNotification.fromJson(item))
            .toList();
      }

      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load notifications: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save notifications to local storage
  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = json.encode(
        _notifications.map((n) => n.toJson()).toList(),
      );
      await prefs.setString('notifications', notificationsJson);
    } catch (e) {
      debugPrint('Failed to save notifications: $e');
    }
  }

  // Add a new notification
  Future<void> addNotification(AppNotification notification) async {
    _notifications.insert(0, notification);
    await _saveNotifications();
    notifyListeners();
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      await _saveNotifications();
      notifyListeners();
    }
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    _notifications = _notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    await _saveNotifications();
    notifyListeners();
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    _notifications.removeWhere((n) => n.id == notificationId);
    await _saveNotifications();
    notifyListeners();
  }

  // Clear all notifications
  Future<void> clearAll() async {
    _notifications.clear();
    await _saveNotifications();
    notifyListeners();
  }

  // Generate sample notifications for demo
  void _generateSampleNotifications() {
    if (_notifications.isEmpty) {
      final sampleNotifications = [
        AppNotification(
          id: '1',
          title: 'New Movies Added! 🎬',
          message:
              'Check out the latest blockbusters now available on StreamVibe',
          type: 'new_content',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          imageUrl: 'https://image.tmdb.org/t/p/w500/path_to_image.jpg',
        ),
        AppNotification(
          id: '2',
          title: 'Continue Watching',
          message: 'You left off at 45:23 in "Spirited Away"',
          type: 'reminder',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: false,
        ),
        AppNotification(
          id: '3',
          title: 'App Update Available',
          message: 'Version 2.0 is now available with exciting new features!',
          type: 'update',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
        ),
        AppNotification(
          id: '4',
          title: 'Special Offer! 🎁',
          message: 'Get 50% off on premium subscription this weekend only',
          type: 'promo',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          isRead: false,
        ),
        AppNotification(
          id: '5',
          title: 'Top Rated This Week',
          message: 'The Shawshank Redemption is trending #1 this week',
          type: 'new_content',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          isRead: true,
        ),
        AppNotification(
          id: '6',
          title: 'New Season Alert! 📺',
          message: 'Your favorite show just released a new season',
          type: 'new_content',
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
          isRead: false,
        ),
      ];

      _notifications = sampleNotifications;
      _saveNotifications();
      notifyListeners();
    }
  }

  // Refresh notifications (can be connected to Firebase Cloud Messaging)
  Future<void> refresh() async {
    await loadNotifications();
  }
}
