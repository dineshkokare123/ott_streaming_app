import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/connectivity_service.dart';
import '../constants/app_colors.dart';

/// Widget to show offline mode banner
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, connectivity, _) {
        if (connectivity.isOnline) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.wifi_off, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'You\'re offline. Only downloaded content is available.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Widget to show connection type indicator
class ConnectionIndicator extends StatelessWidget {
  const ConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, connectivity, _) {
        if (connectivity.isOffline) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: connectivity.hasWifi
                ? Colors.green.withValues(alpha: 0.2)
                : Colors.orange.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: connectivity.hasWifi ? Colors.green : Colors.orange,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                connectivity.hasWifi ? Icons.wifi : Icons.signal_cellular_alt,
                size: 14,
                color: connectivity.hasWifi ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 4),
              Text(
                connectivity.getConnectionType(),
                style: TextStyle(
                  fontSize: 12,
                  color: connectivity.hasWifi ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Dialog to show when trying to access online content while offline
class OfflineDialog extends StatelessWidget {
  final String? message;

  const OfflineDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.backgroundLight,
      title: const Row(
        children: [
          Icon(Icons.wifi_off, color: AppColors.error),
          SizedBox(width: 12),
          Text(
            'No Internet Connection',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ],
      ),
      content: Text(
        message ??
            'This content requires an internet connection. Please check your connection and try again, or download content for offline viewing.',
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }

  static void show(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      builder: (context) => OfflineDialog(message: message),
    );
  }
}
