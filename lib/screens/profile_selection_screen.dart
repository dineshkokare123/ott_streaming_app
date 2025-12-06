import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../providers/profile_provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_profile.dart';
import '../constants/app_colors.dart';
import '../widgets/glass_widgets.dart';
import 'home_screen.dart';
import 'manage_profiles_screen.dart';

class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Gradient for Glass Effect
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.5, -0.5),
                radius: 1.5,
                colors: [
                  AppColors.primary.withValues(alpha: 0.3),
                  AppColors.background,
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.8, 0.8),
                radius: 1.2,
                colors: [
                  Colors.purple.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Content
          Consumer2<ProfileProvider, AuthProvider>(
            builder: (context, profileProvider, authProvider, _) {
              final profiles = profileProvider.profiles;

              return SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Title
                    const Text(
                      'Who\'s Watching?',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Profiles Grid
                    Expanded(
                      child: profiles.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            )
                          : ResponsiveBuilder(
                              builder: (context, sizingInformation) {
                                // Determine grid parameters based on device type
                                int crossAxisCount;
                                double horizontalPadding;

                                if (sizingInformation.deviceScreenType ==
                                    DeviceScreenType.desktop) {
                                  crossAxisCount = 4;
                                  horizontalPadding = 80;
                                } else if (sizingInformation.deviceScreenType ==
                                    DeviceScreenType.tablet) {
                                  crossAxisCount = 3;
                                  horizontalPadding = 60;
                                } else {
                                  // Mobile
                                  crossAxisCount = 2;
                                  horizontalPadding = 40;
                                }

                                return GridView.builder(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPadding,
                                  ),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        mainAxisSpacing: 24,
                                        crossAxisSpacing: 24,
                                        childAspectRatio: 0.85,
                                      ),
                                  itemCount:
                                      profiles.length + 1, // +1 for Add Profile
                                  itemBuilder: (context, index) {
                                    if (index == profiles.length) {
                                      // Add Profile Card
                                      return _buildAddProfileCard(
                                        context,
                                        profileProvider,
                                        authProvider,
                                      );
                                    }

                                    final profile = profiles[index];
                                    return _buildProfileCard(
                                      context,
                                      profile,
                                      profileProvider,
                                    );
                                  },
                                );
                              },
                            ),
                    ),

                    // Manage Profiles Button
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: GlassButton(
                        text: 'Manage Profiles',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ManageProfilesScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    UserProfile profile,
    ProfileProvider provider,
  ) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // Determine sizes based on device type
        double avatarSize;
        double fontSize;
        double nameSize;

        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          avatarSize = 140;
          fontSize = 70;
          nameSize = 18;
        } else if (sizingInformation.deviceScreenType ==
            DeviceScreenType.tablet) {
          avatarSize = 120;
          fontSize = 60;
          nameSize = 16;
        } else {
          // Mobile
          avatarSize = 100;
          fontSize = 50;
          nameSize = 14;
        }

        return InkWell(
          onTap: () {
            provider.switchProfile(profile);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar
                Flexible(
                  child: GlassContainer(
                    width: avatarSize,
                    height: avatarSize,
                    blur: 20,
                    opacity: 0.2,
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: Text(
                        profile.avatarUrl,
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Name
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      profile.name,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: nameSize,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                if (profile.isKidsProfile) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'KIDS',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddProfileCard(
    BuildContext context,
    ProfileProvider profileProvider,
    AuthProvider authProvider,
  ) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // Determine sizes based on device type
        double avatarSize;
        double iconSize;
        double textSize;

        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          avatarSize = 140;
          iconSize = 56;
          textSize = 18;
        } else if (sizingInformation.deviceScreenType ==
            DeviceScreenType.tablet) {
          avatarSize = 120;
          iconSize = 48;
          textSize = 16;
        } else {
          // Mobile
          avatarSize = 100;
          iconSize = 40;
          textSize = 14;
        }

        return InkWell(
          onTap: () {
            _showAddProfileDialog(context, profileProvider, authProvider);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.textSecondary.withValues(alpha: 0.3),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      size: iconSize,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'Add Profile',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: textSize,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddProfileDialog(
    BuildContext context,
    ProfileProvider profileProvider,
    AuthProvider authProvider,
  ) {
    final nameController = TextEditingController();
    String selectedAvatar = ProfileAvatar.random().url;
    bool isKidsProfile = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppColors.backgroundLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Create Profile',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name Field
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Avatar Selection
                const Text(
                  'Choose Avatar',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Builder(
                  builder: (context) {
                    final dialogWidth = MediaQuery.of(context).size.width;
                    final containerWidth = (dialogWidth * 0.7).clamp(
                      250.0,
                      350.0,
                    );

                    return SizedBox(
                      height: 200,
                      width: containerWidth,
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: ProfileAvatar.avatars.map((avatar) {
                            final isSelected = selectedAvatar == avatar.url;

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedAvatar = avatar.url;
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    avatar.url,
                                    style: const TextStyle(fontSize: 36),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Kids Profile Toggle
                InkWell(
                  onTap: () {
                    setState(() {
                      isKidsProfile = !isKidsProfile;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isKidsProfile
                              ? AppColors.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: isKidsProfile
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: isKidsProfile
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Kids Profile',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            ),
            // Create Button
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a name'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                try {
                  await profileProvider.createProfile(
                    userId: authProvider.currentUser!.id,
                    name: nameController.text.trim(),
                    avatarUrl: selectedAvatar,
                    isKidsProfile: isKidsProfile,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile created!'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE50914), // Netflix red
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Create',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
