import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:formz/formz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:esae_monie/blocs/location/location_bloc.dart';
import 'package:esae_monie/models/maps/atm.dart';
import 'package:esae_monie/repository/atm_repository.dart';
import 'package:esae_monie/services/logging_helper.dart';
import 'package:esae_monie/services/service_locator.dart';
import 'package:stream_transform/stream_transform.dart';

part 'maps_event.dart';
part 'maps_state.dart';
part 'maps_bloc.freezed.dart';

EventTransformer<E> _debounce<E>(Duration duration) =>
    (events, mapper) => events.debounce(duration).switchMap(mapper);

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  final AtmRepository _atmRepository = getIt<AtmRepository>();

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<_Init>(_onInit);
    on<_YourLocationTapped>(_onYourLocationTapped);
    on<_UserLocationUpdated>(_onUserLocationUpdated);
    on<_MapMoved>(_onMapMoved);

    on<_CameraIdle>(
      _onCameraIdle,
      transformer: _debounce(const Duration(milliseconds: 400)),
    );

    on<_MarkerTapped>(_onMarkerTapped);
    on<_ATMSelected>(_onATMSelected);
    on<_ATMDeselected>(_onATMDeselected);

    on<_SearchChanged>(
      _onSearchChanged,
      transformer: _debounce(const Duration(milliseconds: 300)),
    );

    on<_SearchCleared>(_onSearchCleared);
    on<_SearchSubmitted>(_onSearchSubmitted);
    on<_RouteRequested>(_onRouteRequested);
    on<_RetryFetchATMs>(_onRetryFetchATMs);
    on<_ClearError>(_onClearError);
    on<_CustomLocationSelected>(_onCustomLocationSelected);

    on<_ResetSearchCenter>(_onResetSearchCenter);

    add(const MapEvent.init());
  }

  Future<void> _onInit(_Init event, Emitter<MapState> emit) async {
    emit(
      state.copyWith(fetchStatus: FormzSubmissionStatus.inProgress, error: ''),
    );
    try {
      final userLocation = locationBloc.state.currentLocation;
      if (userLocation == null) {
        emit(
          state.copyWith(
            fetchStatus: FormzSubmissionStatus.failure,
            error:
                'User location not available. Please enable location services.',
          ),
        );

        return;
      }

      final userLatLng = LatLng(userLocation.latitude, userLocation.longitude);
      logInfo('Starting map: User at ($userLatLng)');

      final atms = await _atmRepository.getNearbyATMs(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
        radiusInMeters: 5000,
        limit: 50,
      );

      logInfo('Fetched ${atms.length} nearby ATMs');

      emit(
        state.copyWith(
          allATMs: atms,
          displayedATMs: atms,
          userLocation: userLatLng,
          fetchStatus: FormzSubmissionStatus.success,
          noATMsFound: atms.isEmpty,
          error: '',
        ),
      );
    } catch (e) {
      logError('Error in _onStarted: $e', StackTrace.current);
      emit(
        state.copyWith(
          fetchStatus: FormzSubmissionStatus.failure,
          error: 'Failed to load ATMs: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onYourLocationTapped(
    _YourLocationTapped event,
    Emitter<MapState> emit,
  ) async {
    final userLocation = locationBloc.state.currentLocation;
    if (userLocation != null) {
      emit(
        state.copyWith(
          userLocation: LatLng(userLocation.latitude, userLocation.longitude),
          selectedATM: null,
        ),
      );
    }
  }

  Future<void> _onUserLocationUpdated(
    _UserLocationUpdated event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(userLocation: event.location));
  }

  Future<void> _onMapMoved(_MapMoved event, Emitter<MapState> emit) async {
    emit(state.copyWith(visibleMapBounds: event.bounds));
  }

  Future<void> _onCameraIdle(_CameraIdle event, Emitter<MapState> emit) async {
    emit(
      state.copyWith(
        boundsStatus: FormzSubmissionStatus.inProgress,
        visibleMapBounds: event.bounds,
      ),
    );

    try {
      final atms = await _atmRepository.getATMsInBounds(
        bounds: event.bounds,
        limit: 50,
      );
      logInfo('Camera idle: Fetched ${atms.length} ATMs in bounds');
      emit(
        state.copyWith(
          displayedATMs: atms,
          boundsStatus: FormzSubmissionStatus.success,
          error: '',
        ),
      );
    } catch (e) {
      logError('Error in _onCameraIdle: $e', StackTrace.current);
      emit(
        state.copyWith(
          boundsStatus: FormzSubmissionStatus.failure,
          error: 'Failed to fetch ATMs: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onCustomLocationSelected(
    _CustomLocationSelected event,
    Emitter<MapState> emit,
  ) async {
    emit(
      state.copyWith(
        searchCenter: event.location,
        isSearchingFromCustomLocation: true,
        fetchStatus: FormzSubmissionStatus.inProgress,
      ),
    );

    try {
      final atms = await _atmRepository.getNearbyATMs(
        latitude: event.location.latitude,
        longitude: event.location.longitude,
        radiusInMeters: 5000,
        limit: 50,
      );

      emit(
        state.copyWith(
          allATMs: atms,
          displayedATMs: atms,
          fetchStatus: FormzSubmissionStatus.success,
          noATMsFound: atms.isEmpty,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          fetchStatus: FormzSubmissionStatus.failure,
          error: 'Failed to load ATMs near selected location: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onResetSearchCenter(
    _ResetSearchCenter event,
    Emitter<MapState> emit,
  ) async {
    // snap back to real GPS and re-run the original fetch
    emit(
      state.copyWith(
        searchCenter: state.userLocation,
        isSearchingFromCustomLocation: false,
      ),
    );
    add(const MapEvent.init());
  }

  Future<void> _onMarkerTapped(
    _MarkerTapped event,
    Emitter<MapState> emit,
  ) async {
    logInfo('Marker tapped: ${event.atm.name}');
    emit(state.copyWith(selectedATM: event.atm));
  }

  Future<void> _onATMSelected(
    _ATMSelected event,
    Emitter<MapState> emit,
  ) async {
    logInfo('ATM selected: ${event.atm.name}');
    emit(state.copyWith(selectedATM: event.atm));
  }

  Future<void> _onATMDeselected(
    _ATMDeselected event,
    Emitter<MapState> emit,
  ) async {
    logInfo('ATM deselected');
    emit(state.copyWith(selectedATM: null));
  }

  Future<void> _onSearchChanged(
    _SearchChanged event,
    Emitter<MapState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(
        state.copyWith(
          displayedATMs: state.allATMs,
          searchSuggestions: [],
          searchStatus: FormzSubmissionStatus.success,
          noATMsFound: false,
          error: '',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        searchQuery: event.query,
        searchStatus: FormzSubmissionStatus.inProgress,
      ),
    );

    try {
      final searchCenter = state.searchCenter;
      final currentLocation = locationBloc.state.currentLocation;

      final LatLng? center =
          searchCenter ??
          (currentLocation != null
              ? LatLng(currentLocation.latitude, currentLocation.longitude)
              : null);

      if (center == null) {
        throw Exception('Location not available');
      }

      final results = await _atmRepository.searchATMs(
        query: event.query,
        latitude: center.latitude,
        longitude: center.longitude,
        limit: 50,
      );

      final suggestions = results.map((atm) => atm.name).take(5).toList();

      emit(
        state.copyWith(
          displayedATMs: results,
          searchSuggestions: suggestions,
          searchStatus: FormzSubmissionStatus.success,
          noATMsFound: results.isEmpty,
          error: results.isEmpty ? 'No ATMs found' : '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          searchStatus: FormzSubmissionStatus.failure,
          error: e.toString(),
          noATMsFound: true,
        ),
      );
    }
  }

  Future<void> _onSearchCleared(
    _SearchCleared event,
    Emitter<MapState> emit,
  ) async {
    logInfo('Search cleared');
    emit(
      state.copyWith(
        searchQuery: '',
        displayedATMs: state.allATMs, // ← same restore point
        searchSuggestions: [],
        selectedATM: null,
        searchStatus: FormzSubmissionStatus.initial,
        noATMsFound: false,
        error: '',
      ),
    );
  }

  Future<void> _onSearchSubmitted(
    _SearchSubmitted event,
    Emitter<MapState> emit,
  ) async {
    add(MapEvent.searchChanged(event.query));
  }

  Future<void> _onRouteRequested(
    _RouteRequested event,
    Emitter<MapState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedATM: event.atm,
        routeStatus: FormzSubmissionStatus.inProgress,
      ),
    );

    try {
      logInfo('Route requested to: ${event.atm.name}');

      // TODO: launch url_launcher with Maps deep-link:
      // final url = Uri.parse(
      //   'https://www.google.com/maps/dir/?api=1'
      //   '&origin=${state.userLocation?.latitude},${state.userLocation?.longitude}'
      //   '&destination=${event.atm.latitude},${event.atm.longitude}'
      //   '&travelmode=driving',
      // );
      // await launchUrl(url, mode: LaunchMode.externalApplication);

      emit(state.copyWith(routeStatus: FormzSubmissionStatus.success));
    } catch (e) {
      logError('Error in _onRouteRequested: $e', StackTrace.current);
      emit(
        state.copyWith(
          routeStatus: FormzSubmissionStatus.failure,
          error: 'Failed to open directions: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onRetryFetchATMs(
    _RetryFetchATMs event,
    Emitter<MapState> emit,
  ) async {
    logInfo('Retrying fetch ATMs');
    add(const MapEvent.init());
  }

  Future<void> _onClearError(_ClearError event, Emitter<MapState> emit) async {
    emit(state.copyWith(error: ''));
  }
}
