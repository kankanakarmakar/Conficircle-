// lib/screens/home/widgets/action_card_grid.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/recommendation_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../models/action_item.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../action_detail/action_detail_screen.dart';

class ActionCardGrid extends StatelessWidget {
  const ActionCardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final recProvider = context.watch<RecommendationProvider>();
    final actions = recProvider.visibleActions;

    if (actions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.82,
        ),
        itemCount: actions.length,
        itemBuilder: (context, i) => _ActionCard(item: actions[i]),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final ActionItem item;
  const _ActionCard({required this.item});

  Color _cardColor() {
    try {
      final hex = item.colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppColors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _cardColor();

    return GestureDetector(
      onTap: () {
        context.read<UserProvider>().addClickedAction(item.id);
        context.read<RecommendationProvider>().recordActionClick(item.id);
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => ActionDetailScreen(action: item),
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 8),
            Text(
              item.text,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.montserrat(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
