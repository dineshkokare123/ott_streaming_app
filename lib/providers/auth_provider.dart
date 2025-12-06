import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _init();
  }

  // Initialize and listen to auth state changes
  void _init() {
    _authService.authStateChanges.listen((User? user) async {
      if (user != null) {
        // User is signed in, fetch user data
        _currentUser = await _authService.getUserData(user.uid);
      } else {
        // User is signed out
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  // Sign in
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authService.signInWithEmail(email, password);
      _isLoading = false;
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register(
    String email,
    String password,
    String displayName,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authService.registerWithEmail(
        email,
        password,
        displayName,
      );
      _isLoading = false;
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authService.signInWithGoogle();
      _isLoading = false;
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Update user profile
  Future<void> updateProfile(AppUser updatedUser) async {
    try {
      await _authService.updateUserProfile(updatedUser);
      _currentUser = updatedUser;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating profile: $e');
      rethrow;
    }
  }

  // Toggle watchlist
  Future<void> toggleWatchlist(int contentId) async {
    debugPrint('toggleWatchlist called for contentId: $contentId');

    if (_currentUser == null) {
      debugPrint('toggleWatchlist: No current user');
      return;
    }

    debugPrint('Current user: ${_currentUser!.email}');
    final isInWatchlist = _currentUser!.watchlist.contains(contentId);
    debugPrint('Is in watchlist: $isInWatchlist');

    try {
      if (isInWatchlist) {
        debugPrint('Removing from watchlist...');
        await _authService.removeFromWatchlist(_currentUser!.id, contentId);
        _currentUser = _currentUser!.copyWith(
          watchlist: List.from(_currentUser!.watchlist)..remove(contentId),
        );
        debugPrint('Removed successfully');
      } else {
        debugPrint('Adding to watchlist...');
        await _authService.addToWatchlist(_currentUser!.id, contentId);
        _currentUser = _currentUser!.copyWith(
          watchlist: List.from(_currentUser!.watchlist)..add(contentId),
        );
        debugPrint('Added successfully');
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling watchlist: $e');
      rethrow;
    }
  }

  // Toggle favorites
  Future<void> toggleFavorites(int contentId) async {
    debugPrint('toggleFavorites called for contentId: $contentId');

    if (_currentUser == null) {
      debugPrint('toggleFavorites: No current user');
      return;
    }

    debugPrint('Current user: ${_currentUser!.email}');
    final isInFavorites = _currentUser!.favorites.contains(contentId);
    debugPrint('Is in favorites: $isInFavorites');

    try {
      if (isInFavorites) {
        debugPrint('Removing from favorites...');
        await _authService.removeFromFavorites(_currentUser!.id, contentId);
        _currentUser = _currentUser!.copyWith(
          favorites: List.from(_currentUser!.favorites)..remove(contentId),
        );
        debugPrint('Removed successfully');
      } else {
        debugPrint('Adding to favorites...');
        await _authService.addToFavorites(_currentUser!.id, contentId);
        _currentUser = _currentUser!.copyWith(
          favorites: List.from(_currentUser!.favorites)..add(contentId),
        );
        debugPrint('Added successfully');
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling favorites: $e');
      rethrow;
    }
  }

  // Check if content is in watchlist
  bool isInWatchlist(int contentId) {
    return _currentUser?.watchlist.contains(contentId) ?? false;
  }

  // Check if content is in favorites
  bool isInFavorites(int contentId) {
    return _currentUser?.favorites.contains(contentId) ?? false;
  }
}
