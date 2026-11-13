// lib/screens/home/widgets/greeting_header.dart
import 'package:flutter/material.dart';
import '../../../models/user_profile.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class GreetingHeader extends StatelessWidget {
  final UserProfile user;
  final bool isFirst;

  const GreetingHeader({
    super.key,
    required this.user,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    if (!isFirst) {
      // Returning user greeting with Duolingo-style status capsule pills
      final firstName = user.name.isNotEmpty ? user.name.split(' ').first : 'there';

      return Container(
        color: AppColors.white,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Status Capsule Strip (Duolingo Header System)
            Row(
              children: [
                _StatusPill(
                  icon: '⚡',
                  label: '5',
                  color: const Color(0xFFFF9600), // Amber fire
                  tooltip: 'Daily streak',
                ),
                const SizedBox(width: 8),
                _StatusPill(
                  icon: '💎',
                  label: '${user.confiPoints}',
                  color: AppColors.blue,
                  tooltip: 'ConfiPoints',
                ),
                const SizedBox(width: 8),
                _StatusPill(
                  icon: '🎯',
                  label: 'CL ${user.confiLevel}',
                  color: AppColors.coral,
                  tooltip: 'ConfiLevel',
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.softGrey,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.lightGrey, width: 1.5),
                  ),
                  child: Text(
                    user.confiLevelShort,
                    style: AppTypography.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Greeting line
            Text(
              'Welcome back, $firstName!',
              style: AppTypography.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.blue,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'What do you want to explore or strengthen today?',
              style: AppTypography.body(
                fontSize: 13,
                color: AppColors.darkGrey,
              ),
            ),
          ],
        ),
      );
    }

    // First-time user greeting
    final firstName = user.name.isNotEmpty ? user.name.split(' ').first : '';
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: firstName.isNotEmpty ? 'Hey $firstName! ' : 'Welcome! ',
                  style: AppTypography.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blue,
                  ),
                ),
                TextSpan(
                  text: 'Ready to grow?',
                  style: AppTypography.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.coral,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Explore what matters to you without pressure or fixed routes.',
            style: AppTypography.body(
              fontSize: 13,
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final String tooltip;

  const _StatusPill({
    required this.icon,
    required this.label,
    required this.color,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4E8F0), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFE4E8F0),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
