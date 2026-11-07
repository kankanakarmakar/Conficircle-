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
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.greeting,
                      style: AppTypography.headingLarge,
                    ),
                    if (isFirst) ...[
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
                    ] else ...[
                      const SizedBox(height: 4),
                      Text(
                        'Good to have you back ✨',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.coral),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (isFirst) ...[
            const SizedBox(height: 20),
            Text(
              'What are you curious about?',
              style: AppTypography.headingSmall,
            ),
          ] else ...[
            const SizedBox(height: 20),
            Text(
              'What are you looking for today?',
              style: AppTypography.headingSmall,
            ),
          ],
        ],
      ),
    );
  }
}
