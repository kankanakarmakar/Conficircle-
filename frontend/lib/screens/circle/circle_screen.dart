// lib/screens/circle/circle_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/mock_groups.dart';
import '../../models/group.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../core/widgets/tactile_card.dart';
import '../../core/widgets/tactile_button.dart';
import 'create_group_screen.dart';
import 'widgets/student_profile_card.dart';

/// Community Hub ([[COMMUNITY_TAB_NAME]], working label: "Circle")
/// Faithful to Duolingo Marvilo Quests & Leaderboard architecture.
class CircleScreen extends StatefulWidget {
  const CircleScreen({super.key});

  @override
  State<CircleScreen> createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Quests & Badges', 'Leaderboard', 'Circles'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Circle',
          style: AppTypography.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.blue,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.blue),
            tooltip: 'Create Circle',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateGroupScreen()),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle: AppTypography.montserrat(fontSize: 13, fontWeight: FontWeight.w800),
          unselectedLabelStyle: AppTypography.montserrat(fontSize: 13, fontWeight: FontWeight.w600),
          labelColor: AppColors.coral,
          unselectedLabelColor: AppColors.darkGrey,
          indicatorColor: AppColors.coral,
          indicatorWeight: 3,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const _QuestsAndBadgesTab(),
          const _LeaderboardTab(),
          _CirclesTab(),
        ],
      ),
    );
  }
}

