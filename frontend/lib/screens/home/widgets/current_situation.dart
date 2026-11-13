// lib/screens/home/widgets/current_situation.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../core/widgets/tactile_card.dart';
import '../../assessment/assessment_screen.dart';

/// Section 8.1 & 8.2 of Blueprint: "Your Current Situation"
/// Displays ConfiScore, ConfiLevel, 3 active focus categories with individual scores,
/// Add Category, and Reassess entry. Styled with Duolingo-grade tactile depth.
class CurrentSituationSection extends StatelessWidget {
  const CurrentSituationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().profile;
    final int score = user.confiScore > 0 ? user.confiScore.toInt() : 57;
    final int level = user.confiLevel > 0 ? user.confiLevel : 5;
    final String levelName = user.confiLevelShort.isNotEmpty ? user.confiLevelShort : 'Aligning';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TactileCard(
        backgroundColor: const Color(0xFF173883),
        borderColor: const Color(0xFF2E5CB8),
        bevelColor: const Color(0xFF0D2254),
        depth: 5.0,
        borderRadius: 22.0,
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Section Label + Reassess Link
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'YOUR CURRENT SITUATION',
                    style: AppTypography.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AssessmentScreen()),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.refresh_rounded, size: 14, color: Color(0xFFFF8E7D)),
                      const SizedBox(width: 4),
                      Text(
                        'Reassess',
                        style: AppTypography.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFF8E7D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Middle Block: Score Capsule + Level
            Row(
              children: [
                // Chunky Score Ring
                SizedBox(
                  width: 54,
                  height: 54,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: (score / 100.0).clamp(0.0, 1.0),
                        strokeWidth: 5.5,
                        backgroundColor: AppColors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.coral),
                      ),
                      Text(
                        '$score',
                        style: AppTypography.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'CS $score',
                            style: AppTypography.montserrat(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            '  |  CL $level ($levelName)',
                            style: AppTypography.montserrat(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFD4E1FB),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Based on your diagnostic & ongoing practice',
                        style: AppTypography.body(
                          fontSize: 11,
                          color: AppColors.white.withOpacity(0.75),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Divider(color: AppColors.white.withOpacity(0.15), thickness: 1),
            const SizedBox(height: 10),

            // Three Focus Categories and Individual Scores (per Blueprint §8.1)
            Text(
              'ACTIVE FOCUS AREAS',
              style: AppTypography.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFD4E1FB),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),

            _FocusScoreBar(
              title: 'Career Clarity',
              score: 56,
              color: const Color(0xFF63A1FF),
            ),
            const SizedBox(height: 8),
            _FocusScoreBar(
              title: 'Confidence & Self-Worth',
              score: 62,
              color: AppColors.coral,
            ),
            const SizedBox(height: 8),
            _FocusScoreBar(
              title: 'Communication & Expression',
              score: 51,
              color: const Color(0xFF48D18C),
            ),

            const SizedBox(height: 14),

            // Bottom Actions: + Add Category & Contextual Share
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening category selector...'),
                          backgroundColor: AppColors.blue,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.white.withOpacity(0.25)),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_rounded, size: 16, color: AppColors.white),
                          const SizedBox(width: 4),
                          Text(
                            'Add Category',
                            style: AppTypography.montserrat(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Score summary copied to clipboard!'),
                        backgroundColor: AppColors.coral,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 38,
                    width: 42,
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.white.withOpacity(0.25)),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.share_outlined, size: 16, color: AppColors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FocusScoreBar extends StatelessWidget {
  final String title;
  final int score;
  final Color color;

  const _FocusScoreBar({
    required this.title,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTypography.montserrat(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            Text(
              '$score/100',
              style: AppTypography.montserrat(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFD4E1FB),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (score / 100.0).clamp(0.0, 1.0),
            minHeight: 5.5,
            backgroundColor: AppColors.white.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
