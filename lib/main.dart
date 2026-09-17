// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/recommendation_provider.dart';
import 'providers/analytics_provider.dart';
import 'theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const ConfiCircleApp());
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

/// Root widget — manages the full app navigation flow.
///
/// Flow:
///   Splash → Auth (Login / Sign Up)
///     ├─ Sign Up (new user)  → Onboarding → MainShell
///     │                         HomeScreen shows first-time layout
///     │                         (6 cards + Discover My Confi + Tools + Did You Know)
///     │                         After assessment → HomeScreen shows returning layout
///     └─ Log In (existing)   → MainShell
///                               HomeScreen shows returning-user full dashboard
///
/// [isFirstTime] stays true until [UserProvider.completeAssessment()] is called.
/// The bottom nav bar (MainShell) is ALWAYS present after auth.
class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  bool _splashDone = false;
  bool _authDone = false;
  bool _onboardingDone = false;

  @override
  Widget build(BuildContext context) {
    // 1. Splash
    if (!_splashDone) {
      return SplashScreen(
        onComplete: () => setState(() => _splashDone = true),
      );
    }

    // 2. Auth gate — Login or Sign Up
    if (!_authDone) {
      return AuthScreen(
        onAuthComplete: () => setState(() => _authDone = true),
      );
    }

    final userProvider = context.watch<UserProvider>();

    // 3. Onboarding — only for new (first-time) users, once per install
    if (!_onboardingDone && userProvider.isFirstTime) {
      return OnboardingScreen(
        onComplete: () {
          userProvider.completeOnboarding();
          setState(() => _onboardingDone = true);
        },
      );
    }

    // 4. Always show MainShell (has bottom nav).
    //    HomeScreen inside it reads isFirstTime and shows the right layout.
    return const MainShell();
  }
}
