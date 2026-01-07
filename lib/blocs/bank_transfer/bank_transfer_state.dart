part of 'bank_transfer_bloc.dart';

@freezed
abstract class BankTransferState with _$BankTransferState {
  const factory BankTransferState({String? selectedBank}) = _BankTransferState;
}
