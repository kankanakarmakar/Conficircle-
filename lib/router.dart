// lib/router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/main_shell.dart';
import 'screens/assessment/assessment_screen.dart';
import 'screens/assessment/assessment_result_screen.dart';
import 'screens/resources/resource_detail_screen.dart';
import 'screens/circle/group_detail_screen.dart';
import 'features/discovery/presentation/screens/question_detail_screen.dart';
import 'features/discovery/presentation/screens/problem_profile_screen.dart';
import 'core/auth/token_manager.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => SplashScreen(
          onComplete: () => context.go('/home'),
        ),
      ),
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => AuthScreen(
          onAuthComplete: () => context.go('/home'),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainShell(),
      ),
      GoRoute(
        path: '/question/:id',
        name: 'question_detail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return QuestionDetailScreen(questionId: id);
        },
      ),
      GoRoute(
        path: '/topic/:id',
        name: 'topic_detail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return QuestionDetailScreen(questionId: id);
        },
      ),
      GoRoute(
        path: '/problem-profile',
        name: 'problem_profile',
        builder: (context, state) => const ProblemProfileScreen(),
      ),
      GoRoute(
        path: '/assessment/:id',
        name: 'assessment',
        builder: (context, state) => const AssessmentScreen(),
      ),
      GoRoute(
        path: '/assessment/:id/result',
        name: 'assessment_result',
        builder: (context, state) => const AssessmentResultScreen(),
      ),
      GoRoute(
        path: '/resource/:id',
        name: 'resource_detail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ResourceDetailScreen(resourceId: id);
        },
      ),
      GoRoute(
        path: '/group/:id',
        name: 'group_detail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return GroupDetailScreen(groupId: id);
        },
      ),
    ],
  );
});

