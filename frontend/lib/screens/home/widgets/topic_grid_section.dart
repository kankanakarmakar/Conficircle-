// lib/screens/home/widgets/topic_grid_section.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../data/mock_topics.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../topic/topic_detail_screen.dart';

class TopicGridSection extends StatefulWidget {
  const TopicGridSection({super.key});

  @override
  State<TopicGridSection> createState() => _TopicGridSectionState();
}

class _TopicGridSectionState extends State<TopicGridSection> {
  late List<AppTopic> _shown;

  @override
  void initState() {
    super.initState();
    _shuffle();
  }

  void _shuffle() {
    final shuffled = List<AppTopic>.from(allTopics)..shuffle(Random());
    _shown = shuffled.take(6).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Explore Topics',
                  style: AppTypography.montserrat(
                    fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.blue,
                  )),
              GestureDetector(
                onTap: () => setState(_shuffle),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.softGrey,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: AppColors.lightGrey),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shuffle_rounded, size: 13, color: AppColors.coral),
                      const SizedBox(width: 4),
                      Text('Shuffle',
                          style: AppTypography.montserrat(
                            fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.coral,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Tap any topic to explore tips, take a quiz & discover resources',
              style: AppTypography.bodySmall.copyWith(fontSize: 11)),
          const SizedBox(height: 16),

          // 2×3 grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.85,
            ),
            itemCount: _shown.length,
            itemBuilder: (context, i) => _TopicCard(topic: _shown[i]),
          ),
        ],
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final AppTopic topic;
  const _TopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    final color = Color(topic.colorHex);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TopicDetailScreen(topic: topic)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(topic.emoji, style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 8),
            Text(
              topic.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.montserrat(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text('Explore →',
                  style: AppTypography.montserrat(
                    fontSize: 8.5, fontWeight: FontWeight.w700, color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
