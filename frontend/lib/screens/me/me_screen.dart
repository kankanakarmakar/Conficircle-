// lib/screens/me/me_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../assessment/assessment_screen.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().profile;

    return Scaffold(
      backgroundColor: AppColors.softGrey,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.blue,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F2459), Color(0xFF2258C5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar + Name
                        Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppColors.coral,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white38, width: 3),
                              ),
                              child: Center(
                                child: Text(
                                  user.name.isNotEmpty ? user.name[0].toUpperCase() : 'A',
                                  style: AppTypography.montserrat(
                                    fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.name.isNotEmpty ? user.name : 'Student',
                                      style: AppTypography.headingSmall.copyWith(color: AppColors.white)),
                                  if (user.college != null)
                                    Text(user.college!,
                                        style: AppTypography.bodySmall.copyWith(
                                          color: AppColors.white.withOpacity(0.8),
                                        )),
                                  if (user.course != null)
                                    Text('${user.course} · ${user.yearOfStudy ?? ''}',
                                        style: AppTypography.bodySmall.copyWith(
                                          color: AppColors.white.withOpacity(0.7),
                                        )),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings_outlined, color: Colors.white70),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Score row
                        Row(
                          children: [
                            _StatBox(label: 'Confi Score', value: '${user.confiScore.toInt()}'),
                            const SizedBox(width: 12),
                            _StatBox(label: 'Confi Level', value: 'CL ${user.confiLevel}'),
                            const SizedBox(width: 12),
                            _StatBox(label: 'CP', value: '${user.confiPoints}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Confi Level card
                _MeSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('🏆', style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Confi Level ${user.confiLevel}',
                                    style: AppTypography.labelLarge),
                                Text(user.confiLevelName,
                                    style: AppTypography.bodySmall.copyWith(color: AppColors.coral)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Level progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: (user.confiLevel - 1) / 11,
                          backgroundColor: AppColors.lightGrey,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.coral),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Level 1 — Spark', style: AppTypography.bodySmall),
                          Text('Level 12 — Legend', style: AppTypography.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),

                // Discover My Confi
                _MeSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Assessment', style: AppTypography.headingSmall),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => const AssessmentScreen(),
                        )),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF173883), Color(0xFF4475D7)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Text('📊', style: TextStyle(fontSize: 32)),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Discover My Confi',
                                        style: AppTypography.labelLarge.copyWith(color: AppColors.white)),
                                    Text('Get your full Confi report',
                                        style: AppTypography.bodySmall.copyWith(
                                            color: AppColors.white.withOpacity(0.8))),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded,
                                  color: Colors.white70, size: 16),
                            ],
                          ),
                        ),
                      ),
                      if (user.hasCompletedAssessment) ...[
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.coral.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.coral.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Text('📄', style: TextStyle(fontSize: 24)),
                                const SizedBox(width: 10),
                                Text('View My Confi Report',
                                    style: AppTypography.labelLarge.copyWith(color: AppColors.coral)),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios_rounded,
                                    color: AppColors.coral, size: 14),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Activity summary
                _MeSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Activity', style: AppTypography.headingSmall),
                      const SizedBox(height: 14),
                      _ActivityRow(emoji: '🎯', label: 'Actions Explored',
                          value: '${user.clickedActionIds.length}'),
                      _ActivityRow(emoji: '💾', label: 'Resources Saved',
                          value: '${user.savedResourceIds.length}'),
                      _ActivityRow(emoji: '🎓', label: 'Programs Completed',
                          value: '${user.completedProgramIds.length}'),
                      _ActivityRow(emoji: '⭐', label: 'Confi Points',
                          value: '${user.confiPoints}'),
                    ],
                  ),
                ),

                // Demo toggle
                _MeSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Demo', style: AppTypography.headingSmall),
                      const SizedBox(height: 10),
                      Text('Switch between new student and existing student views.',
                          style: AppTypography.bodySmall),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // Reset to first-time user
                                context.read<UserProvider>().updateProfile(name: 'Anaya');
                              },
                              child: const Text('New Student'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => context.read<UserProvider>().setExistingStudentDemo(),
                              child: const Text('Existing Student'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: AppTypography.montserrat(
                  fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.white,
                )),
            const SizedBox(height: 2),
            Text(label,
                textAlign: TextAlign.center,
                style: AppTypography.montserrat(
                  fontSize: 10, fontWeight: FontWeight.w500,
                  color: AppColors.white.withOpacity(0.75),
                )),
          ],
        ),
      ),
    );
  }
}

class _MeSection extends StatelessWidget {
  final Widget child;
  const _MeSection({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final String emoji, label, value;
  const _ActivityRow({required this.emoji, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: AppTypography.bodyLarge)),
          Text(value,
              style: AppTypography.montserrat(
                fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.coral,
              )),
        ],
      ),
    );
  }
}
