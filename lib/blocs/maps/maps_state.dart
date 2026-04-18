part of 'maps_bloc.dart';

@freezed
abstract class MapState with _$MapState {
  const MapState._();
  const factory MapState({
    @Default([]) List<ATM> allATMs,
    @Default([]) List<ATM> displayedATMs,
    @Default([]) List<String> searchSuggestions,
    ATM? selectedATM,
    LatLng? userLocation,
    LatLng? searchCenter,
    @Default(false) bool isSearchingFromCustomLocation,
    LatLngBounds? visibleMapBounds,
    @Default('') String searchQuery,
    @Default('') String error,
    @Default(false) bool noATMsFound,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus fetchStatus,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus searchStatus,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus boundsStatus,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus routeStatus,
  }) = _MapState;

  bool get isLoading =>
      fetchStatus == FormzSubmissionStatus.inProgress ||
      searchStatus == FormzSubmissionStatus.inProgress ||
      boundsStatus == FormzSubmissionStatus.inProgress ||
      routeStatus == FormzSubmissionStatus.inProgress;

  bool get isFetchSuccess => fetchStatus == FormzSubmissionStatus.success;

  bool get isSearchSuccess => searchStatus == FormzSubmissionStatus.success;

  bool get isBoundsSuccess => boundsStatus == FormzSubmissionStatus.success;

  bool get isRouteSuccess => routeStatus == FormzSubmissionStatus.success;

  /// Helper getter to check overall failure
  /// Failure checks

  bool get isFetchFailure => fetchStatus == FormzSubmissionStatus.failure;

  bool get isSearchFailure => searchStatus == FormzSubmissionStatus.failure;

  bool get isBoundsFailure => boundsStatus == FormzSubmissionStatus.failure;

  bool get isRouteFailure => routeStatus == FormzSubmissionStatus.failure;
}
