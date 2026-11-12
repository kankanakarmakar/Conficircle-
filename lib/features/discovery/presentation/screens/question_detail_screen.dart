// lib/features/discovery/presentation/screens/question_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../domain/entities/question_detail_entity.dart';
import '../providers/discovery_provider.dart';
import '../widgets/question_header.dart';
import '../widgets/content_action_list.dart';

class QuestionDetailScreen extends ConsumerStatefulWidget {
  final String questionId;
  const QuestionDetailScreen({super.key, required this.questionId});

  @override
  ConsumerState<QuestionDetailScreen> createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends ConsumerState<QuestionDetailScreen> {
  QuestionDetailEntity? _detail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final repo = ref.read(discoveryRepositoryProvider);
      final res = await repo.getQuestionDetail(widget.questionId);
      if (mounted) {
        setState(() {
          _detail = res;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.softGrey,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.coral),
        ),
      );
    }

    if (_error != null || _detail == null) {
      return Scaffold(
        backgroundColor: AppColors.softGrey,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.coral),
                const SizedBox(height: 12),
                Text(
                  'Failed to load question details',
                  style: AppTypography.headingSmall,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadDetail,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final detail = _detail!;

    return Scaffold(
      backgroundColor: AppColors.softGrey,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question-led header (Headline Level 4 context)
            QuestionHeader(
              prompt: detail.prompt,
              shortDescription: detail.shortDescription,
              onBack: () => Navigator.pop(context),
            ),

            // Permitted content actions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
              child: ContentActionList(
                detail: detail,
                onOpenQuickTip: () {
                  _showTipDialog(context, detail);
                },
                onOpenVideo: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening video solution player...')),
                  );
                },
                onOpenAssessment: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Starting quick assessment...')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTipDialog(BuildContext context, QuestionDetailEntity detail) {
    final tipContent = detail.quickTips.isNotEmpty
        ? (detail.quickTips.first['content'] as String? ?? 'Keep practicing with focus!')
        : 'Take a deep breath and pause for 3 seconds before responding.';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.lightbulb_rounded, color: AppColors.coral),
            const SizedBox(width: 8),
            Text(
              'Quick Tip',
              style: AppTypography.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.blue,
              ),
            ),
          ],
        ),
        content: Text(
          tipContent,
          style: AppTypography.body(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Got It',
              style: AppTypography.montserrat(
                fontWeight: FontWeight.w700,
                color: AppColors.coral,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

