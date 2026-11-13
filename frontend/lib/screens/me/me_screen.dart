// lib/screens/me/me_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../core/widgets/tactile_card.dart';
import '../assessment/assessment_screen.dart';

/// Profile & Progress Screen (Blueprint §16 / Marvilo Duolingo Profile)
/// Features 2x2 statistics grid, achievements list with progress bars, and personal records.
class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().profile;
    final int score = user.confiScore > 0 ? user.confiScore.toInt() : 57;
    final int level = user.confiLevel > 0 ? user.confiLevel : 5;
    final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : 'A';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: AppTypography.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.blue,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.blue),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings opened'), backgroundColor: AppColors.blue),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card (Marvilo Profile Header)
            TactileCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFD4E1FB), width: 2.5),
                        ),
                        child: Center(
                          child: Text(
                            initial,
                            style: AppTypography.montserrat(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: AppColors.coral,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name.isNotEmpty ? user.name : 'Student Member',
                          style: AppTypography.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.college ?? 'Engineering & Management',
                          style: AppTypography.body(fontSize: 12, color: AppColors.darkGrey),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF5FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Joined Nov 2026',
                            style: AppTypography.montserrat(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Statistics Header & 2x2 Grid (Marvilo Duolingo Statistics)
            Text(
              'Statistics',
              style: AppTypography.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.blue,
              ),
            ),
            const SizedBox(height: 8),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.8,
              children: [
                _StatTile(icon: '⚡', label: 'Day streak', value: '5'),
                _StatTile(icon: '💎', label: 'Total CP', value: '${user.confiPoints}'),
                _StatTile(icon: '🎯', label: 'ConfiScore', value: '$score'),
                _StatTile(icon: '🛡️', label: 'Current Level', value: 'CL $level'),
              ],
            ),

            const SizedBox(height: 20),

            // Achievements Section (Marvilo Profile Achievements)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Achievements',
                  style: AppTypography.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blue,
                  ),
                ),
                Text(
                  'View all',
                  style: AppTypography.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coral,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            _AchievementCard(
              badgeEmoji: '🔥',
              badgeColor: const Color(0xFFFF9600),
              title: 'Wildfire',
              subtitle: 'Reach a 7-day focus streak',
              progress: 5 / 7,
              progressLabel: '5/7',
            ),
            const SizedBox(height: 10),
            _AchievementCard(
              badgeEmoji: '🏆',
              badgeColor: const Color(0xFF58CC02),
              title: 'Pioneer',
              subtitle: 'Earn 500 ConfiPoints across activities',
              progress: (user.confiPoints / 500).clamp(0.0, 1.0),
              progressLabel: '${user.confiPoints}/500',
            ),
            const SizedBox(height: 10),
            _AchievementCard(
              badgeEmoji: '📚',
              badgeColor: AppColors.blue,
              title: 'Scholar',
              subtitle: 'Complete 5 diagnostic check-ins',
              progress: 2 / 5,
              progressLabel: '2/5',
            ),

            const SizedBox(height: 24),

            // Diagnostic Trigger Action
            TactileCard(
              backgroundColor: const Color(0xFFEFF5FF),
              borderColor: const Color(0xFFD4E1FB),
              bevelColor: const Color(0xFFBDD4FA),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AssessmentScreen()),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.insights_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Retake Diagnostic Assessment',
                          style: AppTypography.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.blue,
                          ),
                        ),
                        Text(
                          'Refresh your radar & calibrate Level',
                          style: AppTypography.body(fontSize: 11, color: AppColors.darkGrey),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.blue),
                ],
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _StatTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return TactileCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: AppTypography.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              Text(
                label,
                style: AppTypography.body(
                  fontSize: 10,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String badgeEmoji;
  final Color badgeColor;
  final String title;
  final String subtitle;
  final double progress;
  final String progressLabel;

  const _AchievementCard({
    required this.badgeEmoji,
    required this.badgeColor,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.progressLabel,
  });

  @override
  Widget build(BuildContext context) {
    return TactileCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: badgeColor.withOpacity(0.3), width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(badgeEmoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTypography.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      progressLabel,
                      style: AppTypography.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.body(fontSize: 10.5, color: AppColors.darkGrey),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFE4E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(badgeColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
