// lib/screens/home/widgets/useful_content_section.dart
import 'package:flutter/material.dart';
import '../../../data/mock_resources.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import 'section_header.dart';

class UsefulContentSection extends StatelessWidget {
  const UsefulContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = allResources.take(2).toList();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Something useful for you', onMore: () {}),
          SizedBox(
            height: 145,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final r = items[i];
                return _ResourceCard(
                  title: r.title,
                  emoji: r.typeEmoji,
                  duration: r.duration ?? '',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final String title;
  final String emoji;
  final String duration;
  const _ResourceCard({required this.title, required this.emoji, required this.duration});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width * 0.55;
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: w,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.softGrey,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {},
                child: const Icon(Icons.bookmark_border_rounded, color: AppColors.darkGrey, size: 20),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 24)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.montserrat(
                        fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.blue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(duration, style: AppTypography.bodySmall),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
