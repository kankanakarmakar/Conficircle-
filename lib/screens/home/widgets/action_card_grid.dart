// lib/screens/home/widgets/action_card_grid.dart
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../features/discovery/domain/entities/question_prompt_entity.dart';
import '../../../features/discovery/domain/entities/discovery_batch_entity.dart';
import '../../../features/discovery/data/repositories/discovery_repository.dart';
import '../../../features/discovery/presentation/widgets/question_card.dart';
import '../../../features/discovery/presentation/widgets/shuffle_control.dart';
import '../../../features/discovery/presentation/widgets/discovery_states.dart';
import '../../../features/discovery/presentation/screens/question_detail_screen.dart';
import '../../../core/guest/guest_storage.dart';
import '../../../core/api_client/api_client.dart';

class ActionCardGrid extends StatefulWidget {
  const ActionCardGrid({super.key});

  @override
  State<ActionCardGrid> createState() => _ActionCardGridState();
}

class _ActionCardGridState extends State<ActionCardGrid> {
  late DiscoveryRepository _repository;
  List<QuestionPromptEntity> _questions = [];
  String _batchId = '';
  bool _isLoading = true;
  bool _isShuffling = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _repository = DiscoveryRepositoryImpl();
    _loadBatch();
  }

  Future<void> _loadBatch() async {
    setState(() {
      _isLoading = _questions.isEmpty;
      _error = null;
    });

    try {
      // Spec v3.0 §2: Guest audience receives 7–8 randomly selected Level 4 questions (default: 8)
      final batch = await _repository.getGuestQuestionBatch(limit: 8);
      if (mounted) {
        setState(() {
          _batchId = batch.batchId;
          _questions = batch.items;
          _isLoading = false;
          _isShuffling = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load guest discovery questions.';
        });
      }
    }
  }

  Future<void> _shuffle() async {
    // Spec v3.0 §3 & §11: Immutable batch state.
    // Current batch remains visible until the new batch succeeds.
    setState(() {
      _isShuffling = true;
      _error = null;
    });

    try {
      final excluded = _questions.map((q) => q.questionId).toList();
      final batch = await _repository.shuffleGuestQuestionBatch(
        previousBatchId: _batchId,
        excludedIds: excluded,
      );
      if (mounted) {
        setState(() {
          _batchId = batch.batchId;
          _questions = batch.items;
          _isShuffling = false;
        });
      }
    } catch (e) {
      if (mounted) {
        // Keep current cards visible if shuffle request fails
        setState(() {
          _isShuffling = false;
          _error = 'Could not shuffle batch. Showing current cards.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Shuffle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discover Challenges',
                    style: AppTypography.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '7–8 questions to jumpstart your confidence',
                    style: AppTypography.body(fontSize: 11, color: AppColors.darkGrey),
                  ),
                ],
              ),
              ShuffleControl(
                isShuffling: _isShuffling,
                onShuffle: _shuffle,
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (_error != null) ...[
            DiscoveryRetryState(
              message: _error!,
              onRetry: _loadBatch,
            ),
          ],

          if (_isLoading && _questions.isEmpty) ...[
            const DiscoveryLoadingSkeleton(count: 7),
          ] else if (_questions.isEmpty) ...[
            DiscoveryEmptyState(onRefresh: _loadBatch),
          ] else ...[
            // 7–8 Level 4 Question Cards (immutable batch)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                return QuestionCard(
                  item: question,
                  onTap: () {
                    _repository.recordDiscoveryEvent(
                      eventType: 'selection',
                      questionId: question.questionId,
                      metadata: {'batchId': _batchId, 'audience': 'guest'},
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuestionDetailScreen(questionId: question.questionId),
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
