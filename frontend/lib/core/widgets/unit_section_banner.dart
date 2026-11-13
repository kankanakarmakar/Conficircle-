// lib/core/widgets/unit_section_banner.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Duolingo-style Section / Focus Banner.
/// Replicates the famous Duolingo Unit Header: bold colored background,
/// section label, unit title, and a tactile "Guidebook" icon button on the right.
class UnitSectionBanner extends StatelessWidget {
  final String sectionNumber;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback? onGuidebookTap;

  const UnitSectionBanner({
    super.key,
    this.sectionNumber = 'SECTION 1',
    required this.title,
    required this.subtitle,
    this.backgroundColor = const Color(0xFF173883),
    this.borderColor = const Color(0xFF0F2459),
    this.onGuidebookTap,
  });

  const UnitSectionBanner.coral({
    super.key,
    this.sectionNumber = 'ACTIVE FOCUS',
    required this.title,
    required this.subtitle,
    this.backgroundColor = AppColors.coral,
    this.borderColor = const Color(0xFFC02A16),
    this.onGuidebookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.2), width: 1.5),
          left: BorderSide(color: Colors.white.withOpacity(0.2), width: 1.5),
          right: BorderSide(color: Colors.white.withOpacity(0.2), width: 1.5),
          bottom: BorderSide(color: borderColor, width: 4.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sectionNumber.toUpperCase(),
                  style: AppTypography.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white.withOpacity(0.85),
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  title,
                  style: AppTypography.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.body(
                    fontSize: 11.5,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Tactile Guidebook / Info Button
          GestureDetector(
            onTap: onGuidebookTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(14),
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
                  left: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
                  right: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
                  bottom: BorderSide(color: Colors.black.withOpacity(0.2), width: 3),
                ),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
