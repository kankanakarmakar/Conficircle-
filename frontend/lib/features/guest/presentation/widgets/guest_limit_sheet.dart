// lib/features/guest/presentation/widgets/guest_limit_sheet.dart
import 'package:flutter/material.dart';

class GuestLimitSheet extends StatelessWidget {
  const GuestLimitSheet({
    super.key,
    required this.onSignIn,
    this.message = 'You have reached your free Quick Tip quota as a guest.',
  });

  final VoidCallback onSignIn;
  final String message;

  static Future<void> show(BuildContext context, {required VoidCallback onSignIn}) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => GuestLimitSheet(onSignIn: onSignIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.bolt, color: Colors.amber.shade800, size: 28),
          ),
          const SizedBox(height: 16),
          const Text(
            'Guest Limit Reached',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onSignIn();
              },
              child: const Text('Create Account / Sign In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Not now', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

