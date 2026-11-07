// lib/screens/home/widgets/recommended_programs.dart
import 'package:flutter/material.dart';
import '../../../data/mock_programs.dart';
import '../../../models/program.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import 'section_header.dart';

class RecommendedProgramsSection extends StatelessWidget {
  const RecommendedProgramsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final programs = [
      ...getFeaturedPrograms(ProgramType.program, limit: 2),
      ...getFeaturedPrograms(ProgramType.assessment, limit: 1),
    ];

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Recommended for you', onMore: () {}),
          SizedBox(
            height: 160,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: programs.length,
              itemBuilder: (_, i) => _ProgramCard(program: programs[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final Program program;
  const _ProgramCard({required this.program});

  Color _color() {
    try {
      final hex = program.colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppColors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    final w = MediaQuery.of(context).size.width * 0.58;

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: w,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(program.emoji, style: const TextStyle(fontSize: 26)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: program.isFree ? const Color(0xFF27AE60) : AppColors.coral,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    program.priceLabel,
                    style: AppTypography.montserrat(
                      fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(program.name,
                maxLines: 2,
                style: AppTypography.labelLarge.copyWith(color: color)),
            const SizedBox(height: 4),
            Text(program.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall),
            const Spacer(),
            if (program.targetConfiScore != null)
              Text(
                '↑ Target CS: ${program.targetConfiScore}',
                style: AppTypography.montserrat(
                  fontSize: 10, fontWeight: FontWeight.w600, color: color,
                ),
              ),
            if (program.duration != null)
              Text(program.duration!,
                  style: AppTypography.bodySmall.copyWith(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
