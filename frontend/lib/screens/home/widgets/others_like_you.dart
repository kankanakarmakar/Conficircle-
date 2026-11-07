// lib/screens/home/widgets/others_like_you.dart
import 'package:flutter/material.dart';
import '../../../data/mock_actions.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import 'section_header.dart';

class OthersLikeYouSection extends StatelessWidget {
  const OthersLikeYouSection({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = allActions.where((a) => [
      'A031', 'A034', 'A033',
    ].contains(a.id)).toList();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Others like you are also looking for...', onMore: () {}),
          SizedBox(
            height: 100,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: actions.length,
              itemBuilder: (_, i) {
                final a = actions[i];
                return _OthersCard(emoji: a.emoji, text: a.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OthersCard extends StatelessWidget {
  final String emoji, text;
  const _OthersCard({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.softGrey,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(text,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.montserrat(
                  fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.blue,
                )),
          ],
        ),
      ),
    );
  }
}
