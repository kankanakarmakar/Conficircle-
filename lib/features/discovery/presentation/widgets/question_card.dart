// lib/features/discovery/presentation/widgets/question_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../domain/entities/question_prompt_entity.dart';

/// Interactive Glassmorphic Question Box-Button.
/// Designed with frosted glass reflections, specular borders, micro-press physics,
/// and an embedded action button for Level 4 question prompts.
class QuestionCard extends StatefulWidget {
  final QuestionPromptEntity item;
  final VoidCallback onTap;

  const QuestionCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            // Soft ambient depth shadow
            BoxShadow(
              color: const Color(0xFF102A6B).withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            // Specular top light reflection
            BoxShadow(
              color: Colors.white.withOpacity(0.95),
              blurRadius: 2,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                // Frosted glass gradient with subtle cool tint
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.94),
                    const Color(0xFFF6F9FF).withOpacity(0.82),
                    Colors.white.withOpacity(0.88),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
                borderRadius: BorderRadius.circular(22),
                // Specular crisp glass border
                border: Border.all(
                  color: _isPressed
                      ? AppColors.coral.withOpacity(0.6)
                      : Colors.white.withOpacity(0.95),
                  width: 1.4,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  onTapDown: (_) => setState(() => _isPressed = true),
                  onTapUp: (_) => setState(() => _isPressed = false),
                  onTapCancel: () => setState(() => _isPressed = false),
                  borderRadius: BorderRadius.circular(22),
                  splashColor: AppColors.coral.withOpacity(0.08),
                  highlightColor: Colors.white.withOpacity(0.4),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Top Bar: Glass Badge & Circular Action Target ─────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Badge: Personalized Reason or Curated Prompt Tag
                            if (item.safeReasonLabel != null &&
                                item.safeReasonLabel!.isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4.5),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFE8F0FE).withOpacity(0.9),
                                      const Color(0xFFD6E4FF).withOpacity(0.75),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.lightBlue.withOpacity(0.4),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.auto_awesome_rounded,
                                        size: 11, color: AppColors.blue),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.safeReasonLabel!,
                                      style: AppTypography.montserrat(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4.5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.lightGrey.withOpacity(0.8),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.bolt_rounded,
                                        size: 12, color: AppColors.coral),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Question Challenge',
                                      style: AppTypography.montserrat(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF334A70),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            // Top-right interactive glowing circular target
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.95),
                                    const Color(0xFFFFF2EF).withOpacity(0.85),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.coral.withOpacity(0.35),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.coral.withOpacity(0.18),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_outward_rounded,
                                  size: 15,
                                  color: AppColors.coral,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ── Question Text (Level 4 Prompts Only) ──────────────
                        Text(
                          item.prompt,
                          style: AppTypography.montserrat(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F1E4A),
                            height: 1.34,
                          ),
                        ),

                        if (item.shortDescription != null &&
                            item.shortDescription!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            item.shortDescription!,
                            style: AppTypography.body(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF5A6E8C),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        const SizedBox(height: 14),

                        // ── Bottom Interactive Button & Feature Bar ───────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Frosted glass tag for solution preview
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.65),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.8),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.lightbulb_rounded,
                                      size: 13, color: Color(0xFFF2432C)),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Insights & Tips',
                                    style: AppTypography.body(
                                      fontSize: 11,
                                      color: const Color(0xFF4A5D7C),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Interactive Capsule Action Button
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7.5),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFF2432C), Color(0xFFFF6448)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.coral.withOpacity(0.38),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Explore',
                                    style: AppTypography.montserrat(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 13,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
