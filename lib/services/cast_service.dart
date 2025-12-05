import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service to handle casting to TV (Chromecast, AirPlay, etc.)
class CastService with ChangeNotifier {
  static const MethodChannel _channel = MethodChannel('com.streamvibe/cast');

  bool _isCasting = false;
  String? _connectedDevice;
  List<String> _availableDevices = [];

  bool get isCasting => _isCasting;
  String? get connectedDevice => _connectedDevice;
  List<String> get availableDevices => _availableDevices;
  bool get hasAvailableDevices => _availableDevices.isNotEmpty;

  CastService() {
    _initializeCast();
  }

  /// Initialize cast functionality
  Future<void> _initializeCast() async {
    try {
      await _channel.invokeMethod('initialize');
      await scanForDevices();
    } catch (e) {
      debugPrint('Error initializing cast: $e');
    }
  }

  /// Scan for available cast devices
  Future<void> scanForDevices() async {
    try {
      final devices = await _channel.invokeMethod<List>('scanDevices');
      _availableDevices = devices?.cast<String>() ?? [];
      notifyListeners();
    } catch (e) {
      debugPrint('Error scanning for devices: $e');
      _availableDevices = [];
    }
  }

  /// Connect to a cast device
  Future<bool> connectToDevice(String deviceId) async {
    try {
      final success = await _channel.invokeMethod<bool>('connect', {
        'deviceId': deviceId,
      });

      if (success == true) {
        _isCasting = true;
        _connectedDevice = deviceId;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error connecting to device: $e');
      return false;
    }
  }

  /// Disconnect from cast device
  Future<void> disconnect() async {
    try {
      await _channel.invokeMethod('disconnect');
      _isCasting = false;
      _connectedDevice = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error disconnecting: $e');
    }
  }

  /// Cast video to connected device
  Future<bool> castVideo({
    required String videoUrl,
    required String title,
    String? posterUrl,
    int? position,
  }) async {
    if (!_isCasting) {
      debugPrint('Not connected to any cast device');
      return false;
    }

    try {
      final success = await _channel.invokeMethod<bool>('castVideo', {
        'videoUrl': videoUrl,
        'title': title,
        'posterUrl': posterUrl,
        'position': position ?? 0,
      });
      return success == true;
    } catch (e) {
      debugPrint('Error casting video: $e');
      return false;
    }
  }

  /// Control playback on cast device
  Future<void> play() async {
    try {
      await _channel.invokeMethod('play');
    } catch (e) {
      debugPrint('Error playing: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _channel.invokeMethod('pause');
    } catch (e) {
      debugPrint('Error pausing: $e');
    }
  }

  Future<void> seek(int position) async {
    try {
      await _channel.invokeMethod('seek', {'position': position});
    } catch (e) {
      debugPrint('Error seeking: $e');
    }
  }

  /// Check if Chromecast is available (Android)
  Future<bool> isChromecastAvailable() async {
    try {
      final available = await _channel.invokeMethod<bool>(
        'isChromecastAvailable',
      );
      return available ?? false;
    } catch (e) {
      debugPrint('Chromecast not available: $e');
      return false;
    }
  }

  /// Check if AirPlay is available (iOS)
  Future<bool> isAirPlayAvailable() async {
    try {
      final available = await _channel.invokeMethod<bool>('isAirPlayAvailable');
      return available ?? false;
    } catch (e) {
      debugPrint('AirPlay not available: $e');
      return false;
    }
  }
}
