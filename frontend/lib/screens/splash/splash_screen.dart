// lib/screens/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../core/widgets/tactile_button.dart';

/// Duolingo-Grade Splash / Welcome Screen (Marvilo Kit Frame 1)
/// Features bold typography, student growth radar badge, and tactile 3D buttons.
class SplashScreen extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onAlreadyHaveAccount;

  const SplashScreen({
    super.key,
    required this.onGetStarted,
    required this.onAlreadyHaveAccount,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Brand Wordmark
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Confi',
                      style: AppTypography.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.blue,
                        letterSpacing: -0.5,
                      ),
                    ),
                    TextSpan(
                      text: 'Circle',
                      style: AppTypography.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.coral,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              // Geometric Growth Radar Badge (Strictly NO mascots / figures)
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF0F4FD),
                  border: Border.all(color: const Color(0xFFD4E1FB), width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFD4E1FB),
                      offset: Offset(0, 6),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.coral.withOpacity(0.3), width: 2),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.blue.withOpacity(0.08),
                          border: Border.all(color: AppColors.blue.withOpacity(0.4), width: 2),
                        ),
                      ),
                      const Icon(
                        Icons.track_changes_rounded,
                        size: 54,
                        color: AppColors.blue,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Headline & Value Proposition
              Text(
                'Discover, Grow\n& Succeed',
                textAlign: TextAlign.center,
                style: AppTypography.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.blue,
                  height: 1.15,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'The self-directed student growth platform.\nExplore 4 pillars, build real confidence, and achieve your goals.',
                textAlign: TextAlign.center,
                style: AppTypography.body(
                  fontSize: 14,
                  color: AppColors.darkGrey,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              // 3 Pillars preview capsules
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _FeaturePill(icon: '🧭', text: '4 Pillars'),
                  const SizedBox(width: 8),
                  _FeaturePill(icon: '🎯', text: 'ConfiScore'),
                  const SizedBox(width: 8),
                  _FeaturePill(icon: '⚡', text: 'Daily Habit'),
                ],
              ),

              const Spacer(flex: 2),

              // Duolingo Tactile 3D Buttons (Marvilo Kit)
              TactileButton.primary(
                text: 'GET STARTED',
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  onGetStarted();
                },
              ),
              const SizedBox(height: 12),
              TactileButton.secondary(
                text: 'I ALREADY HAVE AN ACCOUNT',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onAlreadyHaveAccount();
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final String icon;
  final String text;

  const _FeaturePill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E8F0), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 5),
          Text(
            text,
            style: AppTypography.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
