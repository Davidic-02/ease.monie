part of 'location_bloc.dart';

@freezed
class LocationEvent with _$LocationEvent {
  const factory LocationEvent.init() = _Init;
  const factory LocationEvent.requestPermissions({
    @Default(true) bool shouldShowRationale,
  }) = _RequestPermissions;
  const factory LocationEvent.beginStreamingLocation() =
      _BeginStreamingLocation;
  const factory LocationEvent.stopStreamingLocation() = _StopStreamingLocation;
  const factory LocationEvent.newLocation(Position position) = _NewLocation;
  const factory LocationEvent.setShowRationale(bool showRationale) =
      _SetShowRationale;
}
