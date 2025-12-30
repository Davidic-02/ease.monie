part of 'bottom_navbar_bloc.dart';

@freezed
abstract class BottomNavbarEvent with _$BottomNavbarEvent {
  const factory BottomNavbarEvent.tabChanged(int index) = _TabChanged;
}
