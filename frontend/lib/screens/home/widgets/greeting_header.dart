// lib/screens/home/widgets/greeting_header.dart
import 'package:flutter/material.dart';
import '../../../models/user_profile.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

/// Personalized Greeting Header (Blueprint §7.1 and §8.1)
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
    final firstName = user.name.isNotEmpty ? user.name.split(' ').first : 'there';

    if (!isFirst) {
      // Returning user greeting headline
      return Container(
        color: AppColors.white,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Welcome back, $firstName!',
                    style: AppTypography.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.blue,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FD),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFD4E1FB), width: 1.5),
                  ),
                  child: Text(
                    'Level ${user.confiLevel} · ${user.confiLevelShort}',
                    style: AppTypography.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
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

    // First-time user greeting headline
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            firstName.isNotEmpty ? 'Welcome, $firstName!' : 'Welcome to ConfiCircle!',
            style: AppTypography.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.blue,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Explore topics, discover your baseline, and grow at your own pace.',
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
