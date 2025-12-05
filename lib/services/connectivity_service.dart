import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Service to monitor network connectivity status
class ConnectivityService with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  bool _isOnline = true;
  bool _hasWifi = false;
  bool _hasMobile = false;

  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;
  bool get hasWifi => _hasWifi;
  bool get hasMobile => _hasMobile;

  ConnectivityService() {
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  /// Initialize connectivity status
  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      _isOnline = false;
      notifyListeners();
    }
  }

  /// Update connection status based on connectivity result
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    _hasWifi = results.contains(ConnectivityResult.wifi);
    _hasMobile = results.contains(ConnectivityResult.mobile);
    _isOnline =
        _hasWifi || _hasMobile || results.contains(ConnectivityResult.ethernet);

    debugPrint(
      'Connectivity changed: Online=$_isOnline, WiFi=$_hasWifi, Mobile=$_hasMobile',
    );
    notifyListeners();
  }

  /// Check if device is connected to internet
  Future<bool> checkConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.ethernet);
    } catch (e) {
      debugPrint('Error checking connection: $e');
      return false;
    }
  }

  /// Get connection type as string
  String getConnectionType() {
    if (_hasWifi) return 'WiFi';
    if (_hasMobile) return 'Mobile Data';
    if (_isOnline) return 'Connected';
    return 'Offline';
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
