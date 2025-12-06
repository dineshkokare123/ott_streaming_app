import 'package:flutter/foundation.dart';

class SharedWatchlist {
  final String id;
  final String name;
  final String ownerId;
  final List<String> memberIds;
  final List<String> contentIds;

  SharedWatchlist({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.memberIds,
    required this.contentIds,
  });
}

class SocialWatchingService extends ChangeNotifier {
  final List<SharedWatchlist> _sharedLists = [];

  List<SharedWatchlist> get sharedLists => List.unmodifiable(_sharedLists);

  Future<void> createSharedList(String name) async {
    await Future.delayed(const Duration(seconds: 1));
    final newList = SharedWatchlist(
      id: DateTime.now().toString(),
      name: name,
      ownerId: 'current_user',
      memberIds: ['current_user'],
      contentIds: [],
    );
    _sharedLists.add(newList);
    notifyListeners();
  }

  Future<void> inviteFriend(String listId, String email) async {
    // Simulate sending invite
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Invite sent to $email for list $listId');
  }

  Future<void> addToSharedList(String listId, String contentId) async {
    final index = _sharedLists.indexWhere((l) => l.id == listId);
    if (index != -1) {
      final list = _sharedLists[index];
      // Create new list to ensure immutability triggers (if needed) or just mutate for now
      list.contentIds.add(contentId);
      notifyListeners();
    }
  }
}