// ── TAB 1: Quests & Badges (Marvilo Kit) ─────────────────────────────
class _QuestsAndBadgesTab extends StatelessWidget {
  const _QuestsAndBadgesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Daily Quests Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF6B46C1), // Rich purple header matching Duolingo Quests
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF553C9A), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF553C9A),
                offset: Offset(0, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('⚡', style: TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Quests',
                      style: AppTypography.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Complete daily quests to earn bonus ConfiPoints!',
                      style: AppTypography.body(fontSize: 12, color: Colors.white.withOpacity(0.9)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Quests',
              style: AppTypography.montserrat(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.blue),
            ),
            Row(
              children: [
                const Icon(Icons.timer_outlined, size: 14, color: Color(0xFFFF9600)),
                const SizedBox(width: 4),
                Text(
                  'Resets in 4 hours',
                  style: AppTypography.montserrat(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFFFF9600)),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Quest 1
        _QuestCard(
          icon: '⚡',
          title: 'Earn 10 ConfiPoints',
          progress: 0.6,
          progressText: '6 / 10 CP',
          rewardPoints: 10,
          isCompleted: false,
        ),

        const SizedBox(height: 12),

        // Quest 2
        _QuestCard(
          icon: '🎯',
          title: 'Complete 1 Self-Paced Reflection',
          progress: 1.0,
          progressText: '1 / 1 Completed',
          rewardPoints: 15,
          isCompleted: true,
        ),

        const SizedBox(height: 12),

        // Quest 3
        _QuestCard(
          icon: '📚',
          title: 'Explore 2 topics in ConfiZone',
          progress: 0.5,
          progressText: '1 / 2 topics',
          rewardPoints: 20,
          isCompleted: false,
        ),

        const SizedBox(height: 24),

        // Monthly Challenge Section
        Text(
          'Monthly Growth Challenge',
          style: AppTypography.montserrat(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.blue),
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE4E8F0), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFE4E8F0),
                offset: Offset(0, 3.5),
                blurRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0EE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFD5D0), width: 1.5),
                    ),
                    child: const Center(
                      child: Text('🏅', style: TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'November Challenge Badge',
                          style: AppTypography.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.blue,
                          ),
                        ),
                        Text(
                          'Complete 10 activities this month',
                          style: AppTypography.body(fontSize: 12, color: AppColors.darkGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: 0.6,
                  minHeight: 10,
                  backgroundColor: const Color(0xFFE4E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.coral),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '6 / 10 activities completed',
                  style: AppTypography.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuestCard extends StatelessWidget {
  final String icon;
  final String title;
  final double progress;
  final String progressText;
  final int rewardPoints;
  final bool isCompleted;

  const _QuestCard({
    required this.icon,
    required this.title,
    required this.progress,
    required this.progressText,
    required this.rewardPoints,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? const Color(0xFF58CC02) : const Color(0xFFE4E8F0),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isCompleted ? const Color(0xFF46A302) : const Color(0xFFE4E8F0),
            offset: const Offset(0, 3.5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isCompleted ? const Color(0xFFD7FFB8) : const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(isCompleted ? '✓' : icon, style: TextStyle(fontSize: 20, color: isCompleted ? const Color(0xFF2E7D32) : null, fontWeight: FontWeight.w900)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE4E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? const Color(0xFF58CC02) : AppColors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  progressText,
                  style: AppTypography.body(fontSize: 11, color: AppColors.darkGrey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isCompleted ? const Color(0xFFD7FFB8) : const Color(0xFFF0F4FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCompleted ? const Color(0xFF58CC02) : const Color(0xFFD4E1FB),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('💎', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  '+$rewardPoints',
                  style: AppTypography.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: isCompleted ? const Color(0xFF2E7D32) : AppColors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── TAB 2: Leaderboard (Marvilo Kit) ─────────────────────────────────
class _LeaderboardTab extends StatelessWidget {
  const _LeaderboardTab();

  @override
  Widget build(BuildContext context) {
    final students = [
      {'rank': 1, 'name': 'Maya Sharma', 'points': 540, 'initial': 'M', 'color': const Color(0xFFFFD700), 'isMe': false},
      {'rank': 2, 'name': 'Rahul Kapoor', 'points': 480, 'initial': 'R', 'color': const Color(0xFFC0C0C0), 'isMe': false},
      {'rank': 3, 'name': 'Anaya Sharma (You)', 'points': 340, 'initial': 'A', 'color': const Color(0xFFCD7F32), 'isMe': true},
      {'rank': 4, 'name': 'Dev Patel', 'points': 310, 'initial': 'D', 'color': AppColors.blue, 'isMe': false},
      {'rank': 5, 'name': 'Priya Menon', 'points': 290, 'initial': 'P', 'color': AppColors.blue, 'isMe': false},
      {'rank': 6, 'name': 'Siddharth Verma', 'points': 260, 'initial': 'S', 'color': AppColors.blue, 'isMe': false},
      {'rank': 7, 'name': 'Riya Nair', 'points': 240, 'initial': 'R', 'color': AppColors.blue, 'isMe': false},
      {'rank': 8, 'name': 'Karan Joshi', 'points': 210, 'initial': 'K', 'color': AppColors.blue, 'isMe': false},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // League Header Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF0D2254), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF0D2254),
                offset: Offset(0, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🛡️', style: TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Silver Growth League',
                      style: AppTypography.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Top 10 advance to Gold League in 3 days!',
                      style: AppTypography.body(fontSize: 12, color: const Color(0xFFD4E1FB)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Rank list
        ...students.map((s) {
          final isMe = s['isMe'] as bool;
          final rank = s['rank'] as int;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFFF0F4FD) : AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isMe ? AppColors.blue : const Color(0xFFE4E8F0),
                width: isMe ? 2.5 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isMe ? const Color(0xFFD4E1FB) : const Color(0xFFE4E8F0),
                  offset: const Offset(0, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                // Rank number or medal
                SizedBox(
                  width: 32,
                  child: Text(
                    rank == 1 ? '🥇' : (rank == 2 ? '🥈' : (rank == 3 ? '🥉' : '#$rank')),
                    style: AppTypography.montserrat(
                      fontSize: rank <= 3 ? 18 : 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Monogram avatar
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.coral : const Color(0xFFE4E8F0),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      s['initial'] as String,
                      style: AppTypography.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isMe ? Colors.white : AppColors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name
                Expanded(
                  child: Text(
                    s['name'] as String,
                    style: AppTypography.montserrat(
                      fontSize: 13,
                      fontWeight: isMe ? FontWeight.w900 : FontWeight.w700,
                      color: isMe ? AppColors.blue : const Color(0xFF2D3748),
                    ),
                  ),
                ),

                // Points pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE4E8F0), width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('💎', style: TextStyle(fontSize: 11)),
                      const SizedBox(width: 4),
                      Text(
                        '${s['points']} CP',
                        style: AppTypography.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}

// ── TAB 3: Circles ───────────────────────────────────────────────────
class _CirclesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: publicGroups.length,
      itemBuilder: (_, i) => _GroupCard(group: publicGroups[i]),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final Group group;
  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return TactileCard(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.groups_rounded, color: AppColors.blue, size: 24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: AppTypography.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blue,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${group.memberCount} students · Active discussions',
                      style: AppTypography.body(fontSize: 11, color: AppColors.darkGrey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.coral,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFC02A16),
                      offset: Offset(0, 2.5),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Text(
                  'JOIN',
                  style: AppTypography.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            group.description,
            style: AppTypography.body(fontSize: 12, color: AppColors.darkGrey, height: 1.35),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
