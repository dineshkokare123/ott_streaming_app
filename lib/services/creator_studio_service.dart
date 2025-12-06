import 'package:flutter/foundation.dart';

class UserCreation {
  final String id;
  final String title;
  final String videoUrl;
  final String description;
  final int likes;
  final DateTime createdAt;

  UserCreation({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.description,
    this.likes = 0,
    required this.createdAt,
  });
}

class CreatorStudioService extends ChangeNotifier {
  final List<UserCreation> _myCreations = [];

  List<UserCreation> get myCreations => List.unmodifiable(_myCreations);

  Future<void> uploadCreation(String title, String description) async {
    // Simulate upload process
    await Future.delayed(const Duration(seconds: 2));

    final newCreation = UserCreation(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      videoUrl: 'https://placeholder.com/video.mp4', // Mock URL
      createdAt: DateTime.now(),
    );

    _myCreations.insert(0, newCreation);
    notifyListeners();
  }

  Future<void> deleteCreation(String id) async {
    _myCreations.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}
