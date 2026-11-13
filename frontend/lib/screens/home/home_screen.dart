// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/recommendation_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'widgets/greeting_header.dart';
import 'widgets/current_situation.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/action_card_grid.dart';
import 'widgets/focus_area_card.dart';
import 'widgets/explore_areas_grid.dart';
import 'widgets/assessment_invite_banner.dart';
import 'widgets/tools_for_you.dart';
import 'widgets/do_you_know.dart';
import 'widgets/useful_content_section.dart';
import 'widgets/just_curious_section.dart';
import 'widgets/because_you_explored.dart';
import 'widgets/share_earn_section.dart';

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
      backgroundColor: const Color(0xFFF7F9FC),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Sticky Top Bar
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.white,
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Confi',
                    style: AppTypography.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blue,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextSpan(
                    text: 'Circle',
                    style: AppTypography.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.coral,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: false,
            actions: [
              _AvatarButton(name: user.name),
              const SizedBox(width: 16),
            ],
          ),

          // ── FIRST-TIME USER FLOW (Blueprint §7: Exactly 11 sections) ────────
          if (isFirst)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Greeting
                  GreetingHeader(user: user, isFirst: true),

                  // 2. What are you curious about? + Search
                  SearchBarWidget(
                    hintText: 'What are you curious about today?',
                    onTap: () {},
                  ),

                  // 3. Six discovery actions + 4. Explore more button
                  const ActionCardGrid(isFirst: true),

                  // 5. Just curious? + More
                  const JustCuriousSection(),

                  // 6. Something useful for you + More
                  const UsefulContentSection(),

                  // 7. Discover Baseline Assessment
                  const AssessmentInviteBanner(),

                  // 8. Explore Life Journey (4 Pillars)
                  const ExploreAreasGrid(),

                  // 9. Tools for You
                  const ToolsForYouSection(),

                  // 10. Do You Know?
                  const DoYouKnowSection(),

                  // 11. Share your experience and earn ConfiPoints
                  const ShareEarnSection(),

                  const SizedBox(height: 36),
                ],
              ),
            ),

          // ── RETURNING USER DASHBOARD (Blueprint §8: Exactly 16 sections) ───
          if (!isFirst)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Personalized greeting + Status capsules
                  GreetingHeader(user: user, isFirst: false),

                  // 2. Your Current Situation (Score, Level, 3 Focus Bars, Add, Reassess, Share)
                  const CurrentSituationSection(),

                  // 3. What are you looking for today? + Search
                  SearchBarWidget(
                    hintText: 'What are you looking for today?',
                    onTap: () {},
                  ),

                  // 4. Picked for you (6 actions) + 5. Explore more button
                  const ActionCardGrid(isFirst: false),

                  // Active Focus Areas Carousel
                  const FocusAreaSection(),

                  // 12. Explore Life Journey (4 Pillars)
                  const ExploreAreasGrid(),

                  // 6. Quick Actions ("Just curious?")
                  const JustCuriousSection(),

                  // 7. Something useful for you (Personalized resources)
                  const UsefulContentSection(),

                  // 13. Tools for You
                  const ToolsForYouSection(),

                  // 14. Do You Know?
                  const DoYouKnowSection(),

                  // 15. Because you explored/completed
                  const BecauseYouExploredSection(),

                  // 16. Share & Earn
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
      decoration: BoxDecoration(
        color: AppColors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD4E1FB), width: 2),
      ),
      child: Center(
        child: Text(
          initial,
          style: AppTypography.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
