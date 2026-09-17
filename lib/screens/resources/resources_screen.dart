// lib/screens/resources/resources_screen.dart
import 'package:flutter/material.dart';
import '../../data/mock_resources.dart';
import '../../models/resource.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'contribute_resource_screen.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final _searchCtrl = TextEditingController();
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Articles', 'Videos', 'Guides', 'Templates'];

  List<Resource> get _filtered {
    List<Resource> list = allResources;
    if (_searchCtrl.text.isNotEmpty) {
      list = list.where((r) =>
        r.title.toLowerCase().contains(_searchCtrl.text.toLowerCase()) ||
        r.tags.any((t) => t.toLowerCase().contains(_searchCtrl.text.toLowerCase()))
      ).toList();
    }
    if (_selectedFilter != 'All') {
      final typeMap = {
        'Articles': ResourceType.article,
        'Videos': ResourceType.video,
        'Guides': ResourceType.guide,
        'Templates': ResourceType.template,
      };
      final type = typeMap[_selectedFilter];
      if (type != null) list = list.where((r) => r.type == type).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Resources', style: AppTypography.headingSmall),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              icon: const Icon(Icons.add_circle_outline, color: AppColors.success),
              label: Text(
                'Contribute',
                style: AppTypography.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ContributeResourceScreen(),
                  ),
                );
                if (result != null && result is Resource) {
                  // Optionally refresh or show confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Resource added successfully!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search + filters
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search articles, videos, guides...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.blue, size: 20),
                    filled: true,
                    fillColor: AppColors.softGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemCount: _filters.length,
                    itemBuilder: (_, i) {
                      final f = _filters[i];
                      final isActive = f == _selectedFilter;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedFilter = f),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.blue : AppColors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: isActive ? AppColors.blue : AppColors.lightGrey),
                          ),
                          child: Text(f,
                              style: AppTypography.montserrat(
                                fontSize: 12, fontWeight: FontWeight.w600,
                                color: isActive ? AppColors.white : AppColors.darkGrey,
                              )),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Resource list
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🔍', style: TextStyle(fontSize: 40)),
                        const SizedBox(height: 12),
                        Text('No results found', style: AppTypography.headingSmall),
                        const SizedBox(height: 6),
                        Text('Try a different search term', style: AppTypography.bodyMedium),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _ResourceCard(resource: _filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatefulWidget {
  final Resource resource;
  const _ResourceCard({required this.resource});

  @override
  State<_ResourceCard> createState() => _ResourceCardState();
}

class _ResourceCardState extends State<_ResourceCard> {
  @override
  Widget build(BuildContext context) {
    final r = widget.resource;
    final categoryColors = {
      'Career': AppColors.blue,
      'Finance': const Color(0xFF27AE60),
      'Communication': AppColors.coral,
      'Social': AppColors.lightBlue,
      'Wellbeing': const Color(0xFF16A085),
      'Productivity': const Color(0xFFE67E22),
      'Self': AppColors.blue,
    };
    final color = categoryColors[r.category] ?? AppColors.blue;

    return GestureDetector(
      onTap: () {},
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
                    child: Text(r.category,
                        style: AppTypography.montserrat(
                          fontSize: 9, fontWeight: FontWeight.w700, color: color,
                        )),
                  ),
                  const SizedBox(height: 5),
                  Text(r.title,
                      maxLines: 2,
                      style: AppTypography.labelLarge.copyWith(fontSize: 14)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(r.typeLabel, style: AppTypography.bodySmall.copyWith(color: color)),
                      const Text(' · ', style: TextStyle(color: AppColors.darkGrey)),
                      Text(r.duration ?? '', style: AppTypography.bodySmall),
                    ],
                  ),
                ],
              ),
            ),

            // Bookmark
            GestureDetector(
              onTap: () => setState(() => r.isSaved = !r.isSaved),
              child: Icon(
                r.isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                color: r.isSaved ? AppColors.coral : AppColors.darkGrey,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
