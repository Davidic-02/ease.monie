part of 'maps_bloc.dart';

@freezed
class MapsEvent with _$MapEvent {
  const factory MapEvent.started() = _Started;

  const factory MapEvent.requestLocationPermission() =
      _RequestLocationPermission;
  const factory MapEvent.locationPermissionGranted() =
      _LocationPermissionGranted;
  const factory MapEvent.locationPermissionDenied() = _LocationPermissionDenied;
  const factory MapEvent.userLocationUpdated(LatLng location) =
      _UserLocationUpdated;

  const factory MapsEvent.mapMoved(LatLngBounds bounds) = _MapMoved;
  const factory MapEvent.yourLocationTapped() = _YourLocationTapped;
  const factory MapEvent.markerTapped(ATM atm) = _MarkerTapped;

  const factory MapEvent.searchChanged(String query) = _SearchChanged;

  const factory MapEvent.searchCleared() = _SearchCleared;

  const factory MapEvent.searchSubmitted(String query) = _SearchSubmitted;

  const factory MapEvent.retryFetchATMs() = _RetryFetchATMs;
}
