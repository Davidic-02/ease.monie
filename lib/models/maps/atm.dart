import 'package:freezed_annotation/freezed_annotation.dart';

part 'atm.freezed.dart';
part 'atm.g.dart';

@freezed
abstract class ATM with _$ATM {
  const ATM._();

  const factory ATM({
    @JsonKey(name: 'place_id') required String id,
    required String name,
    @JsonKey(name: 'vicinity') String? address,
    required ATMGeometry geometry,
    @JsonKey(name: 'business_status') String? businessStatus,
    @JsonKey(name: 'opening_hours') ATMOpeningHours? openingHours,
    @Default(0.0) double rating,
    @JsonKey(name: 'user_ratings_total') @Default(0) int reviewCount,
    String? icon,
    @Default([]) List<ATMPhoto> photos,
    @Default([]) List<String> types,
  }) = _ATM;

  factory ATM.fromJson(Map<String, dynamic> json) => _$ATMFromJson(json);

  // convenience getters so the rest of your code still works
  double get latitude => geometry.location.lat;
  double get longitude => geometry.location.lng;
  bool get isOpen => openingHours?.openNow ?? false;
  String get statusLabel => isOpen ? 'Open' : 'Closed';
}

@freezed
abstract class ATMGeometry with _$ATMGeometry {
  const factory ATMGeometry({required ATMLocation location}) = _ATMGeometry;

  factory ATMGeometry.fromJson(Map<String, dynamic> json) =>
      _$ATMGeometryFromJson(json);
}

@freezed
abstract class ATMLocation with _$ATMLocation {
  const factory ATMLocation({required double lat, required double lng}) =
      _ATMLocation;

  factory ATMLocation.fromJson(Map<String, dynamic> json) =>
      _$ATMLocationFromJson(json);
}

@freezed
abstract class ATMOpeningHours with _$ATMOpeningHours {
  const factory ATMOpeningHours({
    @JsonKey(name: 'open_now') @Default(false) bool openNow,
  }) = _ATMOpeningHours;

  factory ATMOpeningHours.fromJson(Map<String, dynamic> json) =>
      _$ATMOpeningHoursFromJson(json);
}

@freezed
abstract class ATMPhoto with _$ATMPhoto {
  const factory ATMPhoto({
    @JsonKey(name: 'photo_reference') required String photoReference,
    @Default(0) int height,
    @Default(0) int width,
  }) = _ATMPhoto;

  factory ATMPhoto.fromJson(Map<String, dynamic> json) =>
      _$ATMPhotoFromJson(json);
}
