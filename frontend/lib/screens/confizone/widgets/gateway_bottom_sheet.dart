// lib/screens/confizone/widgets/gateway_bottom_sheet.dart
import 'package:flutter/material.dart';
import '../../../../data/taxonomy_data.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../assessment/assessment_screen.dart';
import 'category_list_screen.dart';

/// Gateway / "Not Sure Where To Start?" Bottom Sheet (SC-021)
class GatewayBottomSheet extends StatelessWidget {
  const GatewayBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const GatewayBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final areas = TaxonomyData.areas;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Title & subtitle
          Text(
            'Where would you like to start?',
            style: AppTypography.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pick an area that feels most urgent to you, or take a diagnostic check-in.',
            style: AppTypography.body(fontSize: 13, color: AppColors.darkGrey),
          ),
          const SizedBox(height: 18),

          // 4 Area action buttons
          ...areas.map((area) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.lightGrey, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CategoryListScreen(area: area),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(area.icon, color: area.accentColor, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        area.title,
                        style: AppTypography.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.darkGrey,
                    ),
                  ],
                ),
              ),
            ),
          )),

          const SizedBox(height: 12),

          // Direct assessment link
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AssessmentScreen()),
                );
              },
              child: Text(
                'Let the Diagnostic Assessment guide me →',
                style: AppTypography.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coral,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
