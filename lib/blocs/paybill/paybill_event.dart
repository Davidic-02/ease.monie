part of 'paybill_bloc.dart';

@freezed
class PayBillEvent with _$PayBillEvent {
  const factory PayBillEvent.billTypeChanged(String billType) =
      _BillTypeChanged;

  // INTERNET BILL fields
  const factory PayBillEvent.nameChanged(String name) = _NameChanged;
  const factory PayBillEvent.accountNumberChanged(String accountNumber) =
      _AccountNumberChanged;
  const factory PayBillEvent.passwordChanged(String password) =
      _PasswordChanged;

  // ELECTRICITY BILL fields
  const factory PayBillEvent.providerChanged(String provider) =
      _ProviderChanged;
  const factory PayBillEvent.meterNumberChanged(String meterNumber) =
      _MeterNumberChanged;

  // WATER BILL fields
  const factory PayBillEvent.customerIdChanged(String customerId) =
      _CustomerIdChanged;

  const factory PayBillEvent.errorMessage([String? message]) = _ErrorMessage;
  const factory PayBillEvent.submit() = _Submit;
  const factory PayBillEvent.submitSuccessful() = _SubmitSuccessful;
  const factory PayBillEvent.submitFailed() = _SubmitFailed;
}
