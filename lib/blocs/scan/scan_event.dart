part of 'scan_bloc';


import 'package:flutter/foundation.dart';

abstract class ScanEvent with _$ScanState{
const factory ScanEvent.retry() = _retry;
const factory ScanEvent.scan() = _Scan;
}