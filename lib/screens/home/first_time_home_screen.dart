// lib/screens/home/first_time_home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'widgets/action_card_grid.dart';
import 'widgets/assessment_invite_banner.dart';
import 'widgets/tools_for_you.dart';
import 'widgets/do_you_know.dart';

class FirstTimeHomeScreen extends StatelessWidget {
  const FirstTimeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().profile;
    final name = user.name.isNotEmpty ? user.name : 'there';
    final initial = name[0].toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.softGrey,
      body: CustomScrollView(
        slivers: [
          // ── App bar ──────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.white,
            expandedHeight: 0,
            flexibleSpace: const FlexibleSpaceBar(),
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
            actions: [
              Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(right: 12),
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: AppTypography.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Greeting ─────────────────────────────────────
                _GreetingHeader(name: name),

                // ── 6 Action Cards ────────────────────────────────
                const ActionCardGrid(),

                const SizedBox(height: 24),

                // ── Discover My Confi (Assessment CTA) ───────────
                const AssessmentInviteBanner(),

                // ── Tools for You ─────────────────────────────────
                const ToolsForYouSection(),

                // ── Did You Know ──────────────────────────────────
                const DoYouKnowSection(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Simple greeting header for first-time users
// ─────────────────────────────────────────────────────────────
class _GreetingHeader extends StatelessWidget {
  final String name;
  const _GreetingHeader({required this.name});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$_greeting, $name 👋',
            style: AppTypography.headingLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Welcome to ConfiCircle',
            style: AppTypography.headingSmall.copyWith(color: AppColors.coral),
          ),
          const SizedBox(height: 8),
          Text(
            'Explore yourself. Discover possibilities.\nTry something new.',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 20),
          Text(
            'What are you curious about?',
            style: AppTypography.headingSmall,
          ),
        ],
      ),
    );
  }
}
