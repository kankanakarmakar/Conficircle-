// lib/screens/onboarding/step3_goal.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class Step3Goal extends StatefulWidget {
  final VoidCallback onNext;
  const Step3Goal({super.key, required this.onNext});

  @override
  State<Step3Goal> createState() => _Step3GoalState();
}

class _Step3GoalState extends State<Step3Goal> {
  final List<Map<String, dynamic>> _goals = [
    {'text': 'Get clarity on my career path', 'emoji': '🧭', 'color': AppColors.blue},
    {'text': 'Build my confidence', 'emoji': '💪', 'color': AppColors.coral},
    {'text': 'Improve communication skills', 'emoji': '🗣️', 'color': AppColors.lightBlue},
    {'text': 'Understand myself better', 'emoji': '🔍', 'color': Color(0xFF9B59B6)},
    {'text': 'Manage money and invest', 'emoji': '📈', 'color': Color(0xFF27AE60)},
    {'text': 'Reduce stress and anxiety', 'emoji': '🌿', 'color': Color(0xFF27AE60)},
    {'text': 'Build better relationships', 'emoji': '🤝', 'color': AppColors.coral},
    {'text': 'Become a better leader', 'emoji': '👑', 'color': AppColors.blue},
    {'text': 'Explore higher studies', 'emoji': '🎓', 'color': AppColors.blue},
    {'text': 'Grow personally and spiritually', 'emoji': '✨', 'color': Color(0xFF9B59B6)},
  ];

  final Set<int> _selected = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text('What matters\nmost to you?', style: AppTypography.headingLarge),
          const SizedBox(height: 6),
          Text('Pick up to 3 goals that resonate with you right now.', style: AppTypography.bodyMedium),
          const SizedBox(height: 20),

          Expanded(
            child: ListView.separated(
              itemCount: _goals.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final goal = _goals[i];
                final isSelected = _selected.contains(i);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selected.remove(i);
                      } else if (_selected.length < 3) {
                        _selected.add(i);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? (goal['color'] as Color).withOpacity(0.1) : AppColors.softGrey,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? (goal['color'] as Color) : AppColors.lightGrey,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (goal['color'] as Color).withOpacity(0.15)
                                : AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(goal['emoji'] as String, style: const TextStyle(fontSize: 22)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            goal['text'] as String,
                            style: AppTypography.labelLarge.copyWith(
                              color: isSelected ? (goal['color'] as Color) : AppColors.blue,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_circle_rounded, color: goal['color'] as Color, size: 22),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final picks = _selected.map((i) => _goals[i]['text'] as String).toList();
                context.read<UserProvider>().updateProfile(focusCategories: picks);
                context.read<UserProvider>().completeOnboarding();
                widget.onNext();
              },
              child: const Text('Start Exploring'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
