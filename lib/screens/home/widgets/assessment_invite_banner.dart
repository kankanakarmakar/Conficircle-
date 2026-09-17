// lib/screens/home/widgets/assessment_invite_banner.dart
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../assessment/assessment_screen.dart';

class AssessmentInviteBanner extends StatefulWidget {
  const AssessmentInviteBanner({super.key});

  @override
  State<AssessmentInviteBanner> createState() => _AssessmentInviteBannerState();
}

class _AssessmentInviteBannerState extends State<AssessmentInviteBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF0A1F5C), Color(0xFF1A3A8A), Color(0xFF3060D0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A3A8A).withOpacity(0.45),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles in background
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            right: 40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withOpacity(0.04),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon + badge row
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.white.withOpacity(0.2),
                        ),
                      ),
                      child: const Center(
                        child: Text('🧠', style: TextStyle(fontSize: 26)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.coral.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            'FREE · 3 MINUTES',
                            style: AppTypography.montserrat(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Cognitive Assessment',
                          style: AppTypography.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Text(
                  'Want to know where\nyou truly stand?',
                  style: AppTypography.montserrat(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Discover your Confi Score, your current level, your strengths, and growth areas — all in 5 quick questions.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.white.withOpacity(0.75),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 8),

                // Quick info pills
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _InfoPill(icon: Icons.timer_outlined, label: '3 min'),
                    _InfoPill(icon: Icons.lock_outline_rounded, label: 'Private'),
                    _InfoPill(
                        icon: Icons.emoji_events_outlined, label: 'Earn badge'),
                  ],
                ),

                const SizedBox(height: 22),

                // CTA Button — animated pulse
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coral,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 0,
                        shadowColor: AppColors.coral.withOpacity(0.5),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AssessmentScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Take My First Assessment',
                            style: AppTypography.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(50),
        border:
            Border.all(color: AppColors.white.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.white.withOpacity(0.8)),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTypography.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}
