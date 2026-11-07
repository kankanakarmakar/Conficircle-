// lib/features/guest/data/dtos/guest_dto.dart
import 'package:json_annotation/json_annotation.dart';

part 'guest_dto.g.dart';

@JsonSerializable()
class CreateGuestSessionResponseDto {
  const CreateGuestSessionResponseDto({
    required this.guestRef,
    required this.quotaLimit,
  });

  final String guestRef;
  final int quotaLimit;

  factory CreateGuestSessionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CreateGuestSessionResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateGuestSessionResponseDtoToJson(this);
}

@JsonSerializable()
class GuestSessionStatusDto {
  const GuestSessionStatusDto({
    required this.guestRef,
    required this.questionsAnswered,
    required this.quotaLimit,
  });

  final String guestRef;
  final int questionsAnswered;
  final int quotaLimit;

  factory GuestSessionStatusDto.fromJson(Map<String, dynamic> json) =>
      _$GuestSessionStatusDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GuestSessionStatusDtoToJson(this);
}
