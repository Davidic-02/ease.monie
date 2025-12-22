import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottom_navbar_state.dart';
part 'bottom_navbar_event.dart';
part 'bottom_navbar_bloc.freezed.dart';

class BottomNavbarBloc extends Bloc<BottomNavbarEvent, BottomNavbarState> {
  BottomNavbarBloc() : super(const BottomNavbarState()) {
    on<_TabChanged>(_onTabChanged);
  }

  void _onTabChanged(_TabChanged event, Emitter<BottomNavbarState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }
}
