import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';
import '../models/user.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserProfile> _profiles = [];
  UserProfile? _currentProfile;
  bool _isLoading = false;

  List<UserProfile> get profiles => _profiles;
  UserProfile? get currentProfile => _currentProfile;
  bool get isLoading => _isLoading;
  bool get hasProfiles => _profiles.isNotEmpty;

  Future<void> loadProfiles(AppUser user) async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.id)
          .collection('profiles')
          .orderBy('createdAt')
          .get();

      _profiles = snapshot.docs
          .map((doc) => UserProfile.fromJson(doc.data()))
          .toList();

      // Self-heal: Create default profile if none exists
      if (_profiles.isEmpty) {
        final profileId = DateTime.now().millisecondsSinceEpoch.toString();
        final defaultProfile = UserProfile(
          id: profileId,
          userId: user.id,
          name: user.displayName,
          avatarUrl: user.photoUrl ?? '🚀',
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('profiles')
            .doc(profileId)
            .set(defaultProfile.toJson());

        _profiles.add(defaultProfile);
      }

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
      debugPrint(
        '🔵 Adding to watchlist: userId=$userId, profileId=$profileId, contentId=$contentId',
      );

      final index = _profiles.indexWhere((p) => p.id == profileId);
      if (index == -1) {
        debugPrint('❌ Profile not found in local list');
        return;
      }

      final newWatchlist = List<int>.from(_profiles[index].watchlist);
      if (!newWatchlist.contains(contentId)) {
        newWatchlist.add(contentId);

        debugPrint('🔵 Updating Firestore with watchlist: $newWatchlist');

        try {
          // Use set with merge instead of update to create document if it doesn't exist
          // Add timeout to prevent hanging
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('profiles')
              .doc(profileId)
              .set({'watchlist': newWatchlist}, SetOptions(merge: true))
              .timeout(
                const Duration(seconds: 10),
                onTimeout: () {
                  debugPrint(
                    '⏱️ Firestore operation timed out after 10 seconds',
                  );
                  throw TimeoutException('Firestore operation timed out');
                },
              );

          debugPrint('✅ Firestore updated successfully');
        } catch (firestoreError) {
          debugPrint('❌ Firestore error: $firestoreError');
          // Continue anyway to update local state
        }

        // Update local state regardless of Firestore success
        _profiles[index] = _profiles[index].copyWith(watchlist: newWatchlist);

        if (_currentProfile?.id == profileId) {
          _currentProfile = _profiles[index];
          debugPrint(
            '🔄 Updated currentProfile: ${_currentProfile?.name}, watchlist: ${_currentProfile?.watchlist}',
          );
        }

        debugPrint('📢 Calling notifyListeners() - UI should rebuild now');
        notifyListeners();
        debugPrint(
          '✅ Added to watchlist successfully - notifyListeners() called',
        );
      } else {
        debugPrint('⚠️ Content already in watchlist');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error adding to watchlist: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow; // Rethrow so UI can show error
    }
  }

  Future<void> removeFromWatchlist(
    String userId,
    String profileId,
    int contentId,
  ) async {
    try {
      debugPrint(
        '🔵 Removing from watchlist: userId=$userId, profileId=$profileId, contentId=$contentId',
      );

      final index = _profiles.indexWhere((p) => p.id == profileId);
      if (index == -1) {
        debugPrint('❌ Profile not found in local list');
        return;
      }

      final newWatchlist = List<int>.from(_profiles[index].watchlist);
      newWatchlist.remove(contentId);

      debugPrint('🔵 Updating Firestore with watchlist: $newWatchlist');

      try {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('profiles')
            .doc(profileId)
            .set({'watchlist': newWatchlist}, SetOptions(merge: true))
            .timeout(const Duration(seconds: 10));

        debugPrint('✅ Firestore updated successfully');
      } catch (firestoreError) {
        debugPrint('❌ Firestore error: $firestoreError');
      }

      _profiles[index] = _profiles[index].copyWith(watchlist: newWatchlist);

      if (_currentProfile?.id == profileId) {
        _currentProfile = _profiles[index];
      }

      debugPrint('📢 Calling notifyListeners()');
      notifyListeners();
      debugPrint('✅ Removed from watchlist successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error removing from watchlist: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> addToFavorites(
    String userId,
    String profileId,
    int contentId,
  ) async {
    try {
      debugPrint(
        '🔵 Adding to favorites: userId=$userId, profileId=$profileId, contentId=$contentId',
      );

      final index = _profiles.indexWhere((p) => p.id == profileId);
      if (index == -1) {
        debugPrint('❌ Profile not found in local list');
        return;
      }

      final newFavorites = List<int>.from(_profiles[index].favorites);
      if (!newFavorites.contains(contentId)) {
        newFavorites.add(contentId);

        debugPrint('🔵 Updating Firestore with favorites: $newFavorites');

        try {
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('profiles')
              .doc(profileId)
              .set({'favorites': newFavorites}, SetOptions(merge: true))
              .timeout(const Duration(seconds: 10));

          debugPrint('✅ Firestore updated successfully');
        } catch (firestoreError) {
          debugPrint('❌ Firestore error: $firestoreError');
        }

        _profiles[index] = _profiles[index].copyWith(favorites: newFavorites);

        if (_currentProfile?.id == profileId) {
          _currentProfile = _profiles[index];
        }

        debugPrint('📢 Calling notifyListeners()');
        notifyListeners();
        debugPrint('✅ Added to favorites successfully');
      } else {
        debugPrint('⚠️ Content already in favorites');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error adding to favorites: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> removeFromFavorites(
    String userId,
    String profileId,
    int contentId,
  ) async {
    try {
      debugPrint(
        '🔵 Removing from favorites: userId=$userId, profileId=$profileId, contentId=$contentId',
      );

      final index = _profiles.indexWhere((p) => p.id == profileId);
      if (index == -1) {
        debugPrint('❌ Profile not found in local list');
        return;
      }

      final newFavorites = List<int>.from(_profiles[index].favorites);
      newFavorites.remove(contentId);

      debugPrint('🔵 Updating Firestore with favorites: $newFavorites');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('profiles')
          .doc(profileId)
          .set({'favorites': newFavorites}, SetOptions(merge: true));

      debugPrint('✅ Firestore updated successfully');

      _profiles[index] = _profiles[index].copyWith(favorites: newFavorites);

      if (_currentProfile?.id == profileId) {
        _currentProfile = _profiles[index];
      }

      notifyListeners();
      debugPrint('✅ Removed from favorites successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error removing from favorites: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  bool isInWatchlist(int contentId) {
    final result = _currentProfile?.watchlist.contains(contentId) ?? false;
    debugPrint(
      '🔍 isInWatchlist($contentId): $result, currentProfile: ${_currentProfile?.name}, watchlist: ${_currentProfile?.watchlist}',
    );
    return result;
  }

  bool isInFavorites(int contentId) {
    final result = _currentProfile?.favorites.contains(contentId) ?? false;
    debugPrint(
      '🔍 isInFavorites($contentId): $result, currentProfile: ${_currentProfile?.name}, favorites: ${_currentProfile?.favorites}',
    );
    return result;
  }

  void clearProfiles() {
    _profiles = [];
    _currentProfile = null;
    notifyListeners();
  }
}
