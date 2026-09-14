// lib/screens/circle/widgets/group_card.dart
import 'package:flutter/material.dart';
import '../../../models/group.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../group_detail_screen.dart';

class GroupCard extends StatefulWidget {
  final Group group;
  final bool initiallyJoined;

  const GroupCard({
    super.key,
    required this.group,
    this.initiallyJoined = false,
  });

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  late bool _joined;

  @override
  void initState() {
    super.initState();
    _joined = widget.initiallyJoined || widget.group.isJoined;
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.group;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GroupDetailScreen(group: g)),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(g.emoji,
                        style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(g.name,
                                style: AppTypography.labelLarge),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: g.type == GroupType.public
                                  ? AppColors.blue.withOpacity(0.1)
                                  : AppColors.coral.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              g.type == GroupType.public
                                  ? '🌐 Public'
                                  : '🔒 Private',
                              style: AppTypography.montserrat(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: g.type == GroupType.public
                                    ? AppColors.blue
                                    : AppColors.coral,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${g.memberCount} members · ${g.category}',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(g.description,
                style: AppTypography.bodyMedium, maxLines: 2),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              children: g.tags
                  .map((t) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.softGrey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '#$t',
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.blue),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: _joined
                  ? OutlinedButton.icon(
                      onPressed: () =>
                          setState(() => _joined = false),
                      icon: const Icon(Icons.check_rounded, size: 16),
                      label: const Text('Joined'),
                    )
                  : ElevatedButton(
                      onPressed: () =>
                          setState(() => _joined = true),
                      child: const Text('Join Circle'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
