// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/recommendation_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'widgets/greeting_header.dart';
import 'widgets/action_card_grid.dart';
import 'widgets/explore_more_button.dart';
import 'widgets/just_curious_section.dart';
import 'widgets/useful_content_section.dart';
import 'widgets/assessment_invite_banner.dart';
import 'widgets/explore_life_journey.dart';
import 'widgets/tools_for_you.dart';
import 'widgets/do_you_know.dart';
import 'widgets/share_earn_section.dart';
import 'widgets/current_situation.dart';
import 'widgets/topic_grid_section.dart';
import 'widgets/recommended_programs.dart';
import 'widgets/because_you_explored.dart';
import 'widgets/others_like_you.dart';
import 'widgets/real_students_section.dart';

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
          // Sticky top bar
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.white,
            expandedHeight: 0,
            flexibleSpace: const FlexibleSpaceBar(),
title: isFirst
        // First-time: show logo instead of search bar
        ? Image.asset(
            'assets/images/image.png',
            width: 60,
            height: 60,
          )
        // Returning: search bar
        : _SearchBarSliver(),
            centerTitle: false,
            actions: [
              _AvatarButton(name: user.name),
              const SizedBox(width: 12),
            ],
          ),

          // ── FIRST-TIME USER LAYOUT ────────────────────────────────
          if (isFirst)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Greeting
                  GreetingHeader(user: user, isFirst: true),

                  // 2. Six action cards
                  const ActionCardGrid(),

                  const SizedBox(height: 8),

                  // 3. Discover My Confi — assessment CTA banner
                  const AssessmentInviteBanner(),

                  // 4. Tools for You
                  const ToolsForYouSection(),

                  // 5. Did You Know
                  const DoYouKnowSection(),

                  const SizedBox(height: 32),
                ],
              ),
            ),

          // ── RETURNING USER LAYOUT ────────────────────────────────
          if (!isFirst)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Greeting
                  GreetingHeader(user: user, isFirst: false),

                  // 2. ConfiZone card — CS, CL, focus areas, Reassess Confi
                  const CurrentSituationSection(),

                  // 3. Six random topic cards → each opens TopicDetailScreen
                  const TopicGridSection(),

                  // 4. Tools for You
                  const ToolsForYouSection(),

                  // 5. Did You Know? (scrollable fact cards)
                  const DoYouKnowSection(),

                  // 6. Something useful for you
                  const UsefulContentSection(),

                  // 6. Just Curious quick picks
                  const JustCuriousSection(),

                  // 7. Because you explored
                  const BecauseYouExploredSection(),

                  // 8. Share & Earn
                  const ShareEarnSection(),

                  const SizedBox(height: 32),
                ],
              ),
            ),

        ],
      ),
    );
  }
}

class _SearchBarSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.softGrey,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.darkGrey, size: 18),
            const SizedBox(width: 8),
            Text(
              'What would you like to do?',
              style: AppTypography.bodySmall.copyWith(color: Colors.grey.shade500),
            ),
          ],
        ),
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
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: AppTypography.montserrat(
              fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.white),
        ),
      ),
    );
  }
}
