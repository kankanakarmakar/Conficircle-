// lib/screens/action_detail/action_detail_screen.dart
import 'package:flutter/material.dart';
import '../../models/action_item.dart';
import '../../data/mock_resources.dart';
import '../../models/resource.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class ActionDetailScreen extends StatelessWidget {
  final ActionItem action;
  const ActionDetailScreen({super.key, required this.action});

  Color _color() {
    try {
      final hex = action.colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppColors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    final relatedResources = allResources
        .where((r) => action.tags.any((t) => r.tags.contains(t)))
        .take(3)
        .toList();
    if (relatedResources.isEmpty) {
      relatedResources.addAll(allResources.take(3));
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(action.emoji, style: const TextStyle(fontSize: 60)),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          action.text,
                          textAlign: TextAlign.center,
                          style: AppTypography.headingSmall.copyWith(color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick start options
                  Text('Start here', style: AppTypography.headingSmall),
                  const SizedBox(height: 16),

                  _ActionOptionCard(
                    icon: Icons.quiz_outlined,
                    color: AppColors.coral,
                    title: 'Quick Assessment',
                    desc: 'See where you stand on this topic in just 5 minutes.',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _ActionOptionCard(
                    icon: Icons.lightbulb_outline_rounded,
                    color: AppColors.blue,
                    title: 'Quick Tip',
                    desc: 'Get one practical insight you can use right now.',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _ActionOptionCard(
                    icon: Icons.explore_outlined,
                    color: const Color(0xFF27AE60),
                    title: 'Explore ConfiZone',
                    desc: 'Find programs, webinars and more on this topic.',
                    onTap: () => Navigator.pop(context),
                  ),

                  const SizedBox(height: 28),
                  // Resources
                  Text('Resources for you', style: AppTypography.headingSmall),
                  const SizedBox(height: 16),
                  ...relatedResources.map((r) => _ResourceListItem(resource: r)),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionOptionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, desc;
  final VoidCallback onTap;

  const _ActionOptionCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.desc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: AppColors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.labelLarge.copyWith(color: color)),
                  const SizedBox(height: 3),
                  Text(desc, style: AppTypography.bodySmall),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}

class _ResourceListItem extends StatelessWidget {
  final Resource resource;
  const _ResourceListItem({required this.resource});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        children: [
          Text(resource.typeEmoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(resource.title,
                    maxLines: 2,
                    style: AppTypography.labelLarge.copyWith(fontSize: 13)),
                const SizedBox(height: 2),
                Text(resource.duration ?? '',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.coral)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.darkGrey),
        ],
      ),
    );
  }
}
