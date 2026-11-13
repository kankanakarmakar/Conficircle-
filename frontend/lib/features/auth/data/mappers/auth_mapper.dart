// lib/features/auth/data/mappers/auth_mapper.dart
import '../../domain/entities/user_entity.dart';
import '../dtos/auth_dto.dart';

/// Maps between [UserDto] and [UserEntity].
class AuthMapper {
  const AuthMapper._();

  static UserEntity toEntity(UserDto dto) {
    return UserEntity(
      id: dto.id,
      email: dto.email,
      displayName: dto.displayName,
      avatarUrl: dto.avatarUrl,
      role: dto.role,
      isFirstTime: dto.isFirstTime,
    );
  }
}
