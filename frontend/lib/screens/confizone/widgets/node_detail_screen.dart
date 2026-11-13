// lib/screens/confizone/widgets/node_detail_screen.dart
import 'package:flutter/material.dart';
import '../../../../data/taxonomy_data.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';

/// Level 3 Node View (SC-023)
/// Detailed capability view with Overview, Activities, and Resources tabs
class NodeDetailScreen extends StatefulWidget {
  final TaxonomyNode node;
  final String categoryTitle;

  const NodeDetailScreen({
    super.key,
    required this.node,
    required this.categoryTitle,
  });

  @override
  State<NodeDetailScreen> createState() => _NodeDetailScreenState();
}

class _NodeDetailScreenState extends State<NodeDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSaved = false;

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
    final node = widget.node;

    return Scaffold(
      backgroundColor: AppColors.softGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.blue, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.categoryTitle,
          style: AppTypography.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
              color: _isSaved ? AppColors.coral : AppColors.darkGrey,
            ),
            onPressed: () {
              setState(() => _isSaved = !_isSaved);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isSaved ? 'Saved to bookmarks' : 'Removed from bookmarks'),
                  duration: const Duration(seconds: 1),
                  backgroundColor: AppColors.blue,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Card
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatusBadge(status: node.status),
                    Text(
                      '${(node.progress * 100).toInt()}% Complete',
                      style: AppTypography.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  node.title,
                  style: AppTypography.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  node.summary,
                  style: AppTypography.body(
                    fontSize: 14,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 14),
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: node.progress,
                    minHeight: 6,
                    backgroundColor: AppColors.lightGrey,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.coral),
                  ),
                ),
                const SizedBox(height: 16),
                // Primary CTA
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.coral,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Starting focused exercise...'),
                          backgroundColor: AppColors.coral,
                        ),
                      );
                    },
                    child: Text(
                      node.status == NodeStatus.notStarted ? 'Start Focus Module' : 'Continue Practise',
                      style: AppTypography.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            color: AppColors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.coral,
              unselectedLabelColor: AppColors.darkGrey,
              indicatorColor: AppColors.coral,
              indicatorWeight: 3,
              labelStyle: AppTypography.montserrat(fontSize: 13, fontWeight: FontWeight.w700),
              unselectedLabelStyle: AppTypography.montserrat(fontSize: 13, fontWeight: FontWeight.w500),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Activities'),
                Tab(text: 'Resources'),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _OverviewTab(node: node),
                _ActivitiesTab(),
                _ResourcesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final NodeStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case NodeStatus.completed:
        bg = AppColors.success.withOpacity(0.12);
        fg = AppColors.success;
        label = 'Completed';
        break;
      case NodeStatus.inProgress:
        bg = AppColors.coral.withOpacity(0.12);
        fg = AppColors.coral;
        label = 'In Progress';
        break;
      case NodeStatus.notStarted:
        bg = AppColors.softGrey;
        fg = AppColors.darkGrey;
        label = 'Not Started';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTypography.montserrat(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final TaxonomyNode node;
  const _OverviewTab({required this.node});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionCard(
          title: 'Core Concept',
          child: Text(
            'This capability focuses on concrete real-world habits. Rather than passive theory, you build active micro-competencies that compound over time.',
            style: AppTypography.body(fontSize: 14, color: AppColors.darkGrey),
          ),
        ),
        const SizedBox(height: 12),
        if (node.sampleQuestions.isNotEmpty) ...[
          _SectionCard(
            title: 'Diagnostic Reflection',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: node.sampleQuestions.map((q) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: AppColors.coral, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        q,
                        style: AppTypography.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 12),
        ],
        _SectionCard(
          title: 'Stage Capabilities',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _StageChip(label: 'Discover', color: AppColors.blue),
              _StageChip(label: 'Understand', color: AppColors.lightBlue),
              _StageChip(label: 'Practise', color: AppColors.coral),
              _StageChip(label: 'Advance', color: AppColors.success),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivitiesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _ActivityTile(
          icon: Icons.play_circle_outline_rounded,
          type: 'Video Breakdown',
          title: 'Practical Foundations & Frameworks',
          duration: '4 mins',
        ),
        SizedBox(height: 10),
        _ActivityTile(
          icon: Icons.quiz_outlined,
          type: 'Quick Check-in',
          title: 'Self-Reflection Scenario Quiz',
          duration: '3 mins',
        ),
        SizedBox(height: 10),
        _ActivityTile(
          icon: Icons.edit_note_rounded,
          type: 'Micro-Action',
          title: '3-Step Daily Implementation Journal',
          duration: '5 mins',
        ),
      ],
    );
  }
}

class _ResourcesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _ActivityTile(
          icon: Icons.menu_book_outlined,
          type: 'Reading & Template',
          title: 'Handout: Tactical Framework Summary (PDF)',
          duration: '2 pages',
        ),
        SizedBox(height: 10),
        _ActivityTile(
          icon: Icons.link_rounded,
          type: 'Recommended Reference',
          title: 'Curated Alumni Case Study',
          duration: 'External',
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _StageChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StageChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: AppTypography.montserrat(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String type;
  final String title;
  final String duration;

  const _ActivityTile({
    required this.icon,
    required this.type,
    required this.title,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightGrey, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.softGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.blue, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: AppTypography.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coral,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            duration,
            style: AppTypography.body(fontSize: 11, color: AppColors.darkGrey),
          ),
        ],
      ),
    );
  }
}

