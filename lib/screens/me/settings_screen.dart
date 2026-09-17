// lib/screens/me/settings_screen.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Settings', style: AppTypography.headingSmall),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.blue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Account section
          _SettingsSection(
            title: 'Account',
            children: [
              _SettingsTile(
                title: 'Profile',
                subtitle: 'Edit your profile information',
                icon: Icons.person_outline,
                onTap: () {},
              ),
              _SettingsTile(
                title: 'Security',
                subtitle: 'Password, login methods',
                icon: Icons.shield_outlined,
                onTap: () {},
              ),
              _SettingsTile(
                title: 'Notifications',
                subtitle: 'Manage alerts and emails',
                icon: Icons.notifications_outlined,
                onTap: () {},
              ),
            ],
          ),

          // Preferences section
          _SettingsSection(
            title: 'Preferences',
            children: [
              _SettingsTileSwitch(
                title: 'Dark Mode',
                subtitle: 'Change app theme',
                value: false,
                onChanged: (value) {},
                icon: Icons.brightness_4_outlined,
              ),
              _SettingsTileSwitch(
                title: 'Email Updates',
                subtitle: 'Get weekly insights and tips',
                value: true,
                onChanged: (value) {},
                icon: Icons.email_outlined,
              ),
              _SettingsTileSwitch(
                title: 'Push Notifications',
                subtitle: 'Receive timely reminders',
                value: true,
                onChanged: (value) {},
                icon: Icons.schedule_outlined,
              ),
            ],
          ),

          // Data & Privacy section
          _SettingsSection(
            title: 'Data & Privacy',
            children: [
              _SettingsTile(
                title: 'Data Download',
                subtitle: 'Download your ConfiCircle data',
                icon: Icons.download_outlined,
                onTap: () {},
              ),
              _SettingsTile(
                title: 'Data Deletion',
                subtitle: 'Delete your account and data',
                icon: Icons.delete_outline,
                onTap: () {},
                textColor: AppColors.coral,
              ),
              _SettingsTile(
                title: 'Privacy Policy',
                subtitle: 'How we protect your information',
                icon: Icons.privacy_tip_outlined,
                onTap: () {},
              ),
              _SettingsTile(
                title: 'Terms of Service',
                subtitle: 'Terms and conditions',
                icon: Icons.description_outlined,
                onTap: () {},
              ),
            ],
          ),

          // About section
          _SettingsSection(
            title: 'About',
            children: [
              _SettingsTile(
                title: 'Version',
                subtitle: '1.0.0',
                icon: Icons.info_outline,
                onTap: () {},
              ),
              _SettingsTile(
                title: 'Help & Support',
                subtitle: 'Get help using the app',
                icon: Icons.help_outline,
                onTap: () {},
              ),
              _SettingsTile(
                title: 'Report a Problem',
                subtitle: 'Let us know about issues',
                icon: Icons.report_outlined,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Text(
            title,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...children.map((child) => Padding(
          padding: const EdgeInsets.only(bottom: 1),
          child: child,
        )),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? textColor;

  const _SettingsTile({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppColors.blue,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTypography.bodyLarge.copyWith(
          color: textColor ?? AppColors.black,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.darkGrey,
              ),
            )
          : null,
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.lightGrey,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}

class _SettingsTileSwitch extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsTileSwitch({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppColors.blue,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTypography.bodyLarge,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.darkGrey,
              ),
            )
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.coral,
      ),
    );
  }
}