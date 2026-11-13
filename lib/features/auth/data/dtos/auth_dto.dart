// lib/features/auth/data/dtos/auth_dto.dart
import 'package:json_annotation/json_annotation.dart';

part 'auth_dto.g.dart';

// ---------------------------------------------------------------------------
// User DTO
// ---------------------------------------------------------------------------

@JsonSerializable()
class UserDto {
  const UserDto({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.role = 'student',
    this.isFirstTime = false,
  });

  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final String role;
  final bool isFirstTime;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

// ---------------------------------------------------------------------------
// Login
// ---------------------------------------------------------------------------

@JsonSerializable()
class LoginRequestDto {
  const LoginRequestDto({required this.email, required this.password});

  final String email;
  final String password;

  factory LoginRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);
}

// ---------------------------------------------------------------------------
// Register
// ---------------------------------------------------------------------------

@JsonSerializable()
class RegisterRequestDto {
  const RegisterRequestDto({
    required this.email,
    required this.password,
    required this.displayName,
  });

  final String email;
  final String password;
  final String displayName;

  factory RegisterRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestDtoToJson(this);
}

// ---------------------------------------------------------------------------
// Auth Response
// ---------------------------------------------------------------------------

@JsonSerializable()
class AuthResponseDto {
  const AuthResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final UserDto user;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseDtoToJson(this);
}

// ---------------------------------------------------------------------------
// Refresh Request
// ---------------------------------------------------------------------------

@JsonSerializable()
class RefreshRequestDto {
  const RefreshRequestDto({required this.refreshToken});

  final String refreshToken;

  factory RefreshRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshRequestDtoToJson(this);
}
