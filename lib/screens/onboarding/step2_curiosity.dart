// lib/screens/onboarding/step2_curiosity.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class Step2Curiosity extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;
  const Step2Curiosity({super.key, required this.onNext, required this.onSkip});

  @override
  State<Step2Curiosity> createState() => _Step2CuriosityState();
}

class _Step2CuriosityState extends State<Step2Curiosity> {
  final List<Map<String, dynamic>> _options = [
    {'text': 'Explore higher studies\nand research', 'emoji': '🎓', 'color': AppColors.blue},
    {'text': 'Recognize my\nstrengths', 'emoji': '⚡', 'color': AppColors.coral},
    {'text': 'Become more\npersuasive', 'emoji': '🗣️', 'color': AppColors.coral},
    {'text': 'Understand\ninvesting', 'emoji': '📈', 'color': Color(0xFF27AE60)},
    {'text': 'Become better at\nunderstanding others', 'emoji': '🤍', 'color': AppColors.lightBlue},
    {'text': 'Feel more peaceful\nin daily life', 'emoji': '🌿', 'color': Color(0xFF27AE60)},
    {'text': 'Build my\nconfidence', 'emoji': '💪', 'color': AppColors.blue},
    {'text': 'Find a\nmeaningful career', 'emoji': '🚀', 'color': AppColors.coral},
    {'text': 'Manage money\nbetter', 'emoji': '💰', 'color': Color(0xFF27AE60)},
    {'text': 'Speak confidently\nin public', 'emoji': '🎤', 'color': AppColors.blue},
    {'text': 'Build better\ndaily habits', 'emoji': '✅', 'color': AppColors.lightBlue},
    {'text': 'Manage stress\nbetter', 'emoji': '🧘', 'color': Color(0xFF27AE60)},
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
          Text('What are you\ncurious about?', style: AppTypography.headingLarge),
          const SizedBox(height: 6),
          Text('Select anything that interests you. You can always change this later.',
              style: AppTypography.bodyMedium),
          const SizedBox(height: 20),

          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: _options.length,
              itemBuilder: (context, i) {
                final opt = _options[i];
                final isSelected = _selected.contains(i);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (isSelected) _selected.remove(i); else _selected.add(i);
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected ? (opt['color'] as Color) : AppColors.softGrey,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? (opt['color'] as Color) : AppColors.lightGrey,
                        width: 2,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: (opt['color'] as Color).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ] : [],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(opt['emoji'] as String, style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 6),
                        Text(
                          opt['text'] as String,
                          textAlign: TextAlign.center,
                          style: AppTypography.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? AppColors.white : AppColors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onSkip,
                  child: Text('Skip for now', style: AppTypography.ctaStyle.copyWith(color: AppColors.blue)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final picks = _selected.map((i) => _options[i]['text'] as String).toList();
                    context.read<UserProvider>().updateProfile(selectedCuriosities: picks);
                    widget.onNext();
                  },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
