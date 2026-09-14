// lib/screens/confizone/confizone_main_screen.dart
import 'package:flutter/material.dart';
import '../../data/mock_programs.dart';
import '../../models/program.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'widgets/confizone_section_widget.dart';

class ConfiZoneMainScreen extends StatefulWidget {
  const ConfiZoneMainScreen({super.key});

  @override
  State<ConfiZoneMainScreen> createState() => _ConfiZoneMainScreenState();
}

class _ConfiZoneMainScreenState extends State<ConfiZoneMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  final List<String> _tabLabels = ['Essentials', 'Programs', 'Advanced'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.white,
            elevation: 0,
            title: Text('ConfiZone', style: AppTypography.headingSmall),
            centerTitle: false,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(116),
              child: Column(
                children: [
                  // Fixed search bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: TextField(
                      controller: _searchController,
                      style: AppTypography.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'What would you like to do?',
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
                  ),
                  // Not sure gateway (compact)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.softGrey,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.lightGrey),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Not sure what you\'re looking for?',
                              style: AppTypography.montserrat(
                                fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.blue,
                              )),
                        ),
                        const SizedBox(width: 8),
                        _GatewayButton(
                          label: 'Take My Confi',
                          color: AppColors.blue,
                          onTap: () {},
                        ),
                        const SizedBox(width: 6),
                        _GatewayButton(
                          label: 'Explore',
                          color: AppColors.coral,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  // Tab bar
                  TabBar(
                    controller: _tabController,
                    labelStyle: AppTypography.montserrat(fontSize: 13, fontWeight: FontWeight.w700),
                    unselectedLabelStyle: AppTypography.montserrat(fontSize: 13, fontWeight: FontWeight.w500),
                    labelColor: AppColors.coral,
                    unselectedLabelColor: AppColors.darkGrey,
                    indicatorColor: AppColors.coral,
                    indicatorWeight: 3,
                    tabs: _tabLabels.map((l) => Tab(text: l)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: const [
            _B1Tab(),
            _B2Tab(),
            _B3Tab(),
          ],
        ),
      ),
    );
  }
}

class _GatewayButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _GatewayButton({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: AppTypography.montserrat(
              fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.white,
            )),
      ),
    );
  }
}

// B1 — Assessments, Quick Actions, Self-paced Learning
class _B1Tab extends StatelessWidget {
  const _B1Tab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 12, bottom: 32),
      children: [
        ConfiZoneSectionWidget(
          title: 'Assessments',
          programs: getFeaturedPrograms(ProgramType.assessment),
        ),
        ConfiZoneSectionWidget(
          title: 'Quick Actions',
          programs: getFeaturedPrograms(ProgramType.quickAction),
        ),
        ConfiZoneSectionWidget(
          title: 'Self-paced Learning',
          programs: getFeaturedPrograms(ProgramType.selfPaced),
        ),
      ],
    );
  }
}

// B2 — Free Webinars, Programs, 1-1 Sessions
class _B2Tab extends StatelessWidget {
  const _B2Tab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 12, bottom: 32),
      children: [
        ConfiZoneSectionWidget(
          title: 'Free Webinars',
          programs: getFeaturedPrograms(ProgramType.webinar),
        ),
        ConfiZoneSectionWidget(
          title: 'Programs',
          programs: getFeaturedPrograms(ProgramType.program),
        ),
        ConfiZoneSectionWidget(
          title: '1-1 Sessions',
          programs: getFeaturedPrograms(ProgramType.oneToOne),
        ),
      ],
    );
  }
}

// B3 — Mentorship, Advanced
class _B3Tab extends StatelessWidget {
  const _B3Tab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 12, bottom: 32),
      children: [
        ConfiZoneSectionWidget(
          title: 'Mentorship',
          programs: getFeaturedPrograms(ProgramType.mentorship),
        ),
        ConfiZoneSectionWidget(
          title: 'Advanced',
          programs: getFeaturedPrograms(ProgramType.advanced),
        ),
      ],
    );
  }
}
