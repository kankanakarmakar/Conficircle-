// lib/screens/home/widgets/focus_area_card.dart
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class FocusAreaItem {
  final String title;
  final String category;
  final double progress;
  final Color accentColor;

  const FocusAreaItem({
    required this.title,
    required this.category,
    required this.progress,
    required this.accentColor,
  });
}

class FocusAreaSection extends StatelessWidget {
  final ValueChanged<FocusAreaItem>? onSelectArea;

  const FocusAreaSection({
    super.key,
    this.onSelectArea,
  });

  static const List<FocusAreaItem> sampleItems = [
    FocusAreaItem(
      title: 'Improving Confidence',
      category: 'BUILD STRONGER ME',
      progress: 0.70,
      accentColor: AppColors.coral,
    ),
    FocusAreaItem(
      title: 'Career Exploration',
      category: 'MY FUTURE',
      progress: 0.45,
      accentColor: AppColors.blue,
    ),
    FocusAreaItem(
      title: 'Communication Skills',
      category: 'MY SKILLS',
      progress: 0.80,
      accentColor: AppColors.lightBlue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Focus Areas',
                style: AppTypography.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
              Text(
                'Self-directed',
                style: AppTypography.body(
                  fontSize: 12,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 124,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: sampleItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = sampleItems[index];
              return _FocusAreaCard(
                item: item,
                onTap: () => onSelectArea?.call(item),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FocusAreaCard extends StatelessWidget {
  final FocusAreaItem item;
  final VoidCallback? onTap;

  const _FocusAreaCard({
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final int percent = (item.progress * 100).toInt();

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top row: category label & progress ring
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.softGrey,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.category,
                        style: AppTypography.montserrat(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blue,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: item.progress,
                            strokeWidth: 3,
                            backgroundColor: AppColors.lightGrey,
                            valueColor: AlwaysStoppedAnimation<Color>(item.accentColor),
                          ),
                          Text(
                            '$percent%',
                            style: AppTypography.montserrat(
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              color: AppColors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Center title
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),

                // Bottom CTA link
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Continue',
                      style: AppTypography.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coral,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 12,
                      color: AppColors.coral,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
