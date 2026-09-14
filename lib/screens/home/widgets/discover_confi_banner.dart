// lib/screens/home/widgets/discover_confi_banner.dart
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class DiscoverConfiBanner extends StatelessWidget {
  const DiscoverConfiBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A3A7A), Color(0xFF4475D7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Want to know where\nyou stand?',
            style: AppTypography.headingSmall.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Discover your Confi Score, your current level, your strengths, and possible areas to explore.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.white.withOpacity(0.85)),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coral,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                elevation: 0,
              ),
              onPressed: () {
                // Navigate to assessment
              },
              child: Text('Discover My Confi', style: AppTypography.ctaStyle),
            ),
          ),
        ],
      ),
    );
  }
}
