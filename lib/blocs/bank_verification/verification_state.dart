part of 'verification_bloc.dart';

@freezed
abstract class VerificationState with _$VerificationState {
  const VerificationState._();
  const factory VerificationState({
    @Default(BankAccountFormz.pure()) BankAccountFormz bankAccount,
    @Default(BankInput.pure()) BankInput selectedBank,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus formzStatus,
    @Default([]) List<Bank> banks,
    dynamic verificationResult,
    String? errorMessage,
  }) = _VerificationState;
  bool get isFormValid => bankAccount.isValid && selectedBank.isValid;
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
