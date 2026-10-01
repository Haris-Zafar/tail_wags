import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/fullscreen_image_viewer.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDoc = ref.watch(currentUserDocProvider).value;
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final borderColor = AppColors.borderOf(context);

    final username = (userDoc?.username.isNotEmpty ?? false)
        ? userDoc!.username
        : 'Morgan mill';
    final email = (userDoc?.email.isNotEmpty ?? false)
        ? userDoc!.email
        : 'example23@gmail.com';

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title
                Text(
                  'Setting',
                  style: AppTextStyles.headline.copyWith(
                    color: textPrimary,
                    fontSize: 24,
                  ),
                ),

                const SizedBox(height: 24),

                // User Profile Header Section
                Center(
                  child: Column(
                    children: [
                      // Avatar with Fullscreen Viewer
                      GestureDetector(
                        onTap: () {
                          final img = userDoc?.profileImageProvider ??
                              const AssetImage('assets/images/person.png');
                          FullscreenImageViewer.show(
                            context,
                            img,
                            heroTag: 'profile_avatar_settings',
                          );
                        },
                        child: Hero(
                          tag: 'profile_avatar_settings',
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: userDoc?.profileImageProvider ??
                                const AssetImage('assets/images/person.png'),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Username
                      Text(
                        username,
                        style: AppTextStyles.title.copyWith(
                          color: textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Email
                      Text(
                        email,
                        style: AppTextStyles.body.copyWith(
                          color: textSecondary,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Edit Profile Button
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size(140, 42),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => context.pushNamed(RoutePaths.editUsername),
                        icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.white),
                        label: Text(
                          'Edit Profile',
                          style: AppTextStyles.button.copyWith(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Settings Tiles List
                _buildTile(
                  context,
                  icon: Icons.notifications_none_outlined,
                  title: 'Notifications',
                  onTap: () => context.pushNamed(RoutePaths.notifications),
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                ),

                _buildTile(
                  context,
                  icon: Icons.description_outlined,
                  title: 'Privicy Policy',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy Policy clicked')),
                    );
                  },
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                ),

                _buildTile(
                  context,
                  icon: Icons.description_outlined,
                  title: 'Term & Conditions',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Terms & Conditions clicked')),
                    );
                  },
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                ),

                _buildTile(
                  context,
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Help & Support clicked')),
                    );
                  },
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                ),

                _buildTile(
                  context,
                  icon: Icons.share_outlined,
                  title: 'Invite Your Friend',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invite Your Friend clicked')),
                    );
                  },
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                ),

                // Dark Mode Switch Tile
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: borderColor, width: 0.8)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.dark_mode_outlined, size: 22, color: textPrimary),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Dark Mode',
                          style: AppTextStyles.body.copyWith(
                            color: textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Switch(
                        value: isDark,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) {
                          ref.read(themeModeProvider.notifier).toggleTheme(val);
                        },
                      ),
                    ],
                  ),
                ),

                // Logout Tile
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: InkWell(
                    onTap: () async {
                      final authService = ref.read(firebaseAuthServiceProvider);
                      await authService.signOut();
                      if (!context.mounted) return;
                      context.goNamed(RoutePaths.login);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.logout, size: 22, color: AppColors.primary),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Logout',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 20, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color borderColor,
    required Color textPrimary,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor, width: 0.8)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, size: 22, color: textPrimary),
        title: Text(
          title,
          style: AppTextStyles.body.copyWith(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
