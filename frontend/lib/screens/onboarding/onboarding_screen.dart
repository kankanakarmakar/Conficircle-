// lib/screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../core/widgets/tactile_button.dart';
import '../../core/widgets/tactile_option_card.dart';
import '../assessment/assessment_screen.dart';

/// Full Duolingo-Grade Onboarding Flow (Marvilo Kit Frames 2 to 12)
/// Implements progressive linear progress bar, speech prompt cards,
/// tactile option cards with 3.5px bevels, and sticky bottom continue bar.
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  final VoidCallback? onBackToWelcome;

  const OnboardingScreen({
    super.key,
    required this.onComplete,
    this.onBackToWelcome,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0; // 0 to 4
  final int _totalSteps = 5;

  // Selections
  int? _selectedPurposeIndex;
  int _selectedDailyGoalIndex = 1; // Default: 10 min/day (Regular)
  int _selectedStartPointIndex = 0; // Default: Baseline Assessment

  // Profile controllers
  final TextEditingController _nameController = TextEditingController(text: 'Anaya Sharma');
  final TextEditingController _collegeController = TextEditingController(text: 'Delhi University');
  final TextEditingController _courseController = TextEditingController(text: 'B.Tech Computer Science');

  @override
  void dispose() {
    _nameController.dispose();
    _collegeController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      if (widget.onBackToWelcome != null) {
        widget.onBackToWelcome!();
      }
    }
  }

  void _handleNext() {
    HapticFeedback.lightImpact();
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    // Save to provider
    context.read<UserProvider>().updateProfile(
      name: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : 'Anaya Sharma',
      college: _collegeController.text.trim().isNotEmpty ? _collegeController.text.trim() : 'Delhi University',
      course: _courseController.text.trim().isNotEmpty ? _courseController.text.trim() : 'Undergraduate',
    );

    if (_selectedStartPointIndex == 0) {
      // User chose to take the Baseline Assessment
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const AssessmentScreen(),
        ),
      );
    } else {
      // User chose to explore freely
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentStep + 1) / _totalSteps;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.blue, size: 24),
                  onPressed: _handleBack,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                ),
                const SizedBox(width: 8),

                // Smooth Duolingo Linear Progress Bar
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 12,
                      child: Stack(
                        children: [
                          Container(color: const Color(0xFFE4E8F0)),
                          AnimatedFractionallySizedBox(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            alignment: Alignment.centerLeft,
                            widthFactor: progress,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.coral,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    offset: const Offset(0, 2),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Step count indicator
                Text(
                  '${_currentStep + 1}/$_totalSteps',
                  style: AppTypography.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: _buildCurrentStepContent(),
            ),
          ),

          // Sticky Bottom Continue Bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE4E8F0), width: 2),
              ),
            ),
            child: SafeArea(
              top: false,
              child: TactileButton.primary(
                text: _currentStep == _totalSteps - 1
                    ? (_selectedStartPointIndex == 0 ? 'START ASSESSMENT' : 'START EXPLORING')
                    : 'CONTINUE',
                enabled: _isStepValid(),
                onPressed: _handleNext,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isStepValid() {
    switch (_currentStep) {
      case 0:
        return _selectedPurposeIndex != null;
      case 1:
        return true; // daily goal has default
      case 2:
        return true; // value presentation
      case 3:
        return true; // start options has default
      case 4:
        return _nameController.text.trim().isNotEmpty;
      default:
        return true;
    }
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1Purpose();
      case 1:
        return _buildStep2DailyGoal();
      case 2:
        return _buildStep3WhatYouCanAchieve();
      case 3:
        return _buildStep4WhereToStart();
      case 4:
        return _buildStep5ProfileSetup();
      default:
        return const SizedBox.shrink();
    }
  }

  // ── STEP 1: What brings you to ConfiCircle? ──────────────────────
  Widget _buildStep1Purpose() {
    final purposes = [
      {'icon': '💼', 'title': 'Career & Job Clarity', 'subtitle': 'Find career direction and job opportunities'},
      {'icon': '💪', 'title': 'Building Confidence & Self-Worth', 'subtitle': 'Overcome self-doubt and imposter feeling'},
      {'icon': '📚', 'title': 'Academic Success & Study Habits', 'subtitle': 'Improve study effectiveness and focus'},
      {'icon': '🤝', 'title': 'Meaningful Relationships & Impact', 'subtitle': 'Rapport building and communication'},
      {'icon': '💰', 'title': 'Money & Financial Independence', 'subtitle': 'Financial awareness and investing basics'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PromptBubble(text: 'What brings you to ConfiCircle today?'),
        const SizedBox(height: 20),
        Text(
          'Select your primary growth focus:',
          style: AppTypography.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.darkGrey,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(purposes.length, (i) {
          final p = purposes[i];
          final isSelected = _selectedPurposeIndex == i;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TactileOptionCard(
              title: p['title']!,
              subtitle: p['subtitle']!,
              leadingWidget: Text(p['icon']!, style: const TextStyle(fontSize: 24)),
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedPurposeIndex = i);
              },
            ),
          );
        }),
      ],
    );
  }

  // ── STEP 2: Daily Learning Goal ──────────────────────────────────
  Widget _buildStep2DailyGoal() {
    final goals = [
      {'minutes': '5 min / day', 'level': 'Casual', 'desc': 'Quick daily check-in and 1 micro-action'},
      {'minutes': '10 min / day', 'level': 'Regular', 'desc': 'Recommended for steady progress & habits', 'isRecommended': true},
      {'minutes': '15 min / day', 'level': 'Serious', 'desc': 'Deep-dive self-paced topics & exercises'},
      {'minutes': '20 min / day', 'level': 'Intense', 'desc': 'Fast-track career and personal mastery'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PromptBubble(text: "What's your daily learning commitment?"),
        const SizedBox(height: 20),
        Text(
          'You can change this anytime in your profile settings.',
          style: AppTypography.body(fontSize: 13, color: AppColors.darkGrey),
        ),
        const SizedBox(height: 16),
        ...List.generate(goals.length, (i) {
          final g = goals[i];
          final isSelected = _selectedDailyGoalIndex == i;
          final isRec = g['isRecommended'] == true;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TactileOptionCard(
              title: '${g['minutes']} · ${g['level']}',
              subtitle: g['desc'] as String,
              leadingWidget: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.coral.withOpacity(0.1) : const Color(0xFFF0F4FD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    Icons.timer_outlined,
                    size: 20,
                    color: isSelected ? AppColors.coral : AppColors.blue,
                  ),
                ),
              ),
              trailingWidget: isRec
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD7FFB8),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF58CC02), width: 1.5),
                      ),
                      child: Text(
                        'BEST',
                        style: AppTypography.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                    )
                  : null,
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedDailyGoalIndex = i);
              },
            ),
          );
        }),
      ],
    );
  }

  // ── STEP 3: Here's what you can achieve ────────────────────────────
  Widget _buildStep3WhatYouCanAchieve() {
    final achievements = [
      {
        'icon': '🧭',
        'title': '4 Structured Life Pillars',
        'desc': 'Discover what matters across Career, Skills, Mindset, and Relationships.',
      },
      {
        'icon': '📈',
        'title': 'Track Real Growth with ConfiScore',
        'desc': 'Measure baseline capability and level up through daily practice.',
      },
      {
        'icon': '🛠️',
        'title': 'ConfiZone Action Hub',
        'desc': 'Choose from 8 service formats: Guides, Webinars, 1-to-1, and Mentorship.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PromptBubble(text: "Here's what you'll achieve on ConfiCircle"),
        const SizedBox(height: 20),
        ...achievements.map((a) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE4E8F0), width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFE4E8F0),
                  offset: Offset(0, 3.5),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F5FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(a['icon']!, style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a['title']!,
                        style: AppTypography.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        a['desc']!,
                        style: AppTypography.body(
                          fontSize: 12,
                          color: AppColors.darkGrey,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  // ── STEP 4: Choose where to start ────────────────────────────────
  Widget _buildStep4WhereToStart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PromptBubble(text: 'How would you like to begin?'),
        const SizedBox(height: 20),
        Text(
          'Choose the path that fits your current mood:',
          style: AppTypography.body(fontSize: 13, color: AppColors.darkGrey),
        ),
        const SizedBox(height: 16),

        // Option 1: Baseline Assessment
        TactileOptionCard(
          title: 'Take Baseline Assessment',
          subtitle: '5 quick questions to calculate your initial ConfiScore & starting level.',
          leadingWidget: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0EE),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFD5D0), width: 1.5),
            ),
            child: const Center(
              child: Icon(Icons.track_changes_rounded, color: AppColors.coral, size: 24),
            ),
          ),
          isSelected: _selectedStartPointIndex == 0,
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _selectedStartPointIndex = 0);
          },
        ),

        const SizedBox(height: 14),

        // Option 2: Explore Freely
        TactileOptionCard(
          title: 'Explore Freely',
          subtitle: 'Skip straight to the dashboard and browse topics at your own pace.',
          leadingWidget: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD4E1FB), width: 1.5),
            ),
            child: const Center(
              child: Icon(Icons.explore_rounded, color: AppColors.blue, size: 24),
            ),
          ),
          isSelected: _selectedStartPointIndex == 1,
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _selectedStartPointIndex = 1);
          },
        ),
      ],
    );
  }

  // ── STEP 5: Create your profile ──────────────────────────────────
  Widget _buildStep5ProfileSetup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PromptBubble(text: "Almost done! Let's set up your student profile."),
        const SizedBox(height: 24),

        _InputField(
          label: 'Your Name',
          controller: _nameController,
          hintText: 'e.g. Anaya Sharma',
          icon: Icons.person_outline_rounded,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        _InputField(
          label: 'College / University',
          controller: _collegeController,
          hintText: 'e.g. Delhi University',
          icon: Icons.school_outlined,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        _InputField(
          label: 'Course / Major',
          controller: _courseController,
          hintText: 'e.g. B.Tech Computer Science',
          icon: Icons.auto_stories_outlined,
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }
}

/// Sleek speech bubble prompt (no mascots, typography-led)
class _PromptBubble extends StatelessWidget {
  final String text;
  const _PromptBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E8F0), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_outline_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTypography.montserrat(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.blue,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final ValueChanged<String>? onChanged;

  const _InputField({
    required this.label,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.blue,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE4E8F0), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFE4E8F0),
                offset: Offset(0, 3.5),
                blurRadius: 0,
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: AppTypography.body(fontSize: 14, color: AppColors.blue),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTypography.body(fontSize: 14, color: const Color(0xFFA0AEC0)),
              prefixIcon: Icon(icon, color: AppColors.blue, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
