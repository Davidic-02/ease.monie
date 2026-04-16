import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:esae_monie/services/logging_helper.dart';
import 'package:esae_monie/services/persistence_services.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'location_event.dart';
part 'location_state.dart';
part 'location_bloc.freezed.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(const LocationState()) {
    on<_Init>(_init);
    on<_RequestPermissions>(_requestPermissions);

    add(const _Init());
  }

  void _init(_Init event, Emitter<LocationState> emit) async {
    final bool hasShownLocationRationale = await PersistenceService()
        .getHasShownLocationRationale();
    emit(state.copyWith(hasShownRationale: hasShownLocationRationale));

    add(const _RequestPermissions());
  }

  void _requestPermissions(
    _RequestPermissions event,
    Emitter<LocationState> emit,
  ) async {
    emit(
      state.copyWith(
        isLocationServiceEnabled: await Geolocator.isLocationServiceEnabled(),
      ),
    );

    if (!state.isLocationServiceEnabled) {
      await Geolocator.openLocationSettings();

      final isNowEnabled = await Geolocator.isLocationServiceEnabled();
      emit(state.copyWith(isLocationServiceEnabled: isNowEnabled));

      if (!isNowEnabled) {
        return;
      }
    }

    final permission = await Geolocator.checkPermission();
    emit(state.copyWith(permissionStatus: permission));

    if (state.permissionStatus == LocationPermission.denied) {
      if (!state.hasShownRationale) {
        emit(state.copyWith(showRationale: true));
        await PersistenceService().saveHasShownLocationRationale(true);

        return;
      }

      final newPermission = await Geolocator.requestPermission();
      emit(state.copyWith(permissionStatus: newPermission));

      if (state.permissionStatus != LocationPermission.always &&
          state.permissionStatus != LocationPermission.whileInUse) {
        return;
      }
    } else if (state.permissionStatus == LocationPermission.deniedForever) {
      emit(state.copyWith(isLocationServiceEnabled: false));
      return;
    }

    try {
      final Position position = await Geolocator.getCurrentPosition();
      emit(state.copyWith(currentLocation: position));
      logInfo('User position: $position');
    } catch (error, trace) {
      logError('Error getting location: $error', trace);
    }
  }
}
