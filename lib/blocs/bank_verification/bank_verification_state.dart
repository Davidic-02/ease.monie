part of 'bank_verification_bloc.dart';

@freezed
abstract class VerificationState with _$VerificationState {
  const VerificationState._();

  const factory VerificationState({
    @Default(BankAccountFormz.pure()) BankAccountFormz bankAccount,
    @Default(BankInput.pure()) BankInput selectedBank,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus formzStatus,
    @Default(FormzSubmissionStatus.initial)
    FormzSubmissionStatus getBanksStatus,
    @Default([]) List<Bank> banks,
    dynamic verificationResult,
    String? errorMessage,
    String? verifiedAccountName,
    String? searchBankString,
  }) = _VerificationState;

  bool get isFormValid => bankAccount.isValid && selectedBank.isValid;
}

extension BankExtension on VerificationState {
  List<Bank> get bankSearchResult {
    if (searchBankString?.isEmpty ?? true) return [];

    final query = searchBankString!.toLowerCase();

    return banks.where((e) => e.name.toLowerCase().startsWith(query)).toList();
  }

  List<Bank> get computedBanks =>
      (searchBankString?.isEmpty ?? true) ? banks : bankSearchResult;
}

class BankAccountFormz extends FormzInput<String, ValidationError> {
  const BankAccountFormz.pure([super.value = '']) : super.pure();
  const BankAccountFormz.dirty([super.value = '']) : super.dirty();
  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return ValidationError.empty;
    if (value.length != 10) {
      return ValidationError.short;
    }
    return null;
  }
}

class BankInput extends FormzInput<Bank?, ValidationError> {
  const BankInput.pure() : super.pure(null);
  const BankInput.dirty([super.value]) : super.dirty();
  @override
  ValidationError? validator(Bank? value) {
    if (value == null) return ValidationError.empty;
    return null;
  }
}
