import 'package:flutter/foundation.dart';

class SocialUser {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isOnline;

  SocialUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.isOnline = false,
  });
}

class ActivityItem {
  final String id;
  final SocialUser user;
  final String action; // "watched", "liked", "commented"
  final String contentTitle;
  final String? contentImageUrl;
  final DateTime timestamp;

  ActivityItem({
    required this.id,
    required this.user,
    required this.action,
    required this.contentTitle,
    this.contentImageUrl,
    required this.timestamp,
  });
}

class Comment {
  final String id;
  final SocialUser user;
  final String text;
  final DateTime timestamp;
  final int likes;

  Comment({
    required this.id,
    required this.user,
    required this.text,
    required this.timestamp,
    this.likes = 0,
  });
}

class SocialService extends ChangeNotifier {
  // Mock Friends
  final List<SocialUser> _friends = [
    SocialUser(
      id: 'u1',
      name: 'Alice',
      avatarUrl: 'https://i.pravatar.cc/150?u=u1',
      isOnline: true,
    ),
    SocialUser(
      id: 'u2',
      name: 'Bob',
      avatarUrl: 'https://i.pravatar.cc/150?u=u2',
      isOnline: false,
    ),
    SocialUser(
      id: 'u3',
      name: 'Charlie',
      avatarUrl: 'https://i.pravatar.cc/150?u=u3',
      isOnline: true,
    ),
  ];

  // Mock Activity Feed
  final List<ActivityItem> _feed = [
    ActivityItem(
      id: 'a1',
      user: SocialUser(
        id: 'u1',
        name: 'Alice',
        avatarUrl: 'https://i.pravatar.cc/150?u=u1',
      ),
      action: 'watched',
      contentTitle: 'Stranger Things',
      contentImageUrl:
          'https://image.tmdb.org/t/p/w500/9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    ActivityItem(
      id: 'a2',
      user: SocialUser(
        id: 'u3',
        name: 'Charlie',
        avatarUrl: 'https://i.pravatar.cc/150?u=u3',
      ),
      action: 'liked',
      contentTitle: 'Inception',
      contentImageUrl:
          'https://image.tmdb.org/t/p/w500/8c4a8kE7PizaGQQnditMmI1xbRp.jpg',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  // Mock Comments (Content ID -> List of Comments)
  final Map<String, List<Comment>> _comments = {
    'demo_movie': [
      Comment(
        id: 'c1',
        user: SocialUser(
          id: 'u2',
          name: 'Bob',
          avatarUrl: 'https://i.pravatar.cc/150?u=u2',
        ),
        text: 'This scene was mind-blowing! 🤯',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        likes: 12,
      ),
    ],
  };

  List<SocialUser> get friends => List.unmodifiable(_friends);
  List<ActivityItem> get feed => List.unmodifiable(_feed);

  List<Comment> getComments(String contentId) {
    return _comments[contentId] ?? [];
  }

  void addComment(String contentId, String text) {
    final comment = Comment(
      id: DateTime.now().toString(),
      user: SocialUser(
        id: 'me',
        name: 'You',
        avatarUrl: 'https://i.pravatar.cc/150?u=me',
        isOnline: true,
      ),
      text: text,
      timestamp: DateTime.now(),
    );

    if (!_comments.containsKey(contentId)) {
      _comments[contentId] = [];
    }
    _comments[contentId]!.insert(0, comment);

    // Add to activity feed
    _feed.insert(
      0,
      ActivityItem(
        id: DateTime.now().toString(),
        user: comment.user,
        action: 'commented on',
        contentTitle: 'this movie',
        timestamp: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  void addFriend(String name) {
    _friends.add(
      SocialUser(
        id: DateTime.now().toString(),
        name: name,
        avatarUrl: 'https://i.pravatar.cc/150?u=${name.length}',
      ),
    );
    notifyListeners();
  }
}
