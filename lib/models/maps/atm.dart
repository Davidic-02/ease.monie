import 'package:freezed_annotation/freezed_annotation.dart';

part 'atm.freezed.dart';
part 'atm.g.dart';

@freezed
abstract class ATM with _$ATM {
  const factory ATM({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    required int distance, // in meters
    required int estimatedTime, // in minutes
    required String address,
    @Default('Open') String status,
    @Default('') String branchCode,
    @Default(false) bool wheelchairAccessible,
    @Default('') String operatingHours,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
  }) = _ATM;

  factory ATM.fromJson(Map<String, dynamic> json) => _$ATMFromJson(json);
}
