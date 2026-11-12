// lib/screens/home/widgets/explore_life_journey.dart
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import 'section_header.dart';

class ExploreLifeJourneySection extends StatelessWidget {
  const ExploreLifeJourneySection({super.key});

  static const List<Map<String, dynamic>> _categories = [
    {'title': 'Career\nExploration', 'emoji': '🚀', 'color': Color(0xFF173883)},
    {'title': 'Confidence\nBuilding', 'emoji': '💪', 'color': Color(0xFFF2432C)},
    {'title': 'Financial\nBasics', 'emoji': '📈', 'color': Color(0xFF27AE60)},
    {'title': 'Emotional\nIntelligence', 'emoji': '🤍', 'color': Color(0xFF4475D7)},
    {'title': 'Communication\nSkills', 'emoji': '🗣️', 'color': Color(0xFF9B59B6)},
    {'title': 'Wellness &\nPeace', 'emoji': '🌿', 'color': Color(0xFF16A085)},
    {'title': 'Leadership\nGrowth', 'emoji': '👑', 'color': Color(0xFFE67E22)},
    {'title': 'Self-\nAwareness', 'emoji': '🔍', 'color': Color(0xFF2980B9)},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Explore Life Journey', onMore: () {}),
          SizedBox(
            height: 110,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: _categories.length,
              itemBuilder: (_, i) {
                final cat = _categories[i];
                return _CategoryCard(
                  title: cat['title'] as String,
                  emoji: cat['emoji'] as String,
                  color: cat['color'] as Color,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String emoji;
  final Color color;
  const _CategoryCard({required this.title, required this.emoji, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 90,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.montserrat(
                fontSize: 9.5, fontWeight: FontWeight.w700, color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
