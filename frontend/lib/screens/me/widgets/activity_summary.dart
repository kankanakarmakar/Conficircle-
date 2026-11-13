// lib/screens/me/widgets/activity_summary.dart
import 'package:flutter/material.dart';
import '../../../models/user_profile.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class ActivitySummary extends StatelessWidget {
  final UserProfile profile;

  const ActivitySummary({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Activity', style: AppTypography.labelLarge),
        const SizedBox(height: 14),

        // Stats grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: [
            _StatCard(
              emoji: '🎯',
              label: 'Actions Explored',
              value: '${profile.clickedActionIds.length}',
              color: AppColors.blue,
            ),
            _StatCard(
              emoji: '💾',
              label: 'Resources Saved',
              value: '${profile.savedResourceIds.length}',
              color: const Color(0xFF27AE60),
            ),
            _StatCard(
              emoji: '🎓',
              label: 'Programs Done',
              value: '${profile.completedProgramIds.length}',
              color: AppColors.coral,
            ),
            _StatCard(
              emoji: '⭐',
              label: 'Confi Points',
              value: '${profile.confiPoints}',
              color: AppColors.warning,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Engagement streak (visual)
        if (profile.clickedActionIds.length > 2) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.coral.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.coral.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You\'re on a roll!',
                        style: AppTypography.labelLarge
                            .copyWith(color: AppColors.coral),
                      ),
                      Text(
                        'Keep exploring to level up your Confi.',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.blue.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start your journey',
                        style: AppTypography.labelLarge
                            .copyWith(color: AppColors.blue),
                      ),
                      Text(
                        'Explore actions to earn Confi Points and level up.',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],

        // Interest tags
        if (profile.focusCategories.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Your Focus Areas', style: AppTypography.labelLarge),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.focusCategories
                .map((cat) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF173883), Color(0xFF4475D7)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        cat,
                        style: AppTypography.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji, label, value;
  final Color color;

  const _StatCard({
    required this.emoji,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTypography.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(
                label,
                style: AppTypography.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
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
