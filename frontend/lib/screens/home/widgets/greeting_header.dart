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
      // Returning user greeting with streak badge
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.greeting}, ${user.name.split(' ').first}',
                    style: AppTypography.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Here is your personal growth radar for today',
                    style: AppTypography.body(
                      fontSize: 13,
                      color: AppColors.darkGrey,
                    ),
                  ),
                ],
              ),
            ),
            // Streak badge pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.softGrey,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.lightGrey, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('⚡', style: TextStyle(fontSize: 13)),
                  const SizedBox(width: 4),
                  Text(
                    'CL ${user.confiLevel} Focus',
                    style: AppTypography.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // First-time user greeting
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.greeting,
            style: AppTypography.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Welcome to ',
                  style: AppTypography.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue,
                  ),
                ),
                TextSpan(
                  text: 'ConfiCircle',
                  style: AppTypography.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.coral,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Discover what matters to you. Build confidence at your own pace.',
            style: AppTypography.body(
              fontSize: 14,
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}
