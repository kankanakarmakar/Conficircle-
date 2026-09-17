// lib/screens/confizone/confizone_intro_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class ConfiZoneIntroScreen extends StatefulWidget {
  const ConfiZoneIntroScreen({super.key});

  @override
  State<ConfiZoneIntroScreen> createState() => _ConfiZoneIntroScreenState();
}

class _ConfiZoneIntroScreenState extends State<ConfiZoneIntroScreen> {
  bool _skipForNext = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🎯', style: TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome to', style: AppTypography.bodyMedium),
                      Text('ConfiZone', style: AppTypography.headingLarge),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Your action space for understanding,\nlearning and growing.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 32),

              // Two options
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _IntroOptionCard(
                      label: 'Option 1',
                      title: 'Take My Confi',
                      desc: 'Get a quick picture of where you are.',
                      emoji: '📊',
                      color: AppColors.blue,
                      onTap: () {
                        context.read<UserProvider>().setConfizoneIntroCompleted();
                        // Navigate to assessment
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                    child: Text('OR', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkGrey)),
                  ),
                  Expanded(
                    child: _IntroOptionCard(
                      label: 'Option 2',
                      title: 'Explore what you\'re looking for',
                      desc: 'Go back and discover what matters to you.',
                      emoji: '🔍',
                      color: AppColors.coral,
                      onTap: () {
                        context.read<UserProvider>().setConfizoneIntroCompleted();
                        // Navigate back to home
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_skipForNext) {
                      context.read<UserProvider>().setConfizoneIntroSkipped(true);
                    }
                    context.read<UserProvider>().setConfizoneIntroCompleted();
                  },
                  child: Column(
                    children: [
                      Text('Continue to ConfiZone', style: AppTypography.ctaStyle),
                      Text('Your action space.',
                          style: AppTypography.montserrat(
                            fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.white.withOpacity(0.8),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Skip checkbox
              GestureDetector(
                onTap: () => setState(() => _skipForNext = !_skipForNext),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _skipForNext ? AppColors.blue : AppColors.white,
                        border: Border.all(color: AppColors.blue, width: 1.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _skipForNext
                          ? const Icon(Icons.check, size: 14, color: AppColors.white)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Text('Skip for next time.',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.darkGrey)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroOptionCard extends StatelessWidget {
  final String label, title, desc, emoji;
  final Color color;
  final VoidCallback onTap;

  const _IntroOptionCard({
    required this.label,
    required this.title,
    required this.desc,
    required this.emoji,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: AppTypography.montserrat(
                  fontSize: 10, fontWeight: FontWeight.w600,
                  color: AppColors.white.withOpacity(0.7),
                )),
            const SizedBox(height: 6),
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(title,
                style: AppTypography.montserrat(
                  fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.white,
                )),
            const SizedBox(height: 6),
            Text(desc,
                style: AppTypography.montserrat(
                  fontSize: 11, fontWeight: FontWeight.w400,
                  color: AppColors.white.withOpacity(0.85),
                )),
          ],
        ),
      ),
    );
  }
}
