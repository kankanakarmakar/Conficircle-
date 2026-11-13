// lib/core/config/config_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_config.dart';

/// Riverpod notifier that holds the remote [AppConfig].
///
/// Starts with [AppConfig.defaults()] and is updated after the backend
/// config endpoint is fetched during app startup.
class ConfigNotifier extends Notifier<AppConfig> {
  @override
  AppConfig build() => AppConfig.defaults();

  /// Updates the config from the fetched remote value.
  void update(AppConfig config) => state = config;

  /// Returns true if the named feature flag is enabled.
  bool isFeatureEnabled(String flag) =>
      state.featureFlags[flag] ?? false;
}

/// Riverpod provider for [ConfigNotifier].
final configNotifierProvider =
    NotifierProvider<ConfigNotifier, AppConfig>(ConfigNotifier.new);
