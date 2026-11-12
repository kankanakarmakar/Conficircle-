// lib/features/discovery/presentation/widgets/selected_concern_chips.dart
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../domain/entities/concern_prompt_entity.dart';

class SelectedConcernChips extends StatelessWidget {
  final List<ConcernPromptEntity> selectedConcerns;
  final ValueChanged<ConcernPromptEntity> onRemove;

  const SelectedConcernChips({
    super.key,
    required this.selectedConcerns,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedConcerns.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Selected Challenges (${selectedConcerns.length}/5)',
              style: AppTypography.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedConcerns.map((concern) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardBg2,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.blue.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      concern.promptText,
                      style: AppTypography.montserrat(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blue,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => onRemove(concern),
                    child: const Icon(
                      Icons.cancel_rounded,
                      size: 16,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

