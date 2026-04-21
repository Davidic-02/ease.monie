part of 'scan_bloc.dart';

@freezed
class ScanEvent with _$ScanEvent {
  const factory ScanEvent.scan() = _Scan;
  const factory ScanEvent.refresh() = _Refresh;
}
