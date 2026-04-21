import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'scan_event.dart';
part 'scan_state.dart';
part 'scan_bloc.freezed.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(const ScanState()) {
    on<_Scan>(_scan);
    on<_Refresh>(_refresh);
  }

  Future<void> _scan(_Scan event, Emitter<ScanState> emit) async {
    emit(state.copyWith(isScanning: true, message: 'Scan is active'));

    await Future.delayed(const Duration(seconds: 9));

    emit(state.copyWith(isScanning: false, message: 'Scan stopped'));
  }

  Future<void> _refresh(_Refresh event, Emitter<ScanState> emit) async {
    emit(state.copyWith(isRefreshing: true));

    await Future.delayed(const Duration(milliseconds: 500));

    emit(
      state.copyWith(
        isRefreshing: false,
        isScanning: false,
        message: 'Refreshed',
      ),
    );
  }
}
