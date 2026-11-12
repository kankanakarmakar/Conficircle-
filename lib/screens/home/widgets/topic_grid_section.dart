// lib/screens/home/widgets/topic_grid_section.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../providers/user_provider.dart';
import '../../../features/discovery/domain/entities/question_prompt_entity.dart';
import '../../../features/discovery/domain/entities/discovery_batch_entity.dart';
import '../../../features/discovery/data/repositories/discovery_repository.dart';
import '../../../features/discovery/presentation/widgets/question_card.dart';
import '../../../features/discovery/presentation/widgets/shuffle_control.dart';
import '../../../features/discovery/presentation/widgets/discovery_states.dart';
import '../../../features/discovery/presentation/screens/question_detail_screen.dart';
import '../../../features/discovery/presentation/screens/problem_profile_screen.dart';

class TopicGridSection extends StatefulWidget {
  const TopicGridSection({super.key});

  @override
  State<TopicGridSection> createState() => _TopicGridSectionState();
}

class _TopicGridSectionState extends State<TopicGridSection> {
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

  bool get _isRegistered {
    final user = Provider.of<UserProvider>(context, listen: false).profile;
    return !user.isFirstTime;
  }

  Future<void> _loadBatch() async {
    setState(() {
      _isLoading = _questions.isEmpty;
      _error = null;
    });

    try {
      DiscoveryBatchEntity batch;
      if (_isRegistered) {
        batch = await _repository.getRegisteredQuestionBatch(limit: 6);
      } else {
        batch = await _repository.getGuestQuestionBatch(limit: 8);
      }

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
          _error = 'Failed to load questions. Tap to retry.';
        });
      }
    }
  }

  Future<void> _shuffle() async {
    setState(() {
      _isShuffling = true;
      _error = null;
    });

    try {
      DiscoveryBatchEntity batch;
      final excluded = _questions.map((q) => q.questionId).toList();

      if (_isRegistered) {
        batch = await _repository.shuffleRegisteredQuestionBatch(
          previousBatchId: _batchId,
          excludedIds: excluded,
        );
      } else {
        batch = await _repository.shuffleGuestQuestionBatch(
          previousBatchId: _batchId,
          excludedIds: excluded,
        );
      }

      if (mounted) {
        setState(() {
          _batchId = batch.batchId;
          _questions = batch.items;
          _isShuffling = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isShuffling = false;
          _error = 'Could not fetch a new batch. Showing current questions.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRegistered = _isRegistered;
    final countLabel = _questions.isNotEmpty ? '${_questions.length} Questions' : (isRegistered ? '5-6 Prompts' : '7-8 Prompts');

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Row with Glass Badges and Shuffle ─────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'Questions for You',
                    style: AppTypography.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F2459),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg2.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.lightBlue.withOpacity(0.3)),
                    ),
                    child: Text(
                      countLabel,
                      style: AppTypography.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              ShuffleControl(
                isShuffling: _isShuffling,
                onShuffle: _shuffle,
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(
            'Interactive challenges & actionable guidance tailored for you',
            style: AppTypography.body(fontSize: 11.5, color: AppColors.darkGrey),
          ),

          // ── Registered Problem Profile Glass CTA Banner ──────────
          if (isRegistered) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final changed = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => const ProblemProfileScreen()),
                );
                if (changed == true) {
                  _loadBatch();
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFE8F0FE).withOpacity(0.85),
                          const Color(0xFFD6E4FF).withOpacity(0.65),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.9),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blue.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.tune_rounded, size: 14, color: AppColors.blue),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Tailor questions to your current challenges',
                            style: AppTypography.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 11, color: AppColors.blue),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // ── Error Banner ─────────────────────────────────────────
          if (_error != null) ...[
            DiscoveryRetryState(
              message: _error!,
              onRetry: _loadBatch,
            ),
          ],

          // ── Loading Skeleton / Question Cards ────────────────────
          if (_isLoading && _questions.isEmpty) ...[
            DiscoveryLoadingSkeleton(count: isRegistered ? 5 : 7),
          ] else if (_questions.isEmpty) ...[
            DiscoveryEmptyState(onRefresh: _loadBatch),
          ] else ...[
            // Level 4 Question Prompt Box-Buttons
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
                      metadata: {'batchId': _batchId, 'audience': isRegistered ? 'registered' : 'guest'},
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
