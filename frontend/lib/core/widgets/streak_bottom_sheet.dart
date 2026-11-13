// lib/core/widgets/streak_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'tactile_button.dart';

/// Duolingo-Grade Streak Modal (Marvilo Kit Frame "Duolingo Streak")
void showStreakBottomSheet(BuildContext context) {
  HapticFeedback.mediumImpact();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _StreakBottomSheetContent(),
  );
}

class _StreakBottomSheetContent extends StatelessWidget {
  const _StreakBottomSheetContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE4E8F0),
            offset: Offset(0, -3),
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E0),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 20),

            // Streak Flame Graphic (No cartoon characters)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFF4E5),
                border: Border.all(color: const Color(0xFFFF9600), width: 3),
              ),
              child: const Center(
                child: Text('⚡', style: TextStyle(fontSize: 40)),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              '5 Day Streak!',
              style: AppTypography.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.blue,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'You have engaged in personal growth 5 days in a row.\nKeep building your habit!',
              textAlign: TextAlign.center,
              style: AppTypography.body(fontSize: 13, color: AppColors.darkGrey),
            ),

            const SizedBox(height: 20),

            // 7-Day Calendar Streak Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE4E8F0), width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _DayStreakItem(day: 'M', isActive: true),
                  _DayStreakItem(day: 'T', isActive: true),
                  _DayStreakItem(day: 'W', isActive: true),
                  _DayStreakItem(day: 'T', isActive: true),
                  _DayStreakItem(day: 'F', isActive: true),
                  _DayStreakItem(day: 'S', isActive: false),
                  _DayStreakItem(day: 'S', isActive: false),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Streak Freeze equipped card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFBEE3F8), width: 1.5),
              ),
              child: Row(
                children: [
                  const Text('❄️', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Streak Freeze Active',
                          style: AppTypography.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.blue,
                          ),
                        ),
                        Text(
                          'Protects your streak for 1 missed day.',
                          style: AppTypography.body(fontSize: 11, color: AppColors.darkGrey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3182CE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'EQUIPPED',
                      style: AppTypography.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            TactileButton.primary(
              text: 'CONTINUE GROWING',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayStreakItem extends StatelessWidget {
  final String day;
  final bool isActive;

  const _DayStreakItem({required this.day, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFFFF9600) : const Color(0xFFE2E8F0),
            boxShadow: isActive
                ? const [
                    BoxShadow(
                      color: Color(0xFFCC7700),
                      offset: Offset(0, 2),
                      blurRadius: 0,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              isActive ? '✓' : '',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day,
          style: AppTypography.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isActive ? AppColors.blue : const Color(0xFFA0AEC0),
          ),
        ),
      ],
    );
  }
}
