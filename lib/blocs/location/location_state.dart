part of 'location_bloc.dart';

@freezed
abstract class LocationState with _$LocationState {
  const LocationState._();

  const factory LocationState({
    Position? currentLocation,
    @Default(true) bool isLocationServiceEnabled,
    @Default(LocationPermission.denied) LocationPermission permissionStatus,
    StreamSubscription<Position>? locationSubscription,
    @Default(false) bool showRationale,
    @Default(false) bool hasShownRationale,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus mapStatus,
  }) = _LocationState;
}
