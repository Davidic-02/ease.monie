import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_transfer_event.dart';
part 'bank_transfer_state.dart';
part 'bank_transfer_bloc.freezed.dart';

class BankTransferBloc extends Bloc<BankTransferEvent, BankTransferState> {
  BankTransferBloc() : super(const BankTransferState()) {
    on<_BankChanged>(_bankChanged);
  }

  void _bankChanged(_BankChanged event, Emitter<BankTransferState> emit) {
    emit(state.copyWith(selectedBank: event.bank));
  }
}
