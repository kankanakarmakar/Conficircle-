// lib/screens/assessment/assessment_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../core/widgets/tactile_button.dart';
import '../../core/widgets/tactile_option_card.dart';
import '../../core/widgets/feedback_drawer.dart';
import 'assessment_result_screen.dart';

/// Full-Screen Diagnostic Assessment Flow (Blueprint §10 / Marvilo Lessons)
/// Replicates Duolingo's question canvas, linear progress, tactile choice cards,
/// and instant feedback drawer.
class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  int _currentQ = 0;
  int? _selectedOption;
  bool _showFeedback = false;
  final Map<int, int> _answers = {};

  final List<Map<String, dynamic>> _questions = [
    {
      'category': 'CAREER CLARITY',
      'question': 'How clear are you about your direction after graduation?',
      'options': [
        'Completely uncertain — exploring everything',
        'Have a few ideas, but no concrete plan',
        'Fairly clear on my target roles & industry',
        'Crystal clear with specific target roadmap',
      ],
      'feedback': 'Reflecting on your clarity helps tailor relevant opportunities.',
    },
    {
      'category': 'CONFIDENCE & SELF-WORTH',
      'question': 'How confident do you feel pitching your ideas or speaking in groups?',
      'options': [
        'Anxious — I avoid speaking up when possible',
        'Somewhat hesitant, but push through',
        'Generally confident in familiar topics',
        'Highly confident and articulate in public',
      ],
      'feedback': 'Building voice presence is a compounding skill.',
    },
    {
      'category': 'PERSONAL EFFECTIVENESS',
      'question': 'How consistently do you stick to daily study and personal habits?',
      'options': [
        'Struggle with procrastination and focus',
        'Inconsistent — depends heavily on mood',
        'Steady routine during exam seasons',
        'Disciplined daily calendar and habit loops',
      ],
      'feedback': 'Micro-habits reduce willpower friction dramatically.',
    },
    {
      'category': 'FINANCIAL GROWTH',
      'question': 'How familiar are you with managing money and student investments?',
      'options': [
        'Never learned about personal finance',
        'Understand basic budgeting and savings',
        'Familiar with compound interest & SIPs',
        'Actively investing and tracking finances',
      ],
      'feedback': 'Financial literacy early compounds into true independence.',
    },
    {
      'category': 'EMOTIONAL BALANCE',
      'question': 'How do you typically navigate unexpected setbacks or failure?',
      'options': [
        'Overwhelmed — tends to derail me for days',
        'Takes time to recover and process emotions',
        'Bounce back with support from friends',
        'View setbacks as high-leverage feedback',
      ],
      'feedback': 'Resilience is learned through gradual exposure.',
    },
  ];

  double get _progress => (_currentQ + 1) / _questions.length;

  void _onOptionChosen(int index) {
    if (_showFeedback) return;
    setState(() => _selectedOption = index);
  }

  void _onCheckAnswer() {
    if (_selectedOption == null) return;
    setState(() {
      _answers[_currentQ] = _selectedOption!;
      _showFeedback = true;
    });
  }

  void _onNextQuestion() {
    setState(() {
      _showFeedback = false;
      _selectedOption = null;
      if (_currentQ < _questions.length - 1) {
        _currentQ++;
      } else {
        _submitAndFinish();
      }
    });
  }

  void _submitAndFinish() {
    final total = _answers.values.fold(0, (a, b) => a + b);
    final score = ((total / (_questions.length * 3)) * 100).clamp(30.0, 95.0);
    final level = (score / 15).ceil().clamp(1, 8);

    final userProvider = context.read<UserProvider>();
    userProvider.completeAssessment(score: score, level: level);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => AssessmentResultScreen(
          score: score,
          level: level,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final qData = _questions[_currentQ];
    final options = qData['options'] as List<String>;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Duolingo Lesson Top Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 24, color: AppColors.darkGrey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 12,
                        backgroundColor: const Color(0xFFE4E8F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF58CC02)), // Duolingo green
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.softGrey,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE4E8F0)),
                    ),
                    child: Text(
                      '${_currentQ + 1}/${_questions.length}',
                      style: AppTypography.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Question Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Badge Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.blue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.blue.withOpacity(0.2)),
                      ),
                      child: Text(
                        qData['category'] as String,
                        style: AppTypography.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blue,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Big Prompt Header
                    Text(
                      qData['question'] as String,
                      style: AppTypography.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blue,
                        height: 1.3,
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tactile Option Cards
                    ...List.generate(options.length, (i) {
                      final isSelected = _selectedOption == i;
                      return TactileOptionCard(
                        label: options[i],
                        isSelected: isSelected,
                        onSelect: () => _onOptionChosen(i),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Bottom Action Area / Feedback Drawer
            if (_showFeedback)
              FeedbackDrawer(
                title: 'Reflection Logged!',
                subtitle: qData['feedback'] as String,
                isSuccess: true,
                buttonLabel: _currentQ == _questions.length - 1 ? 'SEE MY RADAR' : 'CONTINUE',
                onContinue: _onNextQuestion,
              )
            else
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(top: BorderSide(color: Color(0xFFE4E8F0), width: 2)),
                ),
                child: TactileButton(
                  label: 'CHECK',
                  backgroundColor: _selectedOption != null ? const Color(0xFF58CC02) : const Color(0xFFE4E8F0),
                  shadowColor: _selectedOption != null ? const Color(0xFF46A302) : const Color(0xFFD0D7E5),
                  textColor: _selectedOption != null ? Colors.white : AppColors.darkGrey,
                  onPressed: _selectedOption != null ? _onCheckAnswer : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
