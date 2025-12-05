import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                          : GridView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 24,
                                    crossAxisSpacing: 24,
                                    childAspectRatio: 0.8,
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
    return InkWell(
      onTap: () {
        provider.switchProfile(profile);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar
          GlassContainer(
            width: 120,
            height: 120,
            blur: 20,
            opacity: 0.2,
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: Text(
                profile.avatarUrl,
                style: const TextStyle(fontSize: 64),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            profile.name,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          if (profile.isKidsProfile) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'KIDS',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddProfileCard(
    BuildContext context,
    ProfileProvider profileProvider,
    AuthProvider authProvider,
  ) {
    return InkWell(
      onTap: () {
        _showAddProfileDialog(context, profileProvider, authProvider);
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: const Icon(
              Icons.add,
              size: 48,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Add Profile',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
          title: const Text(
            'Create Profile',
            style: TextStyle(color: AppColors.textPrimary),
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
                    labelText: 'Name',
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Avatar Selection
                const Text(
                  'Choose Avatar',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    itemCount: ProfileAvatar.avatars.length,
                    itemBuilder: (context, index) {
                      final avatar = ProfileAvatar.avatars[index];
                      final isSelected = selectedAvatar == avatar.url;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedAvatar = avatar.url;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              avatar.url,
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Kids Profile Toggle
                Row(
                  children: [
                    Checkbox(
                      value: isKidsProfile,
                      onChanged: (value) {
                        setState(() {
                          isKidsProfile = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                    ),
                    const Text(
                      'Kids Profile',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ],
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
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
