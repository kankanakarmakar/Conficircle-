// lib/screens/home/widgets/do_you_know.dart
import 'package:flutter/material.dart';
import '../../../data/mock_resources.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import 'section_header.dart';

class DoYouKnowSection extends StatelessWidget {
  const DoYouKnowSection({super.key});

  @override
  Widget build(BuildContext context) {
    final facts = doYouKnowFacts.take(3).toList();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Do You Know?', onMore: () {}),
          SizedBox(
            height: 170,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: facts.length,
              itemBuilder: (_, i) {
                final f = facts[i];
                final colors = [
                  const Color(0xFF1A3A7A),
                  const Color(0xFF6B2D9E),
                  const Color(0xFF27AE60),
                ];
                return _FactCard(
                  emoji: f['emoji']!,
                  title: f['title']!,
                  description: f['description']!,
                  color: colors[i % colors.length],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FactCard extends StatelessWidget {
  final String emoji, title, description;
  final Color color;
  const _FactCard({required this.emoji, required this.title, required this.description, required this.color});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width * 0.58;
    return Container(
      width: w,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 8),
          Text(title,
              maxLines: 2,
              style: AppTypography.montserrat(
                fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.white,
              )),
          const SizedBox(height: 4),
          Text(description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.white.withOpacity(0.85), fontSize: 10,
              )),
        ],
      ),
    );
  }
}
