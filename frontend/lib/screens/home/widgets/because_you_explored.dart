// lib/screens/home/widgets/because_you_explored.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../data/mock_actions.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import 'section_header.dart';

class BecauseYouExploredSection extends StatelessWidget {
  const BecauseYouExploredSection({super.key});

  @override
  Widget build(BuildContext context) {
    final clicked = context.watch<UserProvider>().profile.clickedActionIds;
    if (clicked.isEmpty) return const SizedBox.shrink();

    // Get recommendations based on clicked actions
    final recommended = allActions
        .where((a) => !clicked.contains(a.id))
        .take(3)
        .toList();

    if (recommended.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Because you explored...', onMore: () {}),
          SizedBox(
            height: 100,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: recommended.length,
              itemBuilder: (_, i) {
                final a = recommended[i];
                Color color;
                try {
                  final hex = a.colorHex.replaceAll('#', '');
                  color = Color(int.parse('FF$hex', radix: 16));
                } catch (_) {
                  color = AppColors.blue;
                }
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 140,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(a.emoji, style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 6),
                        Text(a.text,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.montserrat(
                              fontSize: 10, fontWeight: FontWeight.w600, color: color,
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
