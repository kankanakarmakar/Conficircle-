// lib/screens/home/widgets/action_card_grid.dart
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../core/widgets/tactile_card.dart';
import '../../../core/widgets/tactile_button.dart';
import '../../topic/topic_detail_screen.dart';
import '../../../data/mock_topics.dart';

class DiscoveryActionItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final int topicIndex;

  const DiscoveryActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.topicIndex,
  });
}

/// Blueprint §7.1 & §8.4: "Picked for You" / Six Discovery Actions
/// 2-column grid of tactile action cards with "Explore more" coral button.
class ActionCardGrid extends StatefulWidget {
  final bool isFirst;
  const ActionCardGrid({super.key, this.isFirst = false});

  @override
  State<ActionCardGrid> createState() => _ActionCardGridState();
}

class _ActionCardGridState extends State<ActionCardGrid> {
  bool _expanded = false;

  // Initial 6 baseline actions (Blueprint §7.1)
  static const List<DiscoveryActionItem> _primaryActions = [
    DiscoveryActionItem(
      title: 'Explore higher studies & research',
      subtitle: 'Pathways, tests & admissions',
      icon: Icons.school_outlined,
      accentColor: Color(0xFF173883),
      topicIndex: 0,
    ),
    DiscoveryActionItem(
      title: 'Recognize my natural strengths',
      subtitle: 'Audit core competencies',
      icon: Icons.auto_awesome_outlined,
      accentColor: Color(0xFFF2432C),
      topicIndex: 1,
    ),
    DiscoveryActionItem(
      title: 'Become more persuasive',
      subtitle: 'Speaking, pitch & dialogue',
      icon: Icons.record_voice_over_outlined,
      accentColor: Color(0xFF4475D7),
      topicIndex: 2,
    ),
    DiscoveryActionItem(
      title: 'Understand student investing',
      subtitle: 'SIPs, compounding & index funds',
      icon: Icons.trending_up_rounded,
      accentColor: Color(0xFF22A06B),
      topicIndex: 3,
    ),
    DiscoveryActionItem(
      title: 'Understand other people better',
      subtitle: 'Empathy, active listening & trust',
      icon: Icons.people_outline_rounded,
      accentColor: Color(0xFF6B4FD8),
      topicIndex: 0,
    ),
    DiscoveryActionItem(
      title: 'Feel more peaceful in daily life',
      subtitle: 'Stress relief & mental clarity',
      icon: Icons.spa_outlined,
      accentColor: Color(0xFF009688),
      topicIndex: 1,
    ),
  ];

  // Secondary 6 actions revealed on "Explore more" (Blueprint §8.5)
  static const List<DiscoveryActionItem> _secondaryActions = [
    DiscoveryActionItem(
      title: 'Build unshakable confidence',
      subtitle: 'Silencing the inner imposter',
      icon: Icons.shield_outlined,
      accentColor: Color(0xFFF2432C),
      topicIndex: 2,
    ),
    DiscoveryActionItem(
      title: 'Master time & deep focus',
      subtitle: 'Pomodoro cycles & habits',
      icon: Icons.timer_outlined,
      accentColor: Color(0xFF173883),
      topicIndex: 3,
    ),
    DiscoveryActionItem(
      title: 'Overcome fear of failure',
      subtitle: 'Action-first mindset',
      icon: Icons.bolt_rounded,
      accentColor: Color(0xFFFF9600),
      topicIndex: 0,
    ),
    DiscoveryActionItem(
      title: 'Resolve peer conflicts calmly',
      subtitle: 'Constructive dialogue',
      icon: Icons.handshake_outlined,
      accentColor: Color(0xFF4475D7),
      topicIndex: 1,
    ),
    DiscoveryActionItem(
      title: 'Discover my true purpose',
      subtitle: 'Aligning values with impact',
      icon: Icons.explore_outlined,
      accentColor: Color(0xFF6B4FD8),
      topicIndex: 2,
    ),
    DiscoveryActionItem(
      title: 'Lead student initiatives',
      subtitle: 'Influence & team rallying',
      icon: Icons.groups_outlined,
      accentColor: Color(0xFF22A06B),
      topicIndex: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final actions = _expanded
        ? [..._primaryActions, ..._secondaryActions]
        : _primaryActions;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isFirst ? 'Discovery Actions' : 'Picked for You',
                style: AppTypography.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blue,
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                '${actions.length} options',
                style: AppTypography.body(
                  fontSize: 12,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 2-column Tactile Action Cards
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final item = actions[index];
              return TactileCard(
                onTap: () {
                  final topic = allTopics[item.topicIndex % allTopics.length];
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TopicDetailScreen(topic: topic),
                    ),
                  );
                },
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: item.accentColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: item.accentColor.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(item.icon, size: 20, color: item.accentColor),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

          const SizedBox(height: 12),

          // Blueprint §7 order 4 & §8 order 5: "Explore more" — Coral button, no arrow!
          TactileButton(
            label: _expanded ? 'Show Less' : 'Explore more',
            backgroundColor: AppColors.coral,
            shadowColor: const Color(0xFFC02A16),
            onPressed: () {
              setState(() => _expanded = !_expanded);
            },
          ),
        ],
      ),
    );
  }
}
