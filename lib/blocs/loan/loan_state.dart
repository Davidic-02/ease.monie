part of 'loan_bloc.dart';

@freezed
abstract class LoanState with _$LoanState {
  const LoanState._();

  const factory LoanState({
    String? selectedPlan,
    @Default(false) bool autoPayment,

    @Default(NameFormz.pure()) NameFormz name,
    @Default(CnicFormz.pure()) CnicFormz cnic,
    @Default(MobileFormz.pure()) MobileFormz mobile,
    @Default(PasswordFormz.pure()) PasswordFormz password,
    @Default(FormzSubmissionStatus.initial)
    FormzSubmissionStatus submissionStatus,
  }) = _LoanState;

  bool get isFormValid =>
      selectedPlan != null && Formz.validate([name, cnic, mobile, password]);
}

class NameFormz extends FormzInput<String, ValidationError> {
  const NameFormz.pure([super.value = '']) : super.pure();
  const NameFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String value) {
    if (value.trim().isEmpty) return ValidationError.empty;
    return null;
  }
}

class CnicFormz extends FormzInput<String, ValidationError> {
  const CnicFormz.pure([super.value = '']) : super.pure();
  const CnicFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String value) {
    if (value.length < 10) return ValidationError.invalid;
    return null;
  }
}

class MobileFormz extends FormzInput<String, ValidationError> {
  const MobileFormz.pure([super.value = '']) : super.pure();
  const MobileFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String value) {
    if (value.length < 10) return ValidationError.invalid;
    return null;
  }
}

class PasswordFormz extends FormzInput<String, ValidationError> {
  const PasswordFormz.pure([super.value = '']) : super.pure();
  const PasswordFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String value) {
    if (value.length < 6) return ValidationError.short;
    return null;
  }
}
