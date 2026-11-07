// lib/core/config/app_config.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'app_config.dart';

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => AppConfig(
      minAppVersion: json['minAppVersion'] as String,
      maintenanceMode: json['maintenanceMode'] as bool,
      guestQuotaLimit: (json['guestQuotaLimit'] as num).toInt(),
      featureFlags: (json['featureFlags'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, e as bool),
      ),
    );

Map<String, dynamic> _$AppConfigToJson(AppConfig instance) =>
    <String, dynamic>{
      'minAppVersion': instance.minAppVersion,
      'maintenanceMode': instance.maintenanceMode,
      'guestQuotaLimit': instance.guestQuotaLimit,
      'featureFlags': instance.featureFlags,
    };
