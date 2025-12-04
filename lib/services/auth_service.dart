import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<AppUser?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        return await getUserData(credential.user!.uid);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Register with email and password
  Future<AppUser?> registerWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update display name
        await credential.user!.updateDisplayName(displayName);

        // Create user document in Firestore
        final appUser = AppUser(
          id: credential.user!.uid,
          email: email,
          displayName: displayName,
          photoUrl: null,
          watchlist: [],
          favorites: [],
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(appUser.toJson());

        return appUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get user data from Firestore
  Future<AppUser?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return AppUser.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(AppUser user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      throw Exception('Failed to update profile');
    }
  }

  // Add to watchlist
  Future<void> addToWatchlist(String userId, int contentId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'watchlist': FieldValue.arrayUnion([contentId]),
      });
    } catch (e) {
      debugPrint('Error adding to watchlist: $e');
      throw Exception('Failed to add to watchlist');
    }
  }

  // Remove from watchlist
  Future<void> removeFromWatchlist(String userId, int contentId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'watchlist': FieldValue.arrayRemove([contentId]),
      });
    } catch (e) {
      debugPrint('Error removing from watchlist: $e');
      throw Exception('Failed to remove from watchlist');
    }
  }

  // Add to favorites
  Future<void> addToFavorites(String userId, int contentId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayUnion([contentId]),
      });
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
      throw Exception('Failed to add to favorites');
    }
  }

  // Remove from favorites
  Future<void> removeFromFavorites(String userId, int contentId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayRemove([contentId]),
      });
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
      throw Exception('Failed to remove from favorites');
    }
  }

  // Handle auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
