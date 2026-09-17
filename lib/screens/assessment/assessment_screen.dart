// lib/screens/assessment/assessment_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'assessment_result_screen.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  int _currentQ = 0;
  final Map<int, int> _answers = {};

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'How clear are you about what you want to do after college?',
      'category': 'Career Clarity',
      'options': ['Very unclear', 'Somewhat unclear', 'Somewhat clear', 'Very clear'],
    },
    {
      'question': 'How confident do you feel when speaking in front of others?',
      'category': 'Confidence',
      'options': ['Very low', 'Below average', 'Average', 'High'],
    },
    {
      'question': 'How well can you manage your time and stay productive?',
      'category': 'Personal Effectiveness',
      'options': ['Struggle a lot', 'Sometimes manage', 'Mostly manage', 'Excellent'],
    },
    {
      'question': 'How comfortable are you having difficult conversations?',
      'category': 'Communication',
      'options': ['Very uncomfortable', 'Somewhat uncomfortable', 'Comfortable', 'Very comfortable'],
    },
    {
      'question': 'How often do you feel stressed or overwhelmed by daily life?',
      'category': 'Wellbeing',
      'options': ['Almost always', 'Often', 'Sometimes', 'Rarely'],
    },
  ];

  bool get _isComplete => _currentQ >= _questions.length;

  double get _progress => _currentQ / _questions.length;

  void _selectAnswer(int optionIndex) {
    setState(() {
      _answers[_currentQ] = optionIndex;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _currentQ++;
      });
      if (_isComplete) {
        _calculateAndSubmit();
      }
    });
  }

  void _calculateAndSubmit() {
    final total = _answers.values.fold(0, (a, b) => a + b);
    final maxTotal = (_questions.length - 1) * 4;
    final score = (total / maxTotal) * 100;
    final level = (score / 10).ceil().clamp(1, 12);
    context.read<UserProvider>().completeAssessment(score: score, level: level);
    // Navigate to dedicated result screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AssessmentResultScreen(score: score, level: level),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Basic Confi Assessment', style: AppTypography.labelLarge),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: _progress,
            backgroundColor: AppColors.lightGrey,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.coral),
            minHeight: 4,
          ),
        ),
      ),
      body: _isComplete
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.coral),
                  ),
                  SizedBox(height: 20),
                  Text('Calculating your results...',
                      style: TextStyle(color: AppColors.darkGrey)),
                ],
              ),
            )
          : _buildQuestion(),
    );
  }

  Widget _buildQuestion() {
    final q = _questions[_currentQ];
    final options = q['options'] as List<String>;

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('Question ${_currentQ + 1} of ${_questions.length}',
              style: AppTypography.bodySmall.copyWith(color: AppColors.coral)),
          const SizedBox(height: 8),
          Text(q['category'] as String,
              style: AppTypography.montserrat(
                fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.lightBlue,
              )),
          const SizedBox(height: 12),
          Text(q['question'] as String, style: AppTypography.headingSmall),
          const SizedBox(height: 32),
          ...options.asMap().entries.map((entry) {
            final i = entry.key;
            final opt = entry.value;
            final isSelected = _answers[_currentQ] == i;
            return GestureDetector(
              onTap: () => _selectAnswer(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.coral : AppColors.softGrey,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.coral : AppColors.lightGrey,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? AppColors.white : AppColors.lightGrey,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, size: 14, color: AppColors.coral)
                          : null,
                    ),
                    const SizedBox(width: 14),
                    Text(opt,
                        style: AppTypography.labelLarge.copyWith(
                          color: isSelected ? AppColors.white : AppColors.blue,
                        )),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

