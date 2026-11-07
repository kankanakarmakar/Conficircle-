// lib/screens/circle/group_detail_screen.dart
import 'package:flutter/material.dart';
import '../../models/group.dart';
import '../../data/mock_groups.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'widgets/student_profile_card.dart';

class GroupDetailScreen extends StatefulWidget {
  final Group group;

  const GroupDetailScreen({super.key, required this.group});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isJoined = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _isJoined = widget.group.isJoined;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.group;

    return Scaffold(
      backgroundColor: AppColors.softGrey,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.blue,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_rounded, color: Colors.white),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F2459), Color(0xFF2258C5)],
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
                        Text(g.emoji,
                            style: const TextStyle(fontSize: 40)),
                        const SizedBox(height: 8),
                        Text(
                          g.name,
                          style: AppTypography.headingSmall.copyWith(
                            color: AppColors.white,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${g.memberCount} members · ${g.category}',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppColors.coral,
              unselectedLabelColor: Colors.white70,
              indicatorColor: AppColors.coral,
              indicatorWeight: 3,
              labelStyle: AppTypography.montserrat(
                  fontSize: 13, fontWeight: FontWeight.w700),
              unselectedLabelStyle: AppTypography.montserrat(
                  fontSize: 13, fontWeight: FontWeight.w500),
              tabs: const [
                Tab(text: 'About'),
                Tab(text: 'Members'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _AboutTab(group: g, isJoined: _isJoined,
              onToggleJoin: () => setState(() => _isJoined = !_isJoined)),
            _MembersTab(students: sampleStudents),
          ],
        ),
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  final Group group;
  final bool isJoined;
  final VoidCallback onToggleJoin;

  const _AboutTab({
    required this.group,
    required this.isJoined,
    required this.onToggleJoin,
  });

  @override
  Widget build(BuildContext context) {
    final g = group;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Description card
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('About', style: AppTypography.labelLarge),
              const SizedBox(height: 10),
              Text(g.description, style: AppTypography.bodyLarge),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: g.tags
                    .map((t) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.blue.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.blue.withOpacity(0.2)),
                          ),
                          child: Text(
                            '#$t',
                            style: AppTypography.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blue,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),

        // Stats card
        _Card(
          child: Row(
            children: [
              _StatItem(
                  label: 'Members',
                  value: '${g.memberCount}',
                  emoji: '👥'),
              _StatItem(
                  label: 'Category',
                  value: g.category,
                  emoji: '📌'),
              _StatItem(
                  label: 'Type',
                  value: g.type == GroupType.public
                      ? 'Public'
                      : 'Private',
                  emoji: g.type == GroupType.public ? '🌐' : '🔒'),
            ],
          ),
        ),

        // Join CTA
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: isJoined
              ? OutlinedButton.icon(
                  onPressed: onToggleJoin,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Joined ✓'),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: onToggleJoin,
                  child: const Text('Join This Circle'),
                ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _MembersTab extends StatelessWidget {
  final List<StudentCard> students;

  const _MembersTab({required this.students});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: students.length,
      itemBuilder: (_, i) => StudentProfileCard(student: students[i]),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value, emoji;

  const _StatItem({
    required this.label,
    required this.value,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          Text(label,
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
