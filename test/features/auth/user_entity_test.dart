import 'package:flutter_test/flutter_test.dart';
import 'package:conficircle/features/auth/domain/entities/user_entity.dart';
import 'package:conficircle/features/auth/data/dtos/auth_dto.dart';
import 'package:conficircle/features/auth/data/mappers/auth_mapper.dart';

void main() {
  group('UserEntity & AuthMapper', () {
    test('UserEntity retains properties and supports copyWith', () {
      const user = UserEntity(
        id: 'usr-101',
        email: 'dev@confcircle.app',
        displayName: 'Dev User',
        role: 'student',
      );

      expect(user.id, 'usr-101');
      expect(user.email, 'dev@confcircle.app');
      expect(user.displayName, 'Dev User');
      expect(user.isFirstTime, false);

      final updated = user.copyWith(displayName: 'Senior Dev User', isFirstTime: true);
      expect(updated.id, 'usr-101');
      expect(updated.displayName, 'Senior Dev User');
      expect(updated.isFirstTime, true);
    });

    test('AuthMapper maps UserDto to UserEntity correctly', () {
      const dto = UserDto(
        id: 'usr-202',
        email: 'mapper@test.com',
        displayName: 'Mapper Test',
        avatarUrl: 'https://example.com/avatar.png',
        role: 'instructor',
        isFirstTime: true,
      );

      final entity = AuthMapper.toEntity(dto);

      expect(entity.id, 'usr-202');
      expect(entity.email, 'mapper@test.com');
      expect(entity.displayName, 'Mapper Test');
      expect(entity.avatarUrl, 'https://example.com/avatar.png');
      expect(entity.role, 'instructor');
      expect(entity.isFirstTime, true);
    });
  });
}

