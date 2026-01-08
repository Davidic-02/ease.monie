part of 'bank_transfer_bloc.dart';

@freezed
abstract class BankTransferEvent with _$BankTransferEvent {
  const factory BankTransferEvent.bankChanged(String bank) = _BankChanged;
  const factory BankTransferEvent.cardHolderNameChanged(String name) =
      _CardHolderNameChanged;
  const factory BankTransferEvent.cardNumberChanged(String number) =
      _CardNumberChanged;
  const factory BankTransferEvent.expiryChanged(String mmyy) = _ExpiryChanged;
  const factory BankTransferEvent.cvvChanged(String cvv) = _CvvChanged;
  const factory BankTransferEvent.amountSelected(double amount) =
      _AmountSelected;
  const factory BankTransferEvent.submit() = _Submit;
}
