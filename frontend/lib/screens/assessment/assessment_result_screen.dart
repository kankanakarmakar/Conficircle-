// lib/screens/assessment/assessment_result_screen.dart
import 'package:flutter/material.dart';
import '../../models/confi_score.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../core/widgets/tactile_button.dart';
import '../me/widgets/confi_score_widget.dart';
import '../main_shell.dart';

class AssessmentResultScreen extends StatelessWidget {
  final double score;
  final int level;

  const AssessmentResultScreen({
    super.key,
    required this.score,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final confiScore = ConfiScore.fromOverall(score, level);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.blue,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F2459), Color(0xFF2258C5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Celebration
                        const Text('🎉',
                            style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 10),
                        Text(
                          'Your Confi Report',
                          style: AppTypography.headingLarge.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          'Based on ${confiScore.categories.length} dimensions of growth',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Score + level card
                  ConfiScoreWidget(
                    score: score,
                    level: level,
                    levelName: confiScore.levelName,
                  ),
                  const SizedBox(height: 20),

                  // Level description
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.coral.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: AppColors.coral.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Text('🏅', style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${confiScore.levelName} — ${confiScore.levelSubtitle}',
                                style: AppTypography.labelLarge.copyWith(
                                  color: AppColors.coral,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getLevelMessage(level),
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Breakdown
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ConfiScoreBreakdown(confiScore: confiScore),
                  ),
                  const SizedBox(height: 20),

                  // What's next
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.softGrey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('What\'s next?', style: AppTypography.labelLarge),
                        const SizedBox(height: 12),
                        _NextStep(
                          emoji: '🎯',
                          title: 'Explore ConfiZone',
                          subtitle: 'Recommended programs based on your results',
                        ),
                        _NextStep(
                          emoji: '📚',
                          title: 'Browse Resources',
                          subtitle: 'Articles, videos and guides tailored for you',
                        ),
                        _NextStep(
                          emoji: '👥',
                          title: 'Join a Circle',
                          subtitle: 'Connect with students on the same journey',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // CTA buttons (Duolingo Tactile 3D Buttons)
                  TactileButton.primary(
                    text: 'EXPLORE CONFIZONE',
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const MainShell(initialIndex: 1),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  TactileButton.secondary(
                    text: 'VIEW MY PROFILE',
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const MainShell(initialIndex: 3),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLevelMessage(int level) {
    if (level <= 2) {
      return 'You\'re just starting out — that\'s exciting! Every expert was once a beginner.';
    } else if (level <= 4) {
      return 'You\'re finding your direction. Keep exploring and building momentum!';
    } else if (level <= 7) {
      return 'You\'re growing steadily. Your efforts are shaping your future!';
    } else if (level <= 10) {
      return 'You\'re making a real impact. Lead, inspire, and keep pushing forward!';
    } else {
      return 'You\'re a Legend in the making. Inspire the next generation!';
    }
  }
}

class _NextStep extends StatelessWidget {
  final String emoji, title, subtitle;

  const _NextStep({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyLarge),
                Text(subtitle, style: AppTypography.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: AppColors.darkGrey),
        ],
      ),
    );
  }
}
