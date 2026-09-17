// lib/screens/home/widgets/current_situation.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class CurrentSituationSection extends StatelessWidget {
  const CurrentSituationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().profile;

    final Map<String, int> categoryScores = {
      'Career Clarity': 56,
      'Confidence & Self-Worth': 62,
      'Communication & Expression': 51,
    };

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2459), Color(0xFF1E4DB7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CS | CL status line
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Current Situation',
                        style: AppTypography.montserrat(
                          fontSize: 12, fontWeight: FontWeight.w600,
                          color: AppColors.white.withOpacity(0.7),
                        )),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'CS ${user.confiScore.toInt()}',
                          style: AppTypography.montserrat(
                            fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.coral,
                          ),
                        ),
                        TextSpan(
                          text: '  |  CL ${user.confiLevel} (${user.confiLevelShort})',
                          style: AppTypography.montserrat(
                            fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.white,
                          ),
                        ),
                        const TextSpan(text: '  🎯'),
                      ]),
                    ),
                  ],
                ),
              ),
              // Share button
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.share_outlined, color: AppColors.white, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 16),

          // Focus categories
          Text('Focus Areas',
              style: AppTypography.montserrat(
                fontSize: 12, fontWeight: FontWeight.w600,
                color: AppColors.white.withOpacity(0.7),
              )),
          const SizedBox(height: 10),
          ...categoryScores.entries.map((e) => _FocusCategoryRow(
            name: e.key,
            score: e.value,
          )),
          const SizedBox(height: 12),

          // Actions row
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.white,
                    side: const BorderSide(color: Colors.white38),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  ),
                  onPressed: () {},
                  child: Text('+ Add Focus',
                      style: AppTypography.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.white)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: Text('Reassess Confi',
                      style: AppTypography.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FocusCategoryRow extends StatelessWidget {
  final String name;
  final int score;
  const _FocusCategoryRow({required this.name, required this.score});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(name,
                    style: AppTypography.montserrat(
                      fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.white,
                    )),
              ),
              Text('$score/100',
                  style: AppTypography.montserrat(
                    fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.coral,
                  )),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.coral),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
}
