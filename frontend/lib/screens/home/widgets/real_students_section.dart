// lib/screens/home/widgets/real_students_section.dart
import 'package:flutter/material.dart';
import '../../../data/mock_groups.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import 'section_header.dart';

class RealStudentsSection extends StatelessWidget {
  const RealStudentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Real students you may connect with', onMore: () {}),
          SizedBox(
            height: 130,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: sampleStudents.length,
              itemBuilder: (_, i) {
                final s = sampleStudents[i];
                return _StudentCard(
                  name: s.name,
                  college: s.college,
                  avatarEmoji: s.avatarEmoji,
                  confiLevel: s.confiLevel,
                  interests: s.interests,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final String name, college, avatarEmoji;
  final int confiLevel;
  final List<String> interests;

  const _StudentCard({
    required this.name,
    required this.college,
    required this.avatarEmoji,
    required this.confiLevel,
    required this.interests,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.softGrey,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(avatarEmoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: AppTypography.montserrat(
                            fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.blue,
                          )),
                      Text('CL $confiLevel',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.coral, fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(college,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: interests
                  .take(2)
                  .map((t) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.blue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(t,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 9, color: AppColors.blue, fontWeight: FontWeight.w600,
                            )),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
