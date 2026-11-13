// lib/screens/home/widgets/explore_areas_grid.dart
import 'package:flutter/material.dart';
import '../../../data/taxonomy_data.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../core/widgets/tactile_card.dart';
import '../../confizone/widgets/category_list_screen.dart';

/// Blueprint §7.8 & §8.12: "Explore Life Journey"
/// 4 outer Level 1 pillar cards displayed in a tactile 2x2 grid.
class ExploreAreasGrid extends StatelessWidget {
  const ExploreAreasGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final areas = TaxonomyData.areas;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Explore Life Journey',
                style: AppTypography.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blue,
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                '4 Pillars',
                style: AppTypography.body(
                  fontSize: 12,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: areas.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.25,
            ),
            itemBuilder: (context, index) {
              final area = areas[index];
              return TactileCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CategoryListScreen(area: area),
                    ),
                  );
                },
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: area.accentColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: area.accentColor.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(area.icon, size: 20, color: area.accentColor),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.softGrey,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${area.categories.length}',
                            style: AppTypography.montserrat(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          area.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.blue,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${area.totalNodes} focus topics',
                          style: AppTypography.body(
                            fontSize: 10,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
