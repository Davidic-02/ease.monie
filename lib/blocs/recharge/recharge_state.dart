part of 'recharge_bloc.dart';

@freezed
abstract class RechargeState with _$RechargeState {
  const RechargeState._();

  const factory RechargeState({
    SelectedNetwork? selectedNetwork,

    @Default(PhoneNumberFormz.pure()) PhoneNumberFormz phoneNumber,

    @Default(AmountFormz.pure()) AmountFormz amount,

    @Default(FormzSubmissionStatus.initial)
    FormzSubmissionStatus submissionStatus,

    String? errorMessage,
  }) = _RechargeState;
  bool get isRechargeFormValid =>
      phoneNumber.isValid && amount.isValid && selectedNetwork != null;
}

class AmountFormz extends FormzInput<String, ValidationError> {
  const AmountFormz.pure([super.value = '']) : super.pure();
  const AmountFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationError.empty;
    }

    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return ValidationError.invalid;
    }

    return null;
  }
}

class PhoneNumberFormz extends FormzInput<String, ValidationError> {
  const PhoneNumberFormz.pure([super.value = '']) : super.pure();
  const PhoneNumberFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return ValidationError.empty;

    if (value.length < 6) {
      return ValidationError.short;
    }

    return null;
  }
}
