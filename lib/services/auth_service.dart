import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../models/user.dart';

class AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

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
        await credential.user!.updateDisplayName(displayName);

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

  // Sign in with Google
  Future<AppUser?> signInWithGoogle() async {
    try {
      // FIX 2: Correct method name is signIn() (ensure correct casing).
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      // FIX 3: Added 'await' to googleUser.authentication since it returns a Future.
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        // FIX 4: Use 'accessToken' as it is the standard getter.
        // If this still fails, your version might use 'idToken' only.
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final existingUser = await getUserData(userCredential.user!.uid);

        if (existingUser != null) {
          return existingUser;
        }

        final appUser = AppUser(
          id: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          displayName: userCredential.user!.displayName ?? 'User',
          photoUrl: userCredential.user!.photoURL,
          watchlist: [],
          favorites: [],
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(appUser.toJson());

        return appUser;
      }
      return null;
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      throw 'Failed to sign in with Google. Please try again.';
    }
  }

  // Sign in with Facebook
  Future<AppUser?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status == LoginStatus.cancelled) {
        return null;
      }

      if (loginResult.status == LoginStatus.failed) {
        throw 'Facebook sign-in failed: ${loginResult.message}';
      }

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

      final userCredential = await _auth.signInWithCredential(
        facebookAuthCredential,
      );

      if (userCredential.user != null) {
        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email,picture.width(200)",
        );

        final existingUser = await getUserData(userCredential.user!.uid);

        if (existingUser != null) {
          return existingUser;
        }

        final appUser = AppUser(
          id: userCredential.user!.uid,
          email: userData['email'] ?? userCredential.user!.email ?? '',
          displayName:
              userData['name'] ?? userCredential.user!.displayName ?? 'User',
          photoUrl:
              userData['picture']?['data']?['url'] ??
              userCredential.user!.photoURL,
          watchlist: [],
          favorites: [],
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(appUser.toJson());

        return appUser;
      }
      return null;
    } catch (e) {
      debugPrint('Facebook Sign-In Error: $e');
      throw 'Failed to sign in with Facebook. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await FacebookAuth.instance.logOut();
      await _auth.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

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

  Future<void> updateUserProfile(AppUser user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      throw Exception('Failed to update profile');
    }
  }

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

  // Forgot Password implementation
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

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
