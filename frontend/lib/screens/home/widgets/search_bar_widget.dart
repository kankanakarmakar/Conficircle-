// lib/screens/home/widgets/search_bar_widget.dart
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;

  const SearchBarWidget({
    super.key,
    this.hintText = 'What are you looking for today?',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE4E8F0), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFE4E8F0),
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: AppColors.blue, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hintText,
                  style: AppTypography.body(
                    fontSize: 13,
                    color: AppColors.darkGrey,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.softGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.tune_rounded, size: 14, color: AppColors.darkGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
