// lib/screens/confizone/widgets/confizone_section_widget.dart
import 'package:flutter/material.dart';
import '../../../models/program.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import 'program_tile.dart';

class ConfiZoneSectionWidget extends StatefulWidget {
  final String title;
  final List<Program> programs;

  const ConfiZoneSectionWidget({
    super.key,
    required this.title,
    required this.programs,
  });

  @override
  State<ConfiZoneSectionWidget> createState() => _ConfiZoneSectionWidgetState();
}

class _ConfiZoneSectionWidgetState extends State<ConfiZoneSectionWidget> {
  // Status filter: 0=all, 1=in-progress, 2=completed
  int _statusFilter = 0;

  List<Program> get _filteredPrograms {
    switch (_statusFilter) {
      case 1:
        return widget.programs.where((p) => p.status == ProgramStatus.inProgress).toList();
      case 2:
        return widget.programs.where((p) => p.status == ProgramStatus.completed).toList();
      default:
        // Default: show recent in-progress first, then not-explored, hide completed
        final inProgress = widget.programs.where((p) => p.status == ProgramStatus.inProgress).toList();
        final notExplored = widget.programs.where((p) => p.status == ProgramStatus.notExplored).toList();
        return [...inProgress, ...notExplored].take(3).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final programs = _filteredPrograms;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with status tabs
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(widget.title, style: AppTypography.headingSmall),
                ),
                // Status filters
                _StatusChip(label: 'In Progress', value: 1, current: _statusFilter,
                    onTap: () => setState(() => _statusFilter = _statusFilter == 1 ? 0 : 1)),
                const SizedBox(width: 4),
                _StatusChip(label: 'Completed', value: 2, current: _statusFilter,
                    onTap: () => setState(() => _statusFilter = _statusFilter == 2 ? 0 : 2)),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {},
                  child: Text('More ›',
                      style: AppTypography.labelMedium.copyWith(color: AppColors.coral)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Program tiles grid
          if (programs.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: _buildEmptyState(),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
              child: Row(
                children: programs.map((p) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ProgramTile(program: p),
                  ),
                )).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    if (_statusFilter == 1) {
      return const Text('Nothing in progress yet.',
          style: TextStyle(color: AppColors.darkGrey));
    }
    if (_statusFilter == 2) {
      return const Text('Nothing completed here yet.',
          style: TextStyle(color: AppColors.darkGrey));
    }
    return const Text('No items available.',
        style: TextStyle(color: AppColors.darkGrey));
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final int value, current;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.value,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = value == current;
    final color = value == 1 ? AppColors.coral : AppColors.darkGrey;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? color : Colors.transparent),
        ),
        child: Text(label,
            style: AppTypography.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isActive ? color : AppColors.darkGrey,
            )),
      ),
    );
  }
}
