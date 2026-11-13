// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/recommendation_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'widgets/greeting_header.dart';
import 'widgets/explore_areas_grid.dart';
import 'widgets/development_overview_card.dart';
import 'widgets/focus_area_card.dart';
import 'widgets/assessment_invite_banner.dart';
import 'widgets/tools_for_you.dart';
import 'widgets/do_you_know.dart';
import 'widgets/topic_grid_section.dart';
import 'widgets/useful_content_section.dart';
import 'widgets/just_curious_section.dart';
import 'widgets/because_you_explored.dart';
import 'widgets/share_earn_section.dart';
import '../assessment/assessment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecommendationProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().profile;
    final isFirst = user.isFirstTime;

    return Scaffold(
      backgroundColor: AppColors.softGrey,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Sticky top app bar
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.white.withOpacity(0.96),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Confi',
                    style: AppTypography.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blue,
                    ),
                  ),
                  TextSpan(
                    text: 'Circle',
                    style: AppTypography.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.coral,
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: false,
            actions: [
              _AvatarButton(name: user.name),
              const SizedBox(width: 14),
            ],
          ),

          // ── FIRST-TIME USER FLOW (SC-013) ──────────────────────────────────
          if (isFirst)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GreetingHeader(user: user, isFirst: true),
                  const SizedBox(height: 8),
                  const ExploreAreasGrid(),
                  const AssessmentInviteBanner(),
                  const SizedBox(height: 12),
                  const ToolsForYouSection(),
                  const DoYouKnowSection(),
                  const SizedBox(height: 36),
                ],
              ),
            ),

          // ── RETURNING USER FULL DASHBOARD (SC-014) ─────────────────────────
          if (!isFirst)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GreetingHeader(user: user, isFirst: false),
                  DevelopmentOverviewCard(
                    user: user,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AssessmentScreen(),
                        ),
                      );
                    },
                  ),
                  const FocusAreaSection(),
                  const SizedBox(height: 8),
                  const ExploreAreasGrid(),
                  const TopicGridSection(),
                  const ToolsForYouSection(),
                  const DoYouKnowSection(),
                  const UsefulContentSection(),
                  const JustCuriousSection(),
                  const BecauseYouExploredSection(),
                  const ShareEarnSection(),
                  const SizedBox(height: 36),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AvatarButton extends StatelessWidget {
  final String name;
  const _AvatarButton({required this.name});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'A';
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: AppColors.blue,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: AppTypography.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
