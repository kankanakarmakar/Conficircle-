// lib/features/discovery/presentation/screens/registered_question_discovery_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../providers/discovery_provider.dart';
import '../widgets/question_card.dart';
import '../widgets/shuffle_control.dart';
import '../widgets/discovery_states.dart';
import 'question_detail_screen.dart';
import 'problem_profile_screen.dart';

class RegisteredQuestionDiscoveryScreen extends ConsumerStatefulWidget {
  const RegisteredQuestionDiscoveryScreen({super.key});

  @override
  ConsumerState<RegisteredQuestionDiscoveryScreen> createState() =>
      _RegisteredQuestionDiscoveryScreenState();
}

class _RegisteredQuestionDiscoveryScreenState
    extends ConsumerState<RegisteredQuestionDiscoveryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(registeredDiscoveryProvider.notifier).loadBatch(limit: 6);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registeredDiscoveryProvider);

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Row with Shuffle Control ─────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Questions for You',
                    style: AppTypography.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Personalised challenges & actionable guidance',
                    style: AppTypography.body(fontSize: 11.5, color: AppColors.darkGrey),
                  ),
                ],
              ),
              ShuffleControl(
                isShuffling: state.isShuffling,
                onShuffle: () => ref.read(registeredDiscoveryProvider.notifier).shuffle(),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Personalise Discovery Concerns CTA ──────────────────────
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProblemProfileScreen()),
              );
              // Refresh batch after profile edits
              ref.read(registeredDiscoveryProvider.notifier).loadBatch(limit: 6);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: AppColors.softBlueGradient,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightBlue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tune_rounded, size: 18, color: AppColors.blue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personalise your questions',
                          style: AppTypography.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blue,
                          ),
                        ),
                        Text(
                          'Select your current challenges to tailor your questions',
                          style: AppTypography.body(fontSize: 11, color: AppColors.darkGrey),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.blue),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Error banner
          if (state.error != null) ...[
            DiscoveryRetryState(
              message: state.error!,
              onRetry: () => ref.read(registeredDiscoveryProvider.notifier).loadBatch(limit: 6),
            ),
          ],

          // Loading skeleton on first load
          if (state.isLoading && state.items.isEmpty) ...[
            const DiscoveryLoadingSkeleton(count: 5),
          ] else if (state.items.isEmpty) ...[
            DiscoveryEmptyState(
              onRefresh: () => ref.read(registeredDiscoveryProvider.notifier).loadBatch(limit: 6),
            ),
          ] else ...[
            // 5–6 Level 4 Question Cards (immutable batch)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return QuestionCard(
                  item: item,
                  onTap: () {
                    ref.read(registeredDiscoveryProvider.notifier).recordSelection(item.questionId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuestionDetailScreen(questionId: item.questionId),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

