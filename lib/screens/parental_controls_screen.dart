import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';

class ParentalControlsScreen extends StatefulWidget {
  const ParentalControlsScreen({super.key});

  @override
  State<ParentalControlsScreen> createState() => _ParentalControlsScreenState();
}

class _ParentalControlsScreenState extends State<ParentalControlsScreen> {
  bool _isEnabled = false;
  String _ageRating = 'PG-13';
  bool _requirePinForAdult = true;
  bool _hideAdultContent = false;
  String? _pin;

  final List<String> _ageRatings = [
    'G', // General Audiences
    'PG', // Parental Guidance
    'PG-13', // Parents Strongly Cautioned
    'R', // Restricted
    'NC-17', // Adults Only
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isEnabled = prefs.getBool('parental_controls_enabled') ?? false;
      _ageRating = prefs.getString('age_rating') ?? 'PG-13';
      _requirePinForAdult = prefs.getBool('require_pin') ?? true;
      _hideAdultContent = prefs.getBool('hide_adult_content') ?? false;
      _pin = prefs.getString('parental_pin');
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('parental_controls_enabled', _isEnabled);
    await prefs.setString('age_rating', _ageRating);
    await prefs.setBool('require_pin', _requirePinForAdult);
    await prefs.setBool('hide_adult_content', _hideAdultContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Parental Controls',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Enable/Disable Toggle
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  _isEnabled ? Icons.lock : Icons.lock_open,
                  color: _isEnabled
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Parental Controls',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isEnabled ? 'Enabled' : 'Disabled',
                        style: TextStyle(
                          color: _isEnabled
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isEnabled,
                  onChanged: (value) async {
                    if (value && _pin == null) {
                      // Set up PIN first
                      await _setupPin();
                    } else if (!value && _pin != null) {
                      // Verify PIN before disabling
                      final verified = await _verifyPin();
                      if (verified) {
                        setState(() => _isEnabled = false);
                        await _saveSettings();
                      }
                    } else {
                      setState(() => _isEnabled = value);
                      await _saveSettings();
                    }
                  },
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
          ),

          if (_isEnabled) ...[
            const SizedBox(height: 24),

            // Age Rating Selection
            const Text(
              'Maximum Age Rating',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: _ageRatings.map((rating) {
                  final isSelected = _ageRating == rating;
                  return InkWell(
                    onTap: () {
                      setState(() => _ageRating = rating);
                      _saveSettings();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rating,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getRatingDescription(rating),
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Additional Settings
            const Text(
              'Additional Settings',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _buildSettingTile(
              icon: Icons.pin,
              title: 'Require PIN for Adult Content',
              subtitle: 'Ask for PIN when accessing restricted content',
              value: _requirePinForAdult,
              onChanged: (value) {
                setState(() => _requirePinForAdult = value);
                _saveSettings();
              },
            ),

            const SizedBox(height: 12),

            _buildSettingTile(
              icon: Icons.visibility_off,
              title: 'Hide Adult Content',
              subtitle: 'Completely hide content above age rating',
              value: _hideAdultContent,
              onChanged: (value) {
                setState(() => _hideAdultContent = value);
                _saveSettings();
              },
            ),

            const SizedBox(height: 24),

            // Change PIN Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _changePin,
                icon: const Icon(Icons.lock_reset),
                label: const Text('Change PIN'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.textSecondary),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Parental controls help you manage what content can be watched. Set an age rating limit and require a PIN for restricted content.',
                      style: TextStyle(
                        color: AppColors.textPrimary.withValues(alpha: 0.8),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        value: value,
        activeThumbColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }

  String _getRatingDescription(String rating) {
    switch (rating) {
      case 'G':
        return 'General Audiences - All ages admitted';
      case 'PG':
        return 'Parental Guidance Suggested';
      case 'PG-13':
        return 'Parents Strongly Cautioned - May be inappropriate for children under 13';
      case 'R':
        return 'Restricted - Under 17 requires accompanying parent or adult guardian';
      case 'NC-17':
        return 'Adults Only - No one 17 and under admitted';
      default:
        return '';
    }
  }

  Future<void> _setupPin() async {
    final pin = await _showPinDialog('Set up PIN', 'Enter a 4-digit PIN');
    if (pin != null) {
      final confirm = await _showPinDialog('Confirm PIN', 'Re-enter your PIN');
      if (confirm == pin) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('parental_pin', pin);
        setState(() {
          _pin = pin;
          _isEnabled = true;
        });
        await _saveSettings();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('PIN set successfully'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('PINs do not match'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<bool> _verifyPin() async {
    final pin = await _showPinDialog('Verify PIN', 'Enter your PIN');
    return pin == _pin;
  }

  Future<void> _changePin() async {
    final verified = await _verifyPin();
    if (verified) {
      await _setupPin();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect PIN'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<String?> _showPinDialog(String title, String hint) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text(
          title,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 4,
          obscureText: true,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textTertiary),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.length == 4) {
                Navigator.pop(context, controller.text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
