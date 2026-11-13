// lib/screens/home/widgets/section_header.dart
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? moreLabel;
  final VoidCallback? onMore;

  const SectionHeader({
    super.key,
    required this.title,
    this.moreLabel = 'More',
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: AppTypography.headingSmall),
          ),
          if (onMore != null)
            GestureDetector(
              onTap: onMore,
              child: Text(
                moreLabel ?? 'More',
                style: AppTypography.labelMedium.copyWith(color: AppColors.coral),
              ),
            ),
        ],
      ),
    );
  }
}
