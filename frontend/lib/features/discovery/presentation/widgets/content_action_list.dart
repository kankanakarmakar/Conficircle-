// lib/features/discovery/presentation/widgets/content_action_list.dart
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../domain/entities/question_detail_entity.dart';
import '../../../guest/presentation/widgets/sign_in_prompt.dart';

class ContentActionList extends StatelessWidget {
  final QuestionDetailEntity detail;
  final VoidCallback onOpenQuickTip;
  final VoidCallback onOpenVideo;
  final VoidCallback onOpenAssessment;

  const ContentActionList({
    super.key,
    required this.detail,
    required this.onOpenQuickTip,
    required this.onOpenVideo,
    required this.onOpenAssessment,
  });

  @override
  Widget build(BuildContext context) {
    final quicktipPerm = detail.permittedActions.firstWhere(
      (a) => a.actionType == 'quicktip',
      orElse: () => const PermittedActionEntity(actionType: 'quicktip', enabled: true),
    );
    final videoPerm = detail.permittedActions.firstWhere(
      (a) => a.actionType == 'video',
      orElse: () => const PermittedActionEntity(actionType: 'video', enabled: false, reason: 'ACCOUNT_REQUIRED'),
    );
    final assessmentPerm = detail.permittedActions.firstWhere(
      (a) => a.actionType == 'assessment',
      orElse: () => const PermittedActionEntity(actionType: 'assessment', enabled: false, reason: 'ACCOUNT_REQUIRED'),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Quick Tips (Allowed within guest quota, free for registered) ─────
        _SectionLabel(title: '⚡ Quick Tips', badge: quicktipPerm.quotaRemaining != null ? '${quicktipPerm.quotaRemaining} tips left' : null),
        const SizedBox(height: 10),
        ...detail.quickTips.map((tip) => _QuickTipCard(
          tip: tip,
          enabled: quicktipPerm.enabled,
          onTap: () {
            if (quicktipPerm.enabled) {
              onOpenQuickTip();
            } else {
              _showQuotaExhaustedSheet(context);
            }
          },
        )),

        const SizedBox(height: 24),

        // ── Video Solutions (Registration gated for guests) ─────────────────
        _SectionLabel(title: '🎬 Video Solutions', isGated: !videoPerm.enabled),
        const SizedBox(height: 10),
        ...detail.videoSolutions.map((video) => _VideoActionCard(
          video: video,
          isGated: !videoPerm.enabled,
          onTap: () {
            if (videoPerm.enabled) {
              onOpenVideo();
            } else {
              _showRegistrationGate(context, 'Video Solutions');
            }
          },
        )),

        const SizedBox(height: 24),

        // ── Quick Assessment (Registration gated for guests) ───────────────
        _SectionLabel(title: '🎯 Quick Assessment', isGated: !assessmentPerm.enabled),
        const SizedBox(height: 10),
        ...detail.assessments.map((ass) => _AssessmentActionCard(
          assessment: ass,
          isGated: !assessmentPerm.enabled,
          onTap: () {
            if (assessmentPerm.enabled) {
              onOpenAssessment();
            } else {
              _showRegistrationGate(context, 'Quick Assessments');
            }
          },
        )),
      ],
    );
  }

  void _showRegistrationGate(BuildContext context, String feature) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SignInPrompt(
        featureName: feature,
        onSignIn: () {
          Navigator.pop(context);
          // Navigate to auth
          Navigator.pushNamed(context, '/auth');
        },
      ),
    );
  }

  void _showQuotaExhaustedSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bolt_rounded, size: 48, color: AppColors.coral),
            const SizedBox(height: 12),
            Text(
              'Quick Tip Quota Reached',
              style: AppTypography.headingSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'You have used all guest quick tips for this session. Register a free account to unlock unlimited tips!',
              textAlign: TextAlign.center,
              style: AppTypography.body(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, '/auth');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coral,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Create Free Account',
                style: AppTypography.montserrat(
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final String? badge;
  final bool isGated;

  const _SectionLabel({
    required this.title,
    this.badge,
    this.isGated = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.blue,
          ),
        ),
        if (badge != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.cardBg2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badge!,
              style: AppTypography.montserrat(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: AppColors.blue,
              ),
            ),
          ),
        ] else if (isGated) ...[
          Row(
            children: [
              const Icon(Icons.lock_rounded, size: 12, color: AppColors.coral),
              const SizedBox(width: 4),
              Text(
                'Free sign-up',
                style: AppTypography.montserrat(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coral,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _QuickTipCard extends StatelessWidget {
  final Map<String, dynamic> tip;
  final bool enabled;
  final VoidCallback onTap;

  const _QuickTipCard({
    required this.tip,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = tip['content'] as String? ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.6)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.cardBg2,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.lightbulb_outline_rounded, color: AppColors.blue, size: 20),
        ),
        title: Text(
          content,
          style: AppTypography.body(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.darkGrey),
      ),
    );
  }
}

class _VideoActionCard extends StatelessWidget {
  final Map<String, dynamic> video;
  final bool isGated;
  final VoidCallback onTap;

  const _VideoActionCard({
    required this.video,
    required this.isGated,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = video['title'] as String? ?? 'Video Solution';
    final durationSec = (video['durationSec'] as num?)?.toInt() ?? 180;
    final minutes = (durationSec / 60).ceil();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.6)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isGated ? AppColors.softGrey : AppColors.cardBg3,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isGated ? Icons.lock_outline_rounded : Icons.play_arrow_rounded,
            color: isGated ? AppColors.darkGrey : AppColors.coral,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: AppTypography.montserrat(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        subtitle: Text(
          '$minutes min walkthrough',
          style: AppTypography.body(fontSize: 12),
        ),
        trailing: isGated
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.cardBg3,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Unlock',
                  style: AppTypography.montserrat(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coral,
                  ),
                ),
              )
            : const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.darkGrey),
      ),
    );
  }
}

class _AssessmentActionCard extends StatelessWidget {
  final Map<String, dynamic> assessment;
  final bool isGated;
  final VoidCallback onTap;

  const _AssessmentActionCard({
    required this.assessment,
    required this.isGated,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = assessment['title'] as String? ?? 'Quick Assessment';
    final questionCount = (assessment['questionCount'] as num?)?.toInt() ?? 5;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.6)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isGated ? AppColors.softGrey : AppColors.cardBg2,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isGated ? Icons.lock_outline_rounded : Icons.quiz_outlined,
            color: isGated ? AppColors.darkGrey : AppColors.blue,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: AppTypography.montserrat(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        subtitle: Text(
          '$questionCount questions · Instant feedback',
          style: AppTypography.body(fontSize: 12),
        ),
        trailing: isGated
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.cardBg3,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Unlock',
                  style: AppTypography.montserrat(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coral,
                  ),
                ),
              )
            : const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.darkGrey),
      ),
    );
  }
}

