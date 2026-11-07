// lib/screens/home/widgets/greeting_header.dart
import 'package:flutter/material.dart';
import '../../../models/user_profile.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class GreetingHeader extends StatelessWidget {
  final UserProfile user;
  final bool isFirst;
  const GreetingHeader({super.key, required this.user, required this.isFirst});

  @override
  Widget build(BuildContext context) {
    if (!isFirst) {
      // Compact returning greeting to maximize vertical space for questions
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.greeting}, ${user.name} 👋',
                  style: AppTypography.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F2459),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Ready to explore today\'s challenges?',
                  style: AppTypography.body(fontSize: 11.5, color: AppColors.darkGrey),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.greeting,
            style: AppTypography.headingLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Welcome to ConfiCircle 👋',
            style: AppTypography.headingSmall.copyWith(color: AppColors.coral),
          ),
          const SizedBox(height: 6),
          Text(
            'Explore yourself. Discover possibilities.\nTry something new.',
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}
