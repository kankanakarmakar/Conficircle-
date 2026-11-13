// lib/screens/me/widgets/confi_level_widget.dart
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

const List<Map<String, String>> _levels = [
  {'name': 'Spark', 'subtitle': 'Just Beginning', 'emoji': '✨'},
  {'name': 'Seeker', 'subtitle': 'Finding Yourself', 'emoji': '🔍'},
  {'name': 'Explorer', 'subtitle': 'Discovering Paths', 'emoji': '🗺️'},
  {'name': 'Aligner', 'subtitle': 'Finding Direction', 'emoji': '🧭'},
  {'name': 'Builder', 'subtitle': 'Taking Shape', 'emoji': '🏗️'},
  {'name': 'Riser', 'subtitle': 'Gaining Momentum', 'emoji': '📈'},
  {'name': 'Achiever', 'subtitle': 'Making Impact', 'emoji': '🏆'},
  {'name': 'Connector', 'subtitle': 'Building Bridges', 'emoji': '🤝'},
  {'name': 'Influencer', 'subtitle': 'Leading Others', 'emoji': '🌟'},
  {'name': 'Visionary', 'subtitle': 'Defining Purpose', 'emoji': '🔮'},
  {'name': 'Champion', 'subtitle': 'Inspiring Change', 'emoji': '🦁'},
  {'name': 'Legend', 'subtitle': 'Leaving a Legacy', 'emoji': '👑'},
];

class ConfiLevelWidget extends StatelessWidget {
  final int currentLevel;

  const ConfiLevelWidget({super.key, required this.currentLevel});

  @override
  Widget build(BuildContext context) {
    final idx = (currentLevel - 1).clamp(0, 11);
    final current = _levels[idx];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Confi Journey', style: AppTypography.labelLarge),
        const SizedBox(height: 4),
        Text(
          'Complete assessments and programs to level up',
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _levels.length,
            itemBuilder: (context, i) {
              final level = _levels[i];
              final levelNum = i + 1;
              final isCompleted = levelNum < currentLevel;
              final isCurrent = levelNum == currentLevel;
              final isLocked = levelNum > currentLevel;

              return _LevelNode(
                levelNum: levelNum,
                name: level['name']!,
                emoji: level['emoji']!,
                isCompleted: isCompleted,
                isCurrent: isCurrent,
                isLocked: isLocked,
                isLast: i == _levels.length - 1,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Current level card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF173883), Color(0xFF4475D7)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(current['emoji']!,
                  style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level $currentLevel — ${current['name']}',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      current['subtitle']!,
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              if (currentLevel < 12)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Next',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white60,
                      ),
                    ),
                    Text(
                      _levels[idx + 1]['name']!,
                      style: AppTypography.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coral,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LevelNode extends StatelessWidget {
  final int levelNum;
  final String name;
  final String emoji;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLocked;
  final bool isLast;

  const _LevelNode({
    required this.levelNum,
    required this.name,
    required this.emoji,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLocked,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppColors.coral
                    : isCompleted
                        ? AppColors.success
                        : AppColors.lightGrey,
                shape: BoxShape.circle,
                border: isCurrent
                    ? Border.all(color: AppColors.coral, width: 3)
                    : null,
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: AppColors.coral.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: isLocked
                    ? const Icon(Icons.lock_rounded,
                        size: 16, color: Colors.white54)
                    : isCompleted
                        ? const Icon(Icons.check_rounded,
                            size: 18, color: Colors.white)
                        : Text(emoji,
                            style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: AppTypography.montserrat(
                fontSize: 9,
                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                color: isCurrent ? AppColors.coral : AppColors.darkGrey,
              ),
            ),
          ],
        ),
        if (!isLast)
          Container(
            width: 20,
            height: 2,
            margin: const EdgeInsets.only(bottom: 18),
            color: isCompleted ? AppColors.success : AppColors.lightGrey,
          ),
      ],
    );
  }
}
