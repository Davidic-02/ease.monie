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

    add(event.onInit());
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
}
