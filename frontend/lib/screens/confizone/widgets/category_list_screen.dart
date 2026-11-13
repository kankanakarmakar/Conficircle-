// lib/screens/confizone/widgets/category_list_screen.dart
import 'package:flutter/material.dart';
import '../../../../data/taxonomy_data.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import 'node_detail_screen.dart';

/// Level 2 Category View (SC-022)
/// Shows categories and nodes within an area with non-linear filterable exploration
class CategoryListScreen extends StatefulWidget {
  final TaxonomyArea area;

  const CategoryListScreen({super.key, required this.area});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  NodeStatus? _selectedStatusFilter; // null = All

  @override
  Widget build(BuildContext context) {
    final area = widget.area;

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
          area.title,
          style: AppTypography.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.blue,
          ),
        ),
        centerTitle: false,
      ),
      body: CustomScrollView(
        slivers: [
          // Area Header Card
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.white,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    area.description,
                    style: AppTypography.body(fontSize: 13, color: AppColors.darkGrey),
                  ),
                  const SizedBox(height: 14),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All (${area.totalNodes})',
                          isSelected: _selectedStatusFilter == null,
                          onTap: () => setState(() => _selectedStatusFilter = null),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'In Progress',
                          isSelected: _selectedStatusFilter == NodeStatus.inProgress,
                          onTap: () => setState(() => _selectedStatusFilter = NodeStatus.inProgress),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Not Started',
                          isSelected: _selectedStatusFilter == NodeStatus.notStarted,
                          onTap: () => setState(() => _selectedStatusFilter = NodeStatus.notStarted),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Completed',
                          isSelected: _selectedStatusFilter == NodeStatus.completed,
                          onTap: () => setState(() => _selectedStatusFilter = NodeStatus.completed),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Categories & Nodes List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = area.categories[index];
                  final nodes = _selectedStatusFilter == null
                      ? category.nodes
                      : category.nodes.where((n) => n.status == _selectedStatusFilter).toList();

                  if (nodes.isEmpty) return const SizedBox.shrink();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Header
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 8),
                          child: Row(
                            children: [
                              Text(
                                category.title,
                                style: AppTypography.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.blue,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${nodes.length}',
                                  style: AppTypography.montserrat(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Nodes Column
                        ...nodes.map((node) => _NodeItemCard(
                          node: node,
                          categoryTitle: category.title,
                        )),
                      ],
                    ),
                  );
                },
                childCount: area.categories.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue : AppColors.softGrey,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.blue : AppColors.lightGrey,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.montserrat(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.white : AppColors.darkGrey,
          ),
        ),
      ),
    );
  }
}

class _NodeItemCard extends StatelessWidget {
  final TaxonomyNode node;
  final String categoryTitle;

  const _NodeItemCard({
    required this.node,
    required this.categoryTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => NodeDetailScreen(
                  node: node,
                  categoryTitle: categoryTitle,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        node.title,
                        style: AppTypography.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _MiniStatusBadge(status: node.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  node.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.body(fontSize: 12, color: AppColors.darkGrey),
                ),
                if (node.status != NodeStatus.notStarted) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: node.progress,
                            minHeight: 4,
                            backgroundColor: AppColors.lightGrey,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              node.status == NodeStatus.completed
                                  ? AppColors.success
                                  : AppColors.coral,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(node.progress * 100).toInt()}%',
                        style: AppTypography.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniStatusBadge extends StatelessWidget {
  final NodeStatus status;
  const _MiniStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == NodeStatus.completed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Done',
          style: AppTypography.montserrat(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.success),
        ),
      );
    }
    if (status == NodeStatus.inProgress) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.coral.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Active',
          style: AppTypography.montserrat(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.coral),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

