// lib/features/discovery/presentation/widgets/discovery_states.dart
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';

class DiscoveryLoadingSkeleton extends StatelessWidget {
  final int count;
  const DiscoveryLoadingSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(count, (index) => const _SkeletonCard()),
    );
  }
}

class _SkeletonCard extends StatefulWidget {
  const _SkeletonCard();

  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        height: 110,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 14,
              width: 220,
              decoration: BoxDecoration(
                color: AppColors.lightGrey.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 18,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Container(
                  height: 18,
                  width: 50,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DiscoveryEmptyState extends StatelessWidget {
  final VoidCallback onRefresh;
  const DiscoveryEmptyState({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.help_outline_rounded, size: 44, color: AppColors.lightBlue),
          const SizedBox(height: 12),
          Text(
            'No Questions Available',
            style: AppTypography.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Check back soon or tap below to fetch candidate prompts.',
            textAlign: TextAlign.center,
            style: AppTypography.body(fontSize: 12.5),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Refresh Questions'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoveryRetryState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const DiscoveryRetryState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg3,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.coral.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.coral, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTypography.body(
                fontSize: 12,
                color: AppColors.coral,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: AppTypography.montserrat(
                fontSize: 12,
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

