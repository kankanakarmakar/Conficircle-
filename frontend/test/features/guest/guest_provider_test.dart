// test/features/guest/guest_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:conficircle/features/guest/domain/entities/guest_session_entity.dart';

void main() {
  group('GuestSessionEntity', () {
    test('isQuotaExhausted returns true when answered >= quotaLimit', () {
      const session = GuestSessionEntity(
        guestRef: 'test-guest-ref',
        questionsAnswered: 3,
        quotaLimit: 3,
      );

      expect(session.isQuotaExhausted, isTrue);
      expect(session.remainingQuestions, 0);
    });

    test('isQuotaExhausted returns false when answered < quotaLimit', () {
      const session = GuestSessionEntity(
        guestRef: 'test-guest-ref',
        questionsAnswered: 1,
        quotaLimit: 3,
      );

      expect(session.isQuotaExhausted, isFalse);
      expect(session.remainingQuestions, 2);
    });
  });
}

