// test/core/widgets/loading_state_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:conficircle/core/widgets/loading_state_widget.dart';
import 'package:conficircle/core/widgets/error_view.dart';
import 'package:conficircle/core/widgets/access_denied_view.dart';
import 'package:conficircle/core/widgets/skeleton_loader.dart';
import 'package:conficircle/core/error/app_error.dart';
import 'package:conficircle/core/error/error_codes.dart';

void main() {
  group('LoadingStateWidget', () {
    testWidgets('renders loading state with SkeletonListLoader', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingStateWidget<String>(
              value: const AsyncLoading(),
              builder: (data) => Text(data),
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonListLoader), findsOneWidget);
    });

    testWidgets('renders success state with content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingStateWidget<String>(
              value: const AsyncData('Hello ConfCircle'),
              builder: (data) => Text(data),
            ),
          ),
        ),
      );

      expect(find.text('Hello ConfCircle'), findsOneWidget);
    });

    testWidgets('renders empty state when isEmpty returns true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingStateWidget<List<String>>(
              value: const AsyncData([]),
              isEmpty: (list) => list.isEmpty,
              builder: (data) => Text('Count: ${data.length}'),
              emptyBuilder: () => const Text('Nothing here yet'),
            ),
          ),
        ),
      );

      expect(find.text('Nothing here yet'), findsOneWidget);
    });

    testWidgets('renders error state with retry button', (tester) async {
      bool retried = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingStateWidget<String>(
              value: AsyncError(
                const AppError(code: ErrorCode.networkError, message: 'Failed to load'),
                StackTrace.empty,
              ),
              builder: (data) => Text(data),
              onRetry: () => retried = true,
            ),
          ),
        ),
      );

      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('Failed to load'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      expect(retried, isTrue);
    });

    testWidgets('renders access-denied state with sign in CTA', (tester) async {
      bool signInTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingStateWidget<String>(
              value: AsyncError(
                const AppError(code: ErrorCode.accountRequired, message: 'Account required for this feature'),
                StackTrace.empty,
              ),
              builder: (data) => Text(data),
              onSignIn: () => signInTapped = true,
            ),
          ),
        ),
      );

      expect(find.byType(AccessDeniedView), findsOneWidget);
      expect(find.text('Sign In / Register'), findsOneWidget);

      await tester.tap(find.text('Sign In / Register'));
      expect(signInTapped, isTrue);
    });
  });
}
