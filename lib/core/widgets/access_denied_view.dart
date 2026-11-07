// lib/core/widgets/access_denied_view.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Shown when a feature requires a registered account.
class AccessDeniedView extends StatelessWidget {
  const AccessDeniedView({
    super.key,
    this.message = 'Sign in to access this feature',
    required this.onSignIn,
  });

  final String message;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.softGrey,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 40,
                color: AppColors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Members Only',
              style: AppTypography.headingSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSignIn,
                child: const Text('Sign In / Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
