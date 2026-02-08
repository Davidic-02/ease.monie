import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:esae_monie/services/logging_helper.dart';
import 'package:esae_monie/services/persistence_services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'map_event.dart';
part 'map_state.dart';
part 'map_bloc.freezed.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(const MapState()) {
    on<_Init>(_init);
    on<_RequestPermissions>(_requestPermissions);
    // on<_BeginStreamingLocation>(_beginStreamingLocation);
    // on<_StopStreamingLocation>(_stopStreamingLocation);
    // on<_NewLocation>(_newLocation);

    add(const _Init());
  }

  void _init(_Init event, Emitter<MapState> emit) async {
    final bool hasShownLocationRationale = await PersistenceService()
        .getHasShownLocationRationale();
    emit(state.copyWith(hasShownRationale: hasShownLocationRationale));

    logInfo('This is the map bloc');

    add(const _RequestPermissions());
  }

  void _requestPermissions(
    _RequestPermissions event,
    Emitter<MapState> emit,
  ) async {
    emit(
      state.copyWith(
        isLocationServiceEnabled: await Geolocator.isLocationServiceEnabled(),
      ),
    );

    if (!state.isLocationServiceEnabled) {
      emit(
        state.copyWith(
          isLocationServiceEnabled: await Geolocator.openAppSettings(),
        ),
      );

      if (!state.isLocationServiceEnabled) {
        return;
      }
    }

    final permission = await Geolocator.checkPermission();
    if (state.permissionStatus == LocationPermission.denied) {
      if (state.showRationale) {
        emit(state.copyWith(showRationale: false, hasShownRationale: true));
        PersistenceService().saveHasShownLocationRationale(true);
      } else if (!state.hasShownRationale) {
        emit(state.copyWith(showRationale: true));

        // A listener will watch the transition and show the rationale.
        // If the rationale is accepted, the event will be re-emitted.
        return;
      }
    }

    // For low end android devices, the permission will already be granted.
    PersistenceService().saveHasShownLocationRationale(true);

    emit(state.copyWith(permissionStatus: permission));

    if (state.permissionStatus == LocationPermission.denied) {
      emit(
        state.copyWith(permissionStatus: await Geolocator.requestPermission()),
      );
      if (state.permissionStatus != LocationPermission.always &&
          state.permissionStatus != LocationPermission.whileInUse) {
        return;
      }
    }

    final Position position = await Geolocator.getCurrentPosition();
    emit(state.copyWith(currentLocation: position));
  }
}
