part of 'bottom_navbar_bloc.dart';

@freezed
abstract class BottomNavbarState with _$BottomNavbarState {
  const factory BottomNavbarState({@Default(0) int currentIndex}) =
      _BottomNavbarState;
}
