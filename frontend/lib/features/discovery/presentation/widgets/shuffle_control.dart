// lib/features/discovery/presentation/widgets/shuffle_control.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';

class ShuffleControl extends StatelessWidget {
  final VoidCallback onShuffle;
  final bool isShuffling;

  const ShuffleControl({
    super.key,
    required this.onShuffle,
    this.isShuffling = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isShuffling ? null : onShuffle,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            decoration: BoxDecoration(
              color: isShuffling
                  ? Colors.white.withOpacity(0.5)
                  : Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isShuffling
                    ? AppColors.lightGrey
                    : AppColors.coral.withOpacity(0.4),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.coral.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isShuffling) ...[
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.coral),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Shuffling...',
                    style: AppTypography.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.coral,
                    ),
                  ),
                ] else ...[
                  const Icon(Icons.shuffle_rounded, size: 14, color: AppColors.coral),
                  const SizedBox(width: 5),
                  Text(
                    'Shuffle',
                    style: AppTypography.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.coral,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
