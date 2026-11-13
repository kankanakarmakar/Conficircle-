// lib/core/widgets/loading_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../error/app_error.dart';
import '../error/error_codes.dart';
import 'access_denied_view.dart';
import 'error_view.dart';
import 'skeleton_loader.dart';

/// A generic widget that handles all five async UI states for a [AsyncValue].
///
/// States handled:
///   1. **loading** → shimmer skeleton placeholder
///   2. **error (access denied)** → [AccessDeniedView]
///   3. **error** → [ErrorView] with retry button
///   4. **data (empty)** → custom [emptyBuilder] or default empty message
///   5. **data** → [builder] with the actual data
class LoadingStateWidget<T> extends StatelessWidget {
  const LoadingStateWidget({
    super.key,
    required this.value,
    required this.builder,
    this.onRetry,
    this.onSignIn,
    this.emptyBuilder,
    this.isEmpty,
    this.loadingWidget,
  });

  /// The async value to observe.
  final AsyncValue<T> value;

  /// Builder for the success state.
  final Widget Function(T data) builder;

  /// Called when the user taps "Retry" in [ErrorView].
  final VoidCallback? onRetry;

  /// Called when the user taps "Sign In" in [AccessDeniedView].
  final VoidCallback? onSignIn;

  /// Custom builder for the empty state. Falls back to a simple message.
  final Widget Function()? emptyBuilder;

  /// Predicate to determine if the loaded data should show the empty state.
  final bool Function(T data)? isEmpty;

  /// Custom loading widget; defaults to [SkeletonLoader].
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () =>
          loadingWidget ??
          const Padding(
            padding: EdgeInsets.all(16),
            child: SkeletonListLoader(),
          ),
      error: (error, _) {
        // Check if error is access-denied type.
        if (error is AppError &&
            (error.code == ErrorCode.accountRequired ||
                error.code == ErrorCode.forbidden)) {
          return AccessDeniedView(
            onSignIn: onSignIn ?? () {},
            message: error.message,
          );
        }
        return ErrorView(
          message: error is AppError
              ? error.message
              : 'Something went wrong. Please try again.',
          onRetry: onRetry,
        );
      },
      data: (data) {
        if (isEmpty != null && isEmpty!(data)) {
          return emptyBuilder?.call() ??
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Nothing here yet.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
        }
        return builder(data);
      },
    );
  }
}
