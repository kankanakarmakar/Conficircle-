// lib/screens/confizone/confizone_main_screen.dart
import 'package:flutter/material.dart';
import '../../data/taxonomy_data.dart';
import '../../data/mock_resources.dart';
import '../../data/mock_topics.dart';
import '../../models/resource.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../resources/resource_detail_screen.dart';
import '../resources/resources_screen.dart';
import '../topic/topic_detail_screen.dart';
import 'widgets/category_list_screen.dart';
import 'widgets/gateway_bottom_sheet.dart';

/// ConfiZone Screen ([[ACTION_HUB_NAME]]) - Choose what to do (SC-020)
/// Includes the full taxonomy browser, the Gateway panel, and the Resources library (OD-01).
class ConfiZoneMainScreen extends StatefulWidget {
  const ConfiZoneMainScreen({super.key});

  @override
  State<ConfiZoneMainScreen> createState() => _ConfiZoneMainScreenState();
}

class _ConfiZoneMainScreenState extends State<ConfiZoneMainScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final areas = TaxonomyData.areas;

    return Scaffold(
      backgroundColor: AppColors.softGrey,
      body: CustomScrollView(
        slivers: [
          // Pinned App Bar with Title & Search
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.white,
            title: Text(
              'ConfiZone',
              style: AppTypography.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.blue,
              ),
            ),
            centerTitle: false,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
                  style: AppTypography.body(fontSize: 14, color: AppColors.black),
                  decoration: InputDecoration(
                    hintText: 'Search skills, topics, or resources...',
                    hintStyle: AppTypography.body(fontSize: 13, color: AppColors.darkGrey),
                    prefixIcon: const Icon(Icons.search, color: AppColors.blue, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: AppColors.darkGrey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.softGrey,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: AppColors.lightGrey, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: AppColors.lightGrey, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Gateway Banner: "Not sure where to start?"
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.lightGrey, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.coral.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.help_outline_rounded, color: AppColors.coral, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Not sure where to start?',
                          style: AppTypography.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blue,
                          ),
                        ),
                        Text(
                          'Let us guide you to the right focus area',
                          style: AppTypography.body(fontSize: 11, color: AppColors.darkGrey),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => GatewayBottomSheet.show(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Guide Me',
                          style: AppTypography.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.coral,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.coral),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── SECTION 1: BROWSE BY AREA (Level 1) ────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Browse by Area',
                    style: AppTypography.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                  Text(
                    '4 core pillars',
                    style: AppTypography.body(fontSize: 12, color: AppColors.darkGrey),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final area = areas[index];
                  return _AreaCard(area: area);
                },
                childCount: areas.length,
              ),
            ),
          ),

          // ── SECTION 2: RESOURCES LIBRARY (OD-01 Resolution) ───────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Resources Library',
                        style: AppTypography.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blue,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Library',
                          style: AppTypography.montserrat(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.darkGrey),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ResourcesScreen()),
                      );
                    },
                    child: Text(
                      'See All →',
                      style: AppTypography.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coral,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 140,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: allResources.take(5).length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final resource = allResources[index];
                  return _ResourceCard(
                    resource: resource,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ResourceDetailScreen(resource: resource),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // ── SECTION 3: POPULAR TOPICS ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
              child: Text(
                'Explore Featured Topics',
                style: AppTypography.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final topic = allTopics[index % allTopics.length];
                  return _TopicTile(
                    topic: topic,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TopicDetailScreen(topic: topic),
                        ),
                      );
                    },
                  );
                },
                childCount: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AreaCard extends StatelessWidget {
  final TaxonomyArea area;

  const _AreaCard({required this.area});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CategoryListScreen(area: area),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: area.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(area.icon, color: area.accentColor, size: 20),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.darkGrey),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      area.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${area.categories.length} categories · ${area.totalNodes} topics',
                      style: AppTypography.body(fontSize: 10, color: AppColors.darkGrey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final Resource resource;
  final VoidCallback onTap;

  const _ResourceCard({required this.resource, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightGrey, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        resource.category,
                        style: AppTypography.montserrat(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.lightBlue,
                        ),
                      ),
                    ),
                    Text(
                      resource.duration ?? '',
                      style: AppTypography.body(fontSize: 10, color: AppColors.darkGrey),
                    ),
                  ],
                ),
                Text(
                  resource.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.bookmark_outline_rounded, size: 14, color: AppColors.coral),
                    const SizedBox(width: 4),
                    Text(
                      'Read resource',
                      style: AppTypography.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coral,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  final AppTopic topic;
  final VoidCallback onTap;

  const _TopicTile({required this.topic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightGrey, width: 1),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.softGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(topic.emoji, style: const TextStyle(fontSize: 20)),
        ),
        title: Text(
          topic.title,
          style: AppTypography.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        subtitle: Text(
          topic.subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.body(fontSize: 11, color: AppColors.darkGrey),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.darkGrey),
      ),
    );
  }
}
