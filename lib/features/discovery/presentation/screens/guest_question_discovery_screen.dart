// lib/features/discovery/presentation/screens/guest_question_discovery_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../providers/discovery_provider.dart';
import '../widgets/question_card.dart';
import '../widgets/shuffle_control.dart';
import '../widgets/discovery_states.dart';
import 'question_detail_screen.dart';

class GuestQuestionDiscoveryScreen extends ConsumerStatefulWidget {
  const GuestQuestionDiscoveryScreen({super.key});

  @override
  ConsumerState<GuestQuestionDiscoveryScreen> createState() =>
      _GuestQuestionDiscoveryScreenState();
}

class _GuestQuestionDiscoveryScreenState
    extends ConsumerState<GuestQuestionDiscoveryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(guestDiscoveryProvider.notifier).loadBatch(limit: 8);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(guestDiscoveryProvider);

    return Container(
      color: AppColors.softGrey,
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
                    'Discover Questions',
                    style: AppTypography.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Real-world situations you can explore right now',
                    style: AppTypography.body(fontSize: 11.5, color: AppColors.darkGrey),
                  ),
                ],
              ),
              ShuffleControl(
                isShuffling: state.isShuffling,
                onShuffle: () => ref.read(guestDiscoveryProvider.notifier).shuffle(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Error retry banner if shuffle or load failed (keeps current cards visible)
          if (state.error != null) ...[
            DiscoveryRetryState(
              message: state.error!,
              onRetry: () => ref.read(guestDiscoveryProvider.notifier).loadBatch(limit: 8),
            ),
          ],

          // Loading skeleton on first load
          if (state.isLoading && state.items.isEmpty) ...[
            const DiscoveryLoadingSkeleton(count: 7),
          ] else if (state.items.isEmpty) ...[
            DiscoveryEmptyState(
              onRefresh: () => ref.read(guestDiscoveryProvider.notifier).loadBatch(limit: 8),
            ),
          ] else ...[
            // 7–8 Level 4 Question Cards (immutable batch)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return QuestionCard(
                  item: item,
                  onTap: () {
                    ref.read(guestDiscoveryProvider.notifier).recordSelection(item.questionId);
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

