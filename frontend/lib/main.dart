// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/recommendation_provider.dart';
import 'providers/analytics_provider.dart';
import 'theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(
    const rp.ProviderScope(
      child: ConfiCircleApp(),
    ),
  );
}

class ConfiCircleApp extends StatelessWidget {
  const ConfiCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RecommendationProvider()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
      ],
      child: MaterialApp(
        title: 'ConfiCircle',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const _AppRoot(),
      ),
    );
  }
}

/// Root widget — manages seamless navigation between:
/// 1. Duolingo-Grade Welcome Screen (Marvilo Frame 1)
/// 2. Duolingo-Grade 5-Step Onboarding (Marvilo Frames 2 to 12)
/// 3. Main 4-Tab Shell (Home, ConfiZone, Circle, Me)
class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

enum AppFlowState {
  welcome,
  onboarding,
  mainApp,
}

class _AppRootState extends State<_AppRoot> {
  AppFlowState _state = AppFlowState.mainApp; // Default directly to full dashboard for instant exploration

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case AppFlowState.welcome:
        return SplashScreen(
          onGetStarted: () {
            setState(() => _state = AppFlowState.onboarding);
          },
          onAlreadyHaveAccount: () {
            setState(() => _state = AppFlowState.mainApp);
          },
        );

      case AppFlowState.onboarding:
        return OnboardingScreen(
          onComplete: () {
            setState(() => _state = AppFlowState.mainApp);
          },
          onBackToWelcome: () {
            setState(() => _state = AppFlowState.welcome);
          },
        );

      case AppFlowState.mainApp:
        return const MainShell();
    }
  }
}
