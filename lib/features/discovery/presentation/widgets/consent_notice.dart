// lib/features/discovery/presentation/widgets/consent_notice.dart
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';

class ConsentNotice extends StatelessWidget {
  final bool hasConsented;
  final ValueChanged<bool> onConsentChanged;

  const ConsentNotice({
    super.key,
    required this.hasConsented,
    required this.onConsentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: hasConsented,
            activeColor: AppColors.blue,
            onChanged: (val) => onConsentChanged(val ?? true),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy & Personalisation Consent',
                  style: AppTypography.montserrat(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Your selected concerns are stored securely to tailor your discovery feed. We never share or expose your personal selections in public feeds.',
                  style: AppTypography.body(fontSize: 11, color: AppColors.darkGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

