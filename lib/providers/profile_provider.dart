import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserProfile> _profiles = [];
  UserProfile? _currentProfile;
  bool _isLoading = false;

  List<UserProfile> get profiles => _profiles;
  UserProfile? get currentProfile => _currentProfile;
  bool get isLoading => _isLoading;
  bool get hasProfiles => _profiles.isNotEmpty;

  Future<void> loadProfiles(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('profiles')
          .orderBy('createdAt')
          .get();

      _profiles = snapshot.docs
          .map((doc) => UserProfile.fromJson(doc.data()))
          .toList();

      // Auto-select first profile if none selected
      if (_currentProfile == null && _profiles.isNotEmpty) {
        _currentProfile = _profiles.first;
      }
    } catch (e) {
      debugPrint('Error loading profiles: $e');
      _profiles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createProfile({
    required String userId,
    required String name,
    required String avatarUrl,
    bool isKidsProfile = false,
  }) async {
    try {
      // Limit to 5 profiles per account
      if (_profiles.length >= 5) {
        throw Exception('Maximum 5 profiles allowed per account');
      }

      final profileId = DateTime.now().millisecondsSinceEpoch.toString();

      final profile = UserProfile(
        id: profileId,
        userId: userId,
        name: name,
        avatarUrl: avatarUrl,
        isKidsProfile: isKidsProfile,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('profiles')
          .doc(profileId)
          .set(profile.toJson());

      _profiles.add(profile);

      // Auto-select if first profile
      if (_profiles.length == 1) {
        _currentProfile = profile;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error creating profile: $e');
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String userId,
    required String profileId,
    String? name,
    String? avatarUrl,
    bool? isKidsProfile,
  }) async {
    try {
      final index = _profiles.indexWhere((p) => p.id == profileId);
      if (index == -1) return;

      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;
      if (isKidsProfile != null) updates['isKidsProfile'] = isKidsProfile;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('profiles')
          .doc(profileId)
          .update(updates);

      _profiles[index] = _profiles[index].copyWith(
        name: name,
        avatarUrl: avatarUrl,
        isKidsProfile: isKidsProfile,
      );

      if (_currentProfile?.id == profileId) {
        _currentProfile = _profiles[index];
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating profile: $e');
      rethrow;
    }
  }

  Future<void> deleteProfile(String userId, String profileId) async {
    try {
      // Don't allow deleting if it's the only profile
      if (_profiles.length <= 1) {
        throw Exception('Cannot delete the last profile');
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('profiles')
          .doc(profileId)
          .delete();

      _profiles.removeWhere((p) => p.id == profileId);

      // Switch to another profile if current was deleted
      if (_currentProfile?.id == profileId) {
        _currentProfile = _profiles.isNotEmpty ? _profiles.first : null;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting profile: $e');
      rethrow;
    }
  }

  void switchProfile(UserProfile profile) {
    _currentProfile = profile;
    notifyListeners();
  }

  Future<void> addToWatchlist(
    String userId,
    String profileId,
    int contentId,
  ) async {
    try {
      final index = _profiles.indexWhere((p) => p.id == profileId);
      if (index == -1) return;

      final newWatchlist = List<int>.from(_profiles[index].watchlist);
      if (!newWatchlist.contains(contentId)) {
        newWatchlist.add(contentId);

        await _firestore
            .collection('users')
            .doc(userId)
            .collection('profiles')
            .doc(profileId)
            .update({'watchlist': newWatchlist});

        _profiles[index] = _profiles[index].copyWith(watchlist: newWatchlist);

        if (_currentProfile?.id == profileId) {
          _currentProfile = _profiles[index];
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error adding to watchlist: $e');
    }
  }

  Future<void> removeFromWatchlist(
    String userId,
    String profileId,
    int contentId,
  ) async {
    try {
      final index = _profiles.indexWhere((p) => p.id == profileId);
      if (index == -1) return;

      final newWatchlist = List<int>.from(_profiles[index].watchlist);
      newWatchlist.remove(contentId);

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('profiles')
          .doc(profileId)
          .update({'watchlist': newWatchlist});

      _profiles[index] = _profiles[index].copyWith(watchlist: newWatchlist);

      if (_currentProfile?.id == profileId) {
        _currentProfile = _profiles[index];
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error removing from watchlist: $e');
    }
  }

  Future<void> addToFavorites(
    String userId,
    String profileId,
    int contentId,
  ) async {
    try {
      final index = _profiles.indexWhere((p) => p.id == profileId);
      if (index == -1) return;

      final newFavorites = List<int>.from(_profiles[index].favorites);
      if (!newFavorites.contains(contentId)) {
        newFavorites.add(contentId);

        await _firestore
            .collection('users')
            .doc(userId)
            .collection('profiles')
            .doc(profileId)
            .update({'favorites': newFavorites});

        _profiles[index] = _profiles[index].copyWith(favorites: newFavorites);

        if (_currentProfile?.id == profileId) {
          _currentProfile = _profiles[index];
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(
    String userId,
    String profileId,
    int contentId,
  ) async {
    try {
      final index = _profiles.indexWhere((p) => p.id == profileId);
      if (index == -1) return;

      final newFavorites = List<int>.from(_profiles[index].favorites);
      newFavorites.remove(contentId);

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('profiles')
          .doc(profileId)
          .update({'favorites': newFavorites});

      _profiles[index] = _profiles[index].copyWith(favorites: newFavorites);

      if (_currentProfile?.id == profileId) {
        _currentProfile = _profiles[index];
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
    }
  }

  bool isInWatchlist(int contentId) {
    return _currentProfile?.watchlist.contains(contentId) ?? false;
  }

  bool isInFavorites(int contentId) {
    return _currentProfile?.favorites.contains(contentId) ?? false;
  }

  void clearProfiles() {
    _profiles = [];
    _currentProfile = null;
    notifyListeners();
  }
}
