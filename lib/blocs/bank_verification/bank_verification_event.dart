part of 'bank_verification_bloc.dart';

@freezed
class VerificationEvent with _$VerificationEvent {
  const factory VerificationEvent() = _VerificationEvent;
  const factory VerificationEvent.loadBanks() = _LoadBanks;
  const factory VerificationEvent.bankAccountChanged(String number) =
      _BankAccountChanged;
  const factory VerificationEvent.bankChanged(Bank bank) = _BankChanged;
  const factory VerificationEvent.submit() = _Submit;
  const factory VerificationEvent.submitSuccessful(
    ResolveAccountResponse result,
  ) = _SubmitSuccessful;
  const factory VerificationEvent.submitFailed(String message) = _SubmitFailed;

  const factory VerificationEvent.getBanks() = _GetBanks;
  const factory VerificationEvent.searchBanks(String query) = _SearchBanks;
  const factory VerificationEvent.getBanksSuccessful(BankResponse response) =
      _GetBanksSuccessful;
  const factory VerificationEvent.getBanksFailed(String message) =
      _GetBanksFailed;
}
