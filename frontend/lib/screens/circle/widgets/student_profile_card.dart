// lib/screens/circle/widgets/student_profile_card.dart
import 'package:flutter/material.dart';
import '../../../models/group.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class StudentProfileCard extends StatelessWidget {
  final StudentCard student;
  final VoidCallback? onConnect;

  const StudentProfileCard({
    super.key,
    required this.student,
    this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Text(student.avatarEmoji,
              style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.name, style: AppTypography.labelLarge),
                Text(
                  '${student.college} · ${student.course}',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: [
                    _Badge(
                      label: 'CL ${student.confiLevel}',
                      color: AppColors.coral,
                    ),
                    ...student.interests.take(2).map(
                          (t) => _Badge(label: t, color: AppColors.blue),
                        ),
                  ],
                ),
                if (student.completedPrograms.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '✓ ${student.completedPrograms.first}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.success,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Connect button
          Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  textStyle: AppTypography.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: onConnect ?? () {},
                child: const Text('Connect'),
              ),
              const SizedBox(height: 4),
              Text(
                'Score: ${student.confiScore.toInt()}',
                style: AppTypography.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTypography.montserrat(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
