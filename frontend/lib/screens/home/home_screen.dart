// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/recommendation_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../core/widgets/unit_section_banner.dart';
import '../../core/widgets/streak_bottom_sheet.dart';
import '../../core/widgets/shop_bottom_sheet.dart';
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
import '../confizone/widgets/category_list_screen.dart';
import '../../data/taxonomy_data.dart';

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
          // Sticky Duolingo-Grade Top Status Capsule Bar (Marvilo Kit Homescreen)
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.white,
            toolbarHeight: 62,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(2),
              child: Container(color: const Color(0xFFE4E8F0), height: 2),
            ),
            title: Row(
              children: [
                // Wordmark
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Confi',
                        style: AppTypography.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.blue,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextSpan(
                        text: 'Circle',
                        style: AppTypography.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.coral,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Streak Capsule (Tappable -> Streak Sheet)
                _StatusCapsule(
                  icon: '⚡',
                  label: '5',
                  color: const Color(0xFFFF9600),
                  onTap: () => showStreakBottomSheet(context),
                ),
                const SizedBox(width: 6),

                // ConfiPoints Capsule (Tappable -> Shop Sheet)
                _StatusCapsule(
                  icon: '💎',
                  label: '${user.confiPoints}',
                  color: AppColors.blue,
                  onTap: () => showShopBottomSheet(context, user.confiPoints),
                ),
                const SizedBox(width: 6),

                // ConfiScore Capsule
                _StatusCapsule(
                  icon: '🎯',
                  label: '${user.confiScore}',
                  color: AppColors.coral,
                  onTap: () {},
                ),
                const SizedBox(width: 8),

                // Monogram Avatar
                _AvatarButton(name: user.name),
              ],
            ),
            centerTitle: false,
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

                  // Duolingo Unit Header Banner
                  UnitSectionBanner(
                    sectionNumber: 'Orientation · Discovery',
                    title: 'Explore What Matters to You',
                    subtitle: 'Choose an action below to kickstart your journey',
                    onGuidebookTap: () {},
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
                  // 1. Personalized greeting
                  GreetingHeader(user: user, isFirst: false),

                  // 2. Your Current Situation (Score, Level, 3 Focus Bars, Add, Reassess, Share)
                  const CurrentSituationSection(),

                  // 3. What are you looking for today? + Search
                  SearchBarWidget(
                    hintText: 'What are you looking for today?',
                    onTap: () {},
                  ),

                  // Duolingo Signature Unit / Section Banner
                  UnitSectionBanner(
                    sectionNumber: 'Section 1 · Focus Pillar',
                    title: 'Build Stronger Me',
                    subtitle: 'Improving Confidence, Self-Worth & Inner Balance',
                    onGuidebookTap: () {
                      final area = TaxonomyData.areas[2]; // BUILD STRONGER ME
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CategoryListScreen(area: area),
                        ),
                      );
                    },
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

class _StatusCapsule extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _StatusCapsule({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE4E8F0), width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFE4E8F0),
              offset: Offset(0, 2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTypography.montserrat(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: color,
              ),
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
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD4E1FB), width: 2),
      ),
      child: Center(
        child: Text(
          initial,
          style: AppTypography.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
