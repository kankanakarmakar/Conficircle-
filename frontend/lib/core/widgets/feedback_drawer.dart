// lib/core/widgets/feedback_drawer.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'tactile_button.dart';

/// Duolingo-style Lesson/Assessment Feedback Drawer.
/// Renders at the bottom of the screen upon choosing an answer or completing a step.
class FeedbackDrawer extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSuccess;
  final VoidCallback onContinue;
  final String buttonLabel;

  const FeedbackDrawer({
    super.key,
    required this.title,
    required this.subtitle,
    this.isSuccess = true,
    required this.onContinue,
    this.buttonLabel = 'CONTINUE',
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isSuccess ? const Color(0xFFD7FFB8) : const Color(0xFFFFDFE0);
    final Color textColor = isSuccess ? const Color(0xFF58A700) : const Color(0xFFEA2B2B);
    final Color iconBg = isSuccess ? const Color(0xFF58CC02) : const Color(0xFFFF4B4B);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(color: iconBg.withOpacity(0.4), width: 2),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSuccess ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.body(
                      fontSize: 12,
                      color: textColor.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          TactileButton(
            label: buttonLabel,
            backgroundColor: isSuccess ? const Color(0xFF58CC02) : AppColors.coral,
            shadowColor: isSuccess ? const Color(0xFF46A302) : const Color(0xFFC02A16),
            onPressed: onContinue,
          ),
        ],
      ),
    );
  }
}
