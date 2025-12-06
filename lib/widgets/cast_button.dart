import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cast_service.dart';
import '../constants/app_colors.dart';

/// Cast button widget to show cast icon and handle casting
class CastButton extends StatelessWidget {
  final Color? iconColor;
  final double? iconSize;

  const CastButton({super.key, this.iconColor, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Consumer<CastService>(
      builder: (context, castService, _) {
        return IconButton(
          icon: Icon(
            castService.isCasting ? Icons.cast_connected : Icons.cast,
            color: castService.isCasting
                ? AppColors.primary
                : (iconColor ?? AppColors.textPrimary),
            size: iconSize ?? 24,
          ),
          onPressed: () => _showCastDialog(context, castService),
          tooltip: castService.isCasting
              ? 'Connected to ${castService.connectedDevice}'
              : 'Cast to TV',
        );
      },
    );
  }

  void _showCastDialog(BuildContext context, CastService castService) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CastDeviceSheet(castService: castService),
    );
  }
}

/// Bottom sheet to show available cast devices
class CastDeviceSheet extends StatefulWidget {
  final CastService castService;

  const CastDeviceSheet({super.key, required this.castService});

  @override
  State<CastDeviceSheet> createState() => _CastDeviceSheetState();
}

class _CastDeviceSheetState extends State<CastDeviceSheet> {
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _scanForDevices();
  }

  Future<void> _scanForDevices() async {
    setState(() => _isScanning = true);
    await widget.castService.scanForDevices();
    if (mounted) {
      setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cast to TV',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Connected Device (if any)
          if (widget.castService.isCasting) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.cast_connected,
                    color: AppColors.primary,
                    size: 30,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Connected to',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          widget.castService.connectedDevice ?? 'Unknown',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await widget.castService.disconnect();
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Disconnect',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Scanning indicator
          if (_isScanning) ...[
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Scanning for devices...',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],

          // Available Devices
          if (!_isScanning) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Available Devices',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: _scanForDevices,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Scan'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.castService.availableDevices.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                child: const Column(
                  children: [
                    Icon(
                      Icons.devices_other,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No devices found',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Make sure your TV or Chromecast is on the same network',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...widget.castService.availableDevices.map((device) {
                final isConnected =
                    widget.castService.connectedDevice == device;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      isConnected ? Icons.tv : Icons.tv_outlined,
                      color: isConnected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    title: Text(
                      device,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: isConnected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isConnected
                        ? const Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                          )
                        : null,
                    onTap: isConnected
                        ? null
                        : () async {
                            final success = await widget.castService
                                .connectToDevice(device);
                            if (context.mounted) {
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Connected to $device'),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to connect'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          },
                  ),
                );
              }),
          ],

          const SizedBox(height: 20),

          // Info text
          const Text(
            'Note: Cast functionality requires platform-specific implementation',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
