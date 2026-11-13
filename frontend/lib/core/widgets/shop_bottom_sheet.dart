// lib/core/widgets/shop_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'tactile_button.dart';

/// Duolingo-Grade Shop / Points Modal (Marvilo Kit Frame "Duolingo shop")
void showShopBottomSheet(BuildContext context, int currentPoints) {
  HapticFeedback.mediumImpact();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _ShopBottomSheetContent(currentPoints: currentPoints),
  );
}

class _ShopBottomSheetContent extends StatelessWidget {
  final int currentPoints;
  const _ShopBottomSheetContent({required this.currentPoints});

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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E0),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header with current points
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ConfiPoints Store',
                      style: AppTypography.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.blue,
                      ),
                    ),
                    Text(
                      'Power-ups to support your growth',
                      style: AppTypography.body(fontSize: 12, color: AppColors.darkGrey),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FD),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFD4E1FB), width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('💎', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(
                        '$currentPoints CP',
                        style: AppTypography.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Item 1: Streak Freeze
            _ShopItemCard(
              icon: '❄️',
              title: 'Streak Freeze',
              desc: 'Allows your streak to remain in place for one full day of inactivity.',
              price: 200,
              isEquipped: true,
            ),

            const SizedBox(height: 12),

            // Item 2: Double or Nothing
            _ShopItemCard(
              icon: '📅',
              title: 'Double or Nothing',
              desc: 'Double your 50 CP wager by maintaining a 7-day personal growth streak.',
              price: 50,
              isEquipped: false,
            ),

            const SizedBox(height: 12),

            // Item 3: 1-to-1 Mentorship Pass
            _ShopItemCard(
              icon: '🎟️',
              title: 'Mentorship Priority Pass',
              desc: 'Priority booking for student career and confidence mentors in ConfiZone.',
              price: 300,
              isEquipped: false,
            ),

            const SizedBox(height: 20),

            TactileButton.primary(
              text: 'DONE',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  final String icon;
  final String title;
  final String desc;
  final int price;
  final bool isEquipped;

  const _ShopItemCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.price,
    required this.isEquipped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E8F0), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFE4E8F0),
            offset: Offset(0, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: AppTypography.body(fontSize: 11, color: AppColors.darkGrey, height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: isEquipped ? const Color(0xFFF0F4FD) : AppColors.blue,
              borderRadius: BorderRadius.circular(10),
              border: isEquipped ? Border.all(color: const Color(0xFFD4E1FB), width: 1.5) : null,
              boxShadow: isEquipped
                  ? []
                  : const [
                      BoxShadow(
                        color: Color(0xFF0D2254),
                        offset: Offset(0, 2.5),
                        blurRadius: 0,
                      ),
                    ],
          ),
          child: Text(
            isEquipped ? 'EQUIPPED' : '💎 $price',
            style: AppTypography.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: isEquipped ? AppColors.blue : Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
}
