// lib/screens/me/widgets/confi_score_widget.dart
import 'package:flutter/material.dart';
import '../../../models/confi_score.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

/// A compact score dial + category bars widget
class ConfiScoreWidget extends StatelessWidget {
  final double score;
  final int level;
  final String levelName;

  const ConfiScoreWidget({
    super.key,
    required this.score,
    required this.level,
    required this.levelName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2459), Color(0xFF2258C5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Score ring
          SizedBox(
            width: 90,
            height: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: score / 100),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutCubic,
                  builder: (_, val, __) => CircularProgressIndicator(
                    value: val,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withOpacity(0.15),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.coral),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${score.toInt()}',
                      style: AppTypography.montserrat(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      'Score',
                      style: AppTypography.montserrat(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // Level info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Confi Level $level',
                  style: AppTypography.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  levelName,
                  style: AppTypography.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 12),
                // Progress to next level
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (level - 1) / 11,
                    minHeight: 6,
                    backgroundColor: Colors.white.withOpacity(0.15),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.coral),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Level $level → ${level < 12 ? level + 1 : 12}',
                  style: AppTypography.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.white54,
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

/// Full breakdown of ConfiScore across categories
class ConfiScoreBreakdown extends StatelessWidget {
  final ConfiScore confiScore;

  const ConfiScoreBreakdown({super.key, required this.confiScore});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Score Breakdown', style: AppTypography.labelLarge),
        const SizedBox(height: 14),
        ...confiScore.categories.map(
          (cat) => _CategoryBar(category: cat),
        ),
      ],
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final ConfiCategoryScore category;

  const _CategoryBar({required this.category});

  @override
  Widget build(BuildContext context) {
    Color barColor;
    if (category.score >= 80) {
      barColor = AppColors.success;
    } else if (category.score >= 60) {
      barColor = AppColors.lightBlue;
    } else if (category.score >= 40) {
      barColor = AppColors.warning;
    } else {
      barColor = AppColors.coral;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            children: [
              Text(category.emoji,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(category.category,
                    style: AppTypography.bodyMedium),
              ),
              Text(
                '${category.score.toInt()}%',
                style: AppTypography.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: barColor,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: barColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category.grade,
                  style: AppTypography.montserrat(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: barColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: category.score / 100),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (_, val, __) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: val,
                minHeight: 8,
                backgroundColor: AppColors.lightGrey,
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
