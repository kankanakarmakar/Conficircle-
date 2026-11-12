// lib/features/auth/domain/entities/user_entity.dart

/// Domain entity representing an authenticated user.
class UserEntity {
  const UserEntity({
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

  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    String? role,
    bool? isFirstTime,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isFirstTime: isFirstTime ?? this.isFirstTime,
    );
  }
}
