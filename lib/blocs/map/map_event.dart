part of 'map_bloc.dart';

@freezed
class MapEvent with _$MapEvent {
  const factory MapEvent.init() = _Init;
  const factory MapEvent.requestPermissions({
    @Default(true) bool shouldShowRationale,
  }) = _RequestPermissions;
  const factory MapEvent.beginStreamingLocation() = _BeginStreamingLocation;
  const factory MapEvent.stopStreamingLocation() = _StopStreamingLocation;
  const factory MapEvent.newLocation(Position position) = _NewLocation;
  const factory MapEvent.setShowRationale(bool showRationale) =
      _SetShowRationale;
}
