// lib/features/guest/domain/entities/guest_session_entity.dart

/// Domain entity for a guest session.
class GuestSessionEntity {
  const GuestSessionEntity({
    required this.guestRef,
    required this.questionsAnswered,
    required this.quotaLimit,
  });

  final String guestRef;
  final int questionsAnswered;
  final int quotaLimit;

  bool get isQuotaExhausted => questionsAnswered >= quotaLimit;

  int get remainingQuestions => (quotaLimit - questionsAnswered).clamp(0, quotaLimit);
}
