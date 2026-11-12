// lib/features/discovery/presentation/widgets/priority_selector.dart
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';

class PrioritySelector extends StatelessWidget {
  final int selectedPriority;
  final ValueChanged<int> onPriorityChanged;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personalisation Intensity',
          style: AppTypography.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildOption(context, 1, 'Balanced Feed', 'Standard mix of topics'),
            const SizedBox(width: 10),
            _buildOption(context, 2, 'Targeted Focus', 'Prioritise selected issues'),
          ],
        ),
      ],
    );
  }

  Widget _buildOption(BuildContext context, int value, String label, String sub) {
    final isSelected = selectedPriority == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onPriorityChanged(value),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.cardBg2 : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.blue : AppColors.lightGrey,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppColors.blue : AppColors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sub,
                style: AppTypography.body(fontSize: 10.5, color: AppColors.darkGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

