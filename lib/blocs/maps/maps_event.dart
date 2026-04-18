part of 'maps_bloc.dart';

@freezed
class MapEvent with _$MapEvent {
  // Initialization
  const factory MapEvent.init() = _Init;

  // Location Events
  const factory MapEvent.yourLocationTapped() = _YourLocationTapped;
  const factory MapEvent.userLocationUpdated(LatLng location) =
      _UserLocationUpdated;
  const factory MapEvent.customLocationSelected(LatLng location) =
      _CustomLocationSelected;

  // Map Interaction Events
  const factory MapEvent.mapMoved(LatLngBounds bounds) = _MapMoved;
  const factory MapEvent.cameraIdle(LatLngBounds bounds) = _CameraIdle;
  const factory MapEvent.resetSearchCenter() = _ResetSearchCenter;

  // ATM Selection Events
  const factory MapEvent.markerTapped(ATM atm) = _MarkerTapped;
  const factory MapEvent.atmSelected(ATM atm) = _ATMSelected;
  const factory MapEvent.atmDeselected() = _ATMDeselected;

  // Search Events
  const factory MapEvent.searchChanged(String query) = _SearchChanged;
  const factory MapEvent.searchCleared() = _SearchCleared;
  const factory MapEvent.searchSubmitted(String query) = _SearchSubmitted;

  // Route/Direction Events
  const factory MapEvent.routeRequested(ATM atm) = _RouteRequested;

  // Error Handling
  const factory MapEvent.retryFetchATMs() = _RetryFetchATMs;
  const factory MapEvent.clearError() = _ClearError;
}
