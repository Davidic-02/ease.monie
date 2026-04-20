import 'package:esae_monie/presentation/widgets/maps/poly_line_helper.dart';
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
import 'package:geocoding/geocoding.dart';

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

  // ── SINGLE SOURCE OF TRUTH ──────────────────────────────────────────────
  // Everything reads from here — never directly from locationBloc
  LatLng? _activeLocation() {
    return state.searchCenter ?? state.userLocation;
  }

  LatLng? _gpsLatLng() {
    final gps = locationBloc.state.currentLocation;
    if (gps == null) return null;
    return LatLng(gps.latitude, gps.longitude);
  }

  // ── INIT ────────────────────────────────────────────────────────────────
  Future<void> _onInit(_Init event, Emitter<MapState> emit) async {
    emit(
      state.copyWith(fetchStatus: FormzSubmissionStatus.inProgress, error: ''),
    );

    try {
      final gpsLatLng = _gpsLatLng();
      if (gpsLatLng != null) {
        emit(state.copyWith(userLocation: gpsLatLng));

        // ← Reverse geocode GPS position
        final label = await _reverseGeocode(
          gpsLatLng.latitude,
          gpsLatLng.longitude,
        );
        emit(state.copyWith(userAddressLabel: label));
      }

      final location = _activeLocation();
      if (location == null) {
        emit(
          state.copyWith(
            fetchStatus: FormzSubmissionStatus.failure,
            error: 'Location not available. Please enable location services.',
          ),
        );
        return;
      }

      final atms = await _atmRepository.getNearbyATMs(
        latitude: location.latitude,
        longitude: location.longitude,
        radiusInMeters: 5000,
        limit: 50,
      );

      emit(
        state.copyWith(
          allATMs: atms,
          displayedATMs: atms,
          userLocation: gpsLatLng ?? state.userLocation,
          fetchStatus: FormzSubmissionStatus.success,
          noATMsFound: atms.isEmpty,
          error: '',
        ),
      );
    } catch (e) {
      logError('Error in _onInit: $e', StackTrace.current);
      emit(
        state.copyWith(
          fetchStatus: FormzSubmissionStatus.failure,
          error: 'Failed to load ATMs: ${e.toString()}',
        ),
      );
    }
  }

  // Add this private method to MapBloc
  Future<String> _reverseGeocode(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return '$lat, $lng';
      final p = placemarks.first;
      // Build a readable address from available parts
      final parts = [
        if (p.name?.isNotEmpty == true && p.name != p.street) p.name,
        if (p.street?.isNotEmpty == true) p.street,
        if (p.subLocality?.isNotEmpty == true) p.subLocality,
        if (p.locality?.isNotEmpty == true) p.locality,
      ].whereType<String>().toList();
      return parts.isNotEmpty ? parts.take(2).join(', ') : '$lat, $lng';
    } catch (_) {
      return '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
    }
  }

  // ── CUSTOM LOCATION SELECTED (map tap or long press) ────────────────────
  Future<void> _onCustomLocationSelected(
    _CustomLocationSelected event,
    Emitter<MapState> emit,
  ) async {
    emit(
      state.copyWith(
        searchCenter: event.location,
        isSearchingFromCustomLocation: true,
        selectedATM: null,
        polylines: {},
        fetchStatus: FormzSubmissionStatus.inProgress,
        customLocationLabel:
            'Resolving location…', // ← temp label while geocoding
        error: '',
      ),
    );

    // ← Reverse geocode the tapped point in parallel with ATM fetch
    final labelFuture = _reverseGeocode(
      event.location.latitude,
      event.location.longitude,
    );

    try {
      final atms = await _atmRepository.getNearbyATMs(
        latitude: event.location.latitude,
        longitude: event.location.longitude,
        radiusInMeters: 5000,
        limit: 50,
      );

      final label = await labelFuture; // ← await the geocode result

      emit(
        state.copyWith(
          allATMs: atms,
          displayedATMs: atms,
          fetchStatus: FormzSubmissionStatus.success,
          noATMsFound: atms.isEmpty,
          customLocationLabel: label, // ← real place name now
          error: atms.isEmpty ? 'No ATMs found near this location' : '',
        ),
      );
    } catch (e) {
      final label = await labelFuture;
      logError(
        'Error fetching ATMs for custom location: $e',
        StackTrace.current,
      );
      emit(
        state.copyWith(
          fetchStatus: FormzSubmissionStatus.failure,
          customLocationLabel: label,
          error: 'Failed to load ATMs near selected location: ${e.toString()}',
        ),
      );
    }
  }

  // ── RESET TO GPS ────────────────────────────────────────────────────────
  Future<void> _onResetSearchCenter(
    _ResetSearchCenter event,
    Emitter<MapState> emit,
  ) async {
    emit(
      state.copyWith(
        searchCenter: null,
        isSearchingFromCustomLocation: false,
        selectedATM: null,
        polylines: {},
        searchQuery: '',
        searchSuggestions: [],
        customLocationLabel: '', // ← reset
        error: '',
      ),
    );
    add(const MapEvent.init());
  }

  // ── YOUR LOCATION TAPPED ────────────────────────────────────────────────
  Future<void> _onYourLocationTapped(
    _YourLocationTapped event,
    Emitter<MapState> emit,
  ) async {
    final gps = _gpsLatLng();
    if (gps != null) {
      emit(
        state.copyWith(
          userLocation: gps,
          // Don't override searchCenter — just updates GPS store
        ),
      );
    }
  }

  // ── USER LOCATION UPDATED (stream from GPS) ─────────────────────────────
  Future<void> _onUserLocationUpdated(
    _UserLocationUpdated event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(userLocation: event.location));
  }

  // ── MAP MOVED ───────────────────────────────────────────────────────────
  Future<void> _onMapMoved(_MapMoved event, Emitter<MapState> emit) async {
    emit(state.copyWith(visibleMapBounds: event.bounds));
  }

  // ── CAMERA IDLE — filter ATMs to visible bounds (no API call) ───────────
  Future<void> _onCameraIdle(_CameraIdle event, Emitter<MapState> emit) async {
    emit(state.copyWith(visibleMapBounds: event.bounds));

    final visible = _atmRepository.filterATMsInBounds(
      allATMs: state.allATMs,
      bounds: event.bounds,
    );

    emit(
      state.copyWith(
        displayedATMs: visible.isEmpty ? state.allATMs : visible,
        boundsStatus: FormzSubmissionStatus.success,
      ),
    );
  }

  // ── MARKER TAPPED ───────────────────────────────────────────────────────
  Future<void> _onMarkerTapped(
    _MarkerTapped event,
    Emitter<MapState> emit,
  ) async {
    logInfo('Marker tapped: ${event.atm.name}');
    emit(state.copyWith(selectedATM: event.atm));
  }

  // ── ATM SELECTED ────────────────────────────────────────────────────────
  Future<void> _onATMSelected(
    _ATMSelected event,
    Emitter<MapState> emit,
  ) async {
    logInfo('ATM selected: ${event.atm.name}');
    emit(state.copyWith(selectedATM: event.atm));
  }

  // ── ATM DESELECTED ──────────────────────────────────────────────────────
  Future<void> _onATMDeselected(
    _ATMDeselected event,
    Emitter<MapState> emit,
  ) async {
    logInfo('ATM deselected');
    emit(state.copyWith(selectedATM: null, polylines: {}));
  }

  // ── SEARCH CHANGED ──────────────────────────────────────────────────────
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
          searchQuery: '',
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
      // Use active location — custom pin wins over GPS
      final location = _activeLocation();

      if (location == null) {
        throw Exception('Location not available');
      }

      final results = await _atmRepository.searchATMs(
        query: event.query,
        latitude: location.latitude,
        longitude: location.longitude,
        limit: 50,
      );

      final suggestions = results.map((atm) => atm.name).take(6).toList();

      if (results.isNotEmpty) {
        // Move search center to first result area so map follows the search
        emit(
          state.copyWith(
            displayedATMs: results,
            searchSuggestions: suggestions,
            searchStatus: FormzSubmissionStatus.success,
            noATMsFound: false,
            error: '',
            // ← update searchCenter to first result so map can pan there
            searchCenter: LatLng(
              results.first.latitude,
              results.first.longitude,
            ),
            isSearchingFromCustomLocation: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            displayedATMs: [],
            searchSuggestions: [],
            searchStatus: FormzSubmissionStatus.success,
            noATMsFound: true,
            error: 'No ATMs found for "${event.query}"',
          ),
        );
      }
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

  // ── SEARCH CLEARED ──────────────────────────────────────────────────────
  Future<void> _onSearchCleared(
    _SearchCleared event,
    Emitter<MapState> emit,
  ) async {
    logInfo('Search cleared');
    emit(
      state.copyWith(
        searchQuery: '',
        displayedATMs: state.allATMs,
        searchSuggestions: [],
        selectedATM: null,
        searchStatus: FormzSubmissionStatus.initial,
        noATMsFound: false,
        error: '',
        // Keep searchCenter if user had custom location
        // Only clear if user explicitly resets
      ),
    );
  }

  // ── SEARCH SUBMITTED ────────────────────────────────────────────────────
  Future<void> _onSearchSubmitted(
    _SearchSubmitted event,
    Emitter<MapState> emit,
  ) async {
    add(MapEvent.searchChanged(event.query));
  }

  // ── ROUTE REQUESTED ─────────────────────────────────────────────────────
  Future<void> _onRouteRequested(
    _RouteRequested event,
    Emitter<MapState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedATM: event.atm,
        routeStatus: FormzSubmissionStatus.inProgress,
        polylines: {},
        routeDistanceM: null, // ← clear old values
        routeDurationMin: null,
      ),
    );

    try {
      final origin = _activeLocation();

      if (origin == null) {
        emit(
          state.copyWith(
            routeStatus: FormzSubmissionStatus.failure,
            error: 'No location available for routing',
          ),
        );
        return;
      }

      final direction = await _atmRepository.getRoute(
        originLat: origin.latitude,
        originLng: origin.longitude,
        destLat: event.atm.latitude,
        destLng: event.atm.longitude,
      );

      final route = direction.routes.first;
      final encoded = route['overview_polyline']['points'];
      final polylinePoints = _atmRepository.decodePolyline(encoded);
      final polyline = PolylineHelper.buildRoute(polylinePoints);

      // ← Parse distance and duration from legs
      final leg = route['legs']?.first;
      final distanceM = leg?['distance']?['value'] as int?;
      final durationSec = leg?['duration']?['value'] as int?;
      final durationMin = durationSec != null
          ? (durationSec / 60).ceil()
          : null;

      emit(
        state.copyWith(
          polylines: {polyline},
          routeStatus: FormzSubmissionStatus.success,
          routeDistanceM: distanceM,
          routeDurationMin: durationMin,
        ),
      );
    } catch (e) {
      logError('Error in _onRouteRequested: $e', StackTrace.current);
      emit(
        state.copyWith(
          routeStatus: FormzSubmissionStatus.failure,
          error: 'Failed to get directions: ${e.toString()}',
        ),
      );
    }
  }

  // ── RETRY ───────────────────────────────────────────────────────────────
  Future<void> _onRetryFetchATMs(
    _RetryFetchATMs event,
    Emitter<MapState> emit,
  ) async {
    logInfo('Retrying fetch ATMs');
    add(const MapEvent.init());
  }

  // ── CLEAR ERROR ─────────────────────────────────────────────────────────
  Future<void> _onClearError(_ClearError event, Emitter<MapState> emit) async {
    emit(state.copyWith(error: ''));
  }
}
