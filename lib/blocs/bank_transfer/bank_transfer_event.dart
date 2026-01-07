part of 'bank_transfer_bloc.dart';

@freezed
abstract class BankTransferEvent with _$BankTransferEvent {
  const factory BankTransferEvent.bankChanged(String bank) = _BankChanged;
}
