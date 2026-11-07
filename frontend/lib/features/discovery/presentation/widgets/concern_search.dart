// lib/features/discovery/presentation/widgets/concern_search.dart
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';

class ConcernSearch extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const ConcernSearch({
    super.key,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTypography.body(fontSize: 14, color: AppColors.black),
        decoration: InputDecoration(
          hintText: 'Search challenges or concerns...',
          hintStyle: AppTypography.body(fontSize: 13.5, color: AppColors.darkGrey.withOpacity(0.7)),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.darkGrey, size: 20),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.darkGrey),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

