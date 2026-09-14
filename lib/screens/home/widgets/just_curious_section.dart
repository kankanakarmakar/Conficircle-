// lib/screens/home/widgets/just_curious_section.dart
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import 'section_header.dart';

class JustCuriousSection extends StatelessWidget {
  const JustCuriousSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'A quick self-discovery question for you',
        'emoji': '🔍',
        'color': AppColors.blue,
        'duration': '2 min',
      },
      {
        'title': '60-second assessment',
        'emoji': '⚡',
        'color': AppColors.coral,
        'duration': '1 min',
      },
    ];

    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Just curious?',
            onMore: () {},
          ),
          SizedBox(
            height: 155,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                return _QuickDiscoveryCard(
                  title: item['title'] as String,
                  emoji: item['emoji'] as String,
                  color: item['color'] as Color,
                  duration: item['duration'] as String,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickDiscoveryCard extends StatelessWidget {
  final String title;
  final String emoji;
  final Color color;
  final String duration;

  const _QuickDiscoveryCard({
    required this.title,
    required this.emoji,
    required this.color,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.44;
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  style: AppTypography.montserrat(
                    fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  duration,
                  style: AppTypography.montserrat(
                    fontSize: 10, fontWeight: FontWeight.w500,
                    color: AppColors.white.withOpacity(0.8),
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
