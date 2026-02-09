part of 'map_bloc.dart';

@freezed
abstract class MapState with _$MapState {
  const MapState._();

  const factory MapState({
    Position? currentLocation,
    @Default(true) bool isLocationServiceEnabled,
    @Default(LocationPermission.denied) LocationPermission permissionStatus,
    StreamSubscription<Position>? locationSubscription,
    @Default(false) bool showRationale,
    @Default(false) bool hasShownRationale,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus mapStatus,
  }) = _MapState;
}
