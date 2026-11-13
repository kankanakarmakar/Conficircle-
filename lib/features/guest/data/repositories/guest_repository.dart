// lib/features/guest/data/repositories/guest_repository.dart
import 'package:dio/dio.dart';
import '../../../../core/api_client/api_client.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/guest/guest_storage.dart';
import '../../domain/entities/guest_session_entity.dart';
import '../dtos/guest_dto.dart';

abstract class GuestRepository {
  Future<GuestSessionEntity> getOrCreateSession();
  Future<List<Map<String, dynamic>>> getGuestQuestions();
  Future<Map<String, dynamic>> openQuickTip(String quickTipId, String idempotencyKey);
}

class GuestRepositoryImpl implements GuestRepository {
  GuestRepositoryImpl({
    required this.dio,
    required this.guestStorage,
  });

  final Dio dio;
  final GuestStorage guestStorage;

  @override
  Future<GuestSessionEntity> getOrCreateSession() async {
    try {
      final existingRef = await guestStorage.getGuestRef();
      if (existingRef != null && existingRef.isNotEmpty) {
        return GuestSessionEntity(
          guestRef: existingRef,
          questionsAnswered: 0,
          quotaLimit: 3,
        );
      }

      final response = await dio.post<Map<String, dynamic>>('/v1/guest/session');
      final data = response.data!;
      final guestRef = data['guestRef'] as String;
      final quota = (data['quotaRemaining'] as num?)?.toInt() ?? 3;

      await guestStorage.saveGuestRef(guestRef);

      return GuestSessionEntity(
        guestRef: guestRef,
        questionsAnswered: 0,
        quotaLimit: quota,
      );
    } on DioException catch (e) {
      throw AppError.fromDio(e);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getGuestQuestions() async {
    try {
      final guestRef = await guestStorage.getGuestRef();
      final response = await dio.get<List<dynamic>>(
        '/v1/guest/questions',
        options: Options(headers: {'X-Guest-Ref': guestRef}),
      );
      return (response.data ?? []).cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw AppError.fromDio(e);
    }
  }

  @override
  Future<Map<String, dynamic>> openQuickTip(String quickTipId, String idempotencyKey) async {
    try {
      final guestRef = await guestStorage.getGuestRef();
      final response = await dio.post<Map<String, dynamic>>(
        '/v1/quicktips/$quickTipId/open',
        options: Options(headers: {
          'X-Guest-Ref': guestRef,
          'Idempotency-Key': idempotencyKey,
        }),
      );
      return response.data!;
    } on DioException catch (e) {
      throw AppError.fromDio(e);
    }
  }
}

