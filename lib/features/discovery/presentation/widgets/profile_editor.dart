// lib/features/discovery/presentation/widgets/profile_editor.dart
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';

class ProfileEditor extends StatelessWidget {
  final String concernPromptText;
  final String currentStatus; // 'active' | 'paused'
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onRemove;

  const ProfileEditor({
    super.key,
    required this.concernPromptText,
    required this.currentStatus,
    required this.onStatusChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isPaused = currentStatus == 'paused';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Manage Challenge',
                style: AppTypography.headingSmall,
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            concernPromptText,
            style: AppTypography.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(height: 20),

          // Pause / Resume toggle
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
              color: AppColors.blue,
            ),
            title: Text(
              isPaused ? 'Resume Challenge' : 'Pause Challenge',
              style: AppTypography.montserrat(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              isPaused
                  ? 'Start including questions for this concern again'
                  : 'Temporarily exclude questions related to this challenge',
              style: AppTypography.body(fontSize: 11.5),
            ),
            onTap: () {
              onStatusChanged(isPaused ? 'active' : 'paused');
              Navigator.pop(context);
            },
          ),

          const Divider(),

          // Remove
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.delete_outline_rounded, color: AppColors.coral),
            title: Text(
              'Remove from Profile',
              style: AppTypography.montserrat(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.coral,
              ),
            ),
            subtitle: Text(
              'Stop personalising recommendations for this challenge',
              style: AppTypography.body(fontSize: 11.5),
            ),
            onTap: () {
              onRemove();
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

