// lib/screens/resources/widgets/resource_card.dart
import 'package:flutter/material.dart';
import '../../../models/resource.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../resource_detail_screen.dart';

class ResourceCard extends StatefulWidget {
  final Resource resource;
  final VoidCallback? onSaveToggle;

  const ResourceCard({
    super.key,
    required this.resource,
    this.onSaveToggle,
  });

  @override
  State<ResourceCard> createState() => _ResourceCardState();
}

class _ResourceCardState extends State<ResourceCard> {
  static const Map<String, Color> _categoryColors = {
    'Career': AppColors.blue,
    'Finance': Color(0xFF27AE60),
    'Communication': AppColors.coral,
    'Social': AppColors.lightBlue,
    'Wellbeing': Color(0xFF16A085),
    'Productivity': Color(0xFFE67E22),
    'Self': AppColors.blue,
    'Leadership': Color(0xFF8E44AD),
  };

  @override
  Widget build(BuildContext context) {
    final r = widget.resource;
    final color = _categoryColors[r.category] ?? AppColors.blue;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResourceDetailScreen(resource: r),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Type icon block
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(r.typeEmoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      r.category,
                      style: AppTypography.montserrat(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    r.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelLarge.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        r.typeLabel,
                        style: AppTypography.bodySmall.copyWith(color: color),
                      ),
                      const Text(' · ',
                          style: TextStyle(color: AppColors.darkGrey)),
                      if (r.duration != null)
                        Text(r.duration!, style: AppTypography.bodySmall),
                    ],
                  ),
                ],
              ),
            ),

            // Bookmark
            GestureDetector(
              onTap: () {
                setState(() => r.isSaved = !r.isSaved);
                widget.onSaveToggle?.call();
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  r.isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_outline_rounded,
                  key: ValueKey(r.isSaved),
                  color: r.isSaved ? AppColors.coral : AppColors.darkGrey,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
