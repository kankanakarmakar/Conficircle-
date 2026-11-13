// lib/screens/confizone/confizone_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'confizone_intro_screen.dart';
import 'confizone_main_screen.dart';

class ConfiZoneScreen extends StatelessWidget {
  const ConfiZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().profile;

    // Show intro only if: not completed, no assessment, not skipped
    final showIntro = !user.confizoneIntroCompleted &&
        !user.hasCompletedAssessment &&
        !user.confizoneIntroSkipped;

    if (showIntro) {
      return const ConfiZoneIntroScreen();
    }
    return const ConfiZoneMainScreen();
  }
}
