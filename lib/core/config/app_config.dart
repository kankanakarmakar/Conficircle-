// lib/core/config/app_config.dart
import 'package:json_annotation/json_annotation.dart';

part 'app_config.g.dart';

/// Remote configuration model fetched from the backend.
@JsonSerializable()
class AppConfig {
  const AppConfig({
    required this.minAppVersion,
    required this.maintenanceMode,
    required this.guestQuotaLimit,
    required this.featureFlags,
  });

  /// Minimum required app version string (e.g. "1.2.0").
  final String minAppVersion;

  /// When true, the app shows a maintenance screen.
  final bool maintenanceMode;

  /// Maximum number of questions a guest can answer before being prompted.
  final int guestQuotaLimit;

  /// Map of feature-flag names to their enabled state.
  final Map<String, bool> featureFlags;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);

  /// Sensible defaults used before remote config is loaded.
  factory AppConfig.defaults() => const AppConfig(
        minAppVersion: '1.0.0',
        maintenanceMode: false,
        guestQuotaLimit: 5,
        featureFlags: {},
      );
}
