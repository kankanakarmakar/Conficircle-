// lib/screens/resources/resource_detail_screen.dart
import 'package:flutter/material.dart';
import '../../models/resource.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class ResourceDetailScreen extends StatefulWidget {
  final Resource resource;

  const ResourceDetailScreen({super.key, required this.resource});

  @override
  State<ResourceDetailScreen> createState() => _ResourceDetailScreenState();
}

class _ResourceDetailScreenState extends State<ResourceDetailScreen> {
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

    return Scaffold(
      backgroundColor: AppColors.softGrey,
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  r.isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_outline_rounded,
                  color: Colors.white,
                ),
                onPressed: () => setState(() => r.isSaved = !r.isSaved),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(r.typeEmoji,
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 4),
                              Text(
                                r.typeLabel,
                                style: AppTypography.montserrat(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          r.title,
                          style: AppTypography.headingSmall.copyWith(
                            color: AppColors.white,
                            fontSize: 20,
                          ),
                        ),
                        if (r.author != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            'by ${r.author}',
                            style: AppTypography.bodySmall.copyWith(
                                color: Colors.white70),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Body content
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Meta row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _MetaChip(
                          icon: Icons.category_outlined, label: r.category),
                      const SizedBox(width: 8),
                      if (r.duration != null)
                        _MetaChip(
                            icon: Icons.access_time_rounded,
                            label: r.duration!),
                      const SizedBox(width: 8),
                      _MetaChip(
                          icon: Icons.star_rounded,
                          label: '${r.popularity} views',
                          color: AppColors.warning),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Description
                _DetailCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('About this resource',
                          style: AppTypography.labelLarge),
                      const SizedBox(height: 10),
                      Text(r.description, style: AppTypography.bodyLarge),
                    ],
                  ),
                ),

                // Tags
                if (r.tags.isNotEmpty) ...[
                  _DetailCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Topics', style: AppTypography.labelLarge),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: r.tags
                              .map((t) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: color.withOpacity(0.2)),
                                    ),
                                    child: Text(
                                      '#$t',
                                      style: AppTypography.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: color,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],

                // What you'll learn (simulated)
                _DetailCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('What you\'ll learn', style: AppTypography.labelLarge),
                      const SizedBox(height: 12),
                      ..._getLearningPoints(r).map((point) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  margin: const EdgeInsets.only(top: 2),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.check_rounded,
                                      size: 12, color: color),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child:
                                      Text(point, style: AppTypography.bodyLarge),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),

                // CTA
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        _getCtaLabel(r.type),
                        style: AppTypography.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getLearningPoints(Resource r) {
    return [
      'Practical techniques you can apply immediately',
      'Real examples from student journeys',
      'Build confidence in ${r.category.toLowerCase()}',
      'Actionable steps to track your progress',
    ];
  }

  String _getCtaLabel(ResourceType type) {
    switch (type) {
      case ResourceType.video:
        return 'Watch Now';
      case ResourceType.article:
        return 'Read Article';
      case ResourceType.guide:
        return 'Open Guide';
      case ResourceType.template:
        return 'Use Template';
      case ResourceType.framework:
        return 'Explore Framework';
      case ResourceType.presentation:
        return 'View Presentation';
    }
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _MetaChip({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.darkGrey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: c),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: c,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final Widget child;

  const _DetailCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
