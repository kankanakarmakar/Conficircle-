// lib/screens/home/widgets/share_earn_section.dart
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class ShareEarnSection extends StatelessWidget {
  const ShareEarnSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        children: [
          const Text('🎁', style: TextStyle(fontSize: 36)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share your experience and earn Confi Points',
                  style: AppTypography.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Inviting, not sales-heavy.',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.coral,
                    side: const BorderSide(color: AppColors.coral),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  ),
                  onPressed: () {},
                  child: Text('Share & Earn', style: AppTypography.labelMedium.copyWith(color: AppColors.coral)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
