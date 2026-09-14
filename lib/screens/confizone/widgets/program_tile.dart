// lib/screens/confizone/widgets/program_tile.dart
import 'package:flutter/material.dart';
import '../../../models/program.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class ProgramTile extends StatefulWidget {
  final Program program;
  const ProgramTile({super.key, required this.program});

  @override
  State<ProgramTile> createState() => _ProgramTileState();
}

class _ProgramTileState extends State<ProgramTile> {
  Color _bgColor() {
    try {
      final hex = widget.program.colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppColors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _bgColor();
    final status = widget.program.status;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.program.status == ProgramStatus.notExplored) {
            widget.program.status = ProgramStatus.inProgress;
            widget.program.lastActivityAt = DateTime.now();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: status == ProgramStatus.completed
              ? AppColors.lightGrey
              : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: status == ProgramStatus.inProgress
                ? AppColors.coral
                : status == ProgramStatus.completed
                    ? AppColors.darkGrey.withOpacity(0.3)
                    : color.withOpacity(0.2),
            width: status == ProgramStatus.inProgress ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            if (status == ProgramStatus.inProgress)
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.coral,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('In Progress',
                    style: AppTypography.montserrat(
                      fontSize: 8, fontWeight: FontWeight.w700, color: AppColors.white,
                    )),
              )
            else if (status == ProgramStatus.completed)
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.darkGrey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Completed',
                    style: AppTypography.montserrat(
                      fontSize: 8, fontWeight: FontWeight.w700, color: AppColors.darkGrey,
                    )),
              ),

            // Emoji
            Text(widget.program.emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 6),

            // Name
            Text(widget.program.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.montserrat(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: status == ProgramStatus.completed ? AppColors.darkGrey : color,
                )),
            const SizedBox(height: 4),

            // Description
            Text(widget.program.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(fontSize: 9)),

            if (status == ProgramStatus.notExplored)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('Not Explored',
                    style: AppTypography.montserrat(
                      fontSize: 9, fontWeight: FontWeight.w500, color: AppColors.darkGrey,
                    )),
              ),

            // Price
            if (widget.program.price != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(widget.program.priceLabel,
                    style: AppTypography.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: widget.program.isFree ? const Color(0xFF27AE60) : AppColors.coral,
                    )),
              ),
          ],
        ),
      ),
    );
  }
}
