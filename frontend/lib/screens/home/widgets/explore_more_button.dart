// lib/screens/home/widgets/explore_more_button.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/recommendation_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class ExploreMoreButton extends StatelessWidget {
  const ExploreMoreButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecommendationProvider>();
    if (provider.exploreMoreVisible) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.coral,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            elevation: 0,
          ),
          onPressed: () => context.read<RecommendationProvider>().loadExploreMore(),
          child: Text('Explore more', style: AppTypography.ctaStyle),
        ),
      ),
    );
  }
}
