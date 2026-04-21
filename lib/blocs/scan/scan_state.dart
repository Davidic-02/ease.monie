part of 'scan_bloc.dart';

@freezed
abstract class ScanState with _$ScanState {
  const factory ScanState({
    @Default(false) bool isScanning,
    @Default(false) bool isRefreshing,
    @Default('') String message,
  }) = _ScanState;
}
