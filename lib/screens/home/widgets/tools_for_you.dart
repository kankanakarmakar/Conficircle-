// lib/screens/home/widgets/tools_for_you.dart
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import 'section_header.dart';

class ToolsForYouSection extends StatelessWidget {
  const ToolsForYouSection({super.key});

  static const List<Map<String, dynamic>> _tools = [
    {'title': 'Wheel of Life', 'emoji': '🎯', 'desc': 'Map all areas of your life', 'color': AppColors.blue},
    {'title': 'Decision Helper', 'emoji': '⚖️', 'desc': 'Make better decisions', 'color': AppColors.coral},
    {'title': 'Goal Mapper', 'emoji': '🗺️', 'desc': 'Set and track your goals', 'color': Color(0xFF27AE60)},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Tools for You', onMore: () {}),
          SizedBox(
            height: 110,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: _tools.length,
              itemBuilder: (_, i) {
                final t = _tools[i];
                return _ToolCard(
                  title: t['title'] as String,
                  emoji: t['emoji'] as String,
                  desc: t['desc'] as String,
                  color: t['color'] as Color,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final String title, emoji, desc;
  final Color color;
  const _ToolCard({required this.title, required this.emoji, required this.desc, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(title,
                textAlign: TextAlign.center,
                style: AppTypography.montserrat(
                  fontSize: 11, fontWeight: FontWeight.w700, color: color,
                )),
            const SizedBox(height: 3),
            Text(desc,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppTypography.bodySmall.copyWith(fontSize: 9)),
          ],
        ),
      ),
    );
  }
}
