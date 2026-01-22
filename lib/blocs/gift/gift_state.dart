part of 'gift_bloc.dart';

@freezed
abstract class GiftState with _$GiftState {
  const GiftState._();

  const factory GiftState({
    String? selectedGiftId,

    @Default(RecipientNameFormz.pure()) RecipientNameFormz recipientName,
    @Default(AccountNumberFormz.pure()) AccountNumberFormz accountNumber,
    @Default(PurposeFormz.pure()) PurposeFormz purpose,
    @Default(PasswordFormz.pure()) PasswordFormz password,
    @Default(GiftAmountFormz.pure()) GiftAmountFormz amount,
    @Default(GiftMessageFormz.pure()) GiftMessageFormz giftMessage,

    @Default(FormzSubmissionStatus.initial)
    FormzSubmissionStatus submissionStatus,
    String? errorMessage,
  }) = _GiftState;

  bool get isGiftFormValid =>
      selectedGiftId != null &&
      recipientName.isValid &&
      accountNumber.isValid &&
      purpose.isValid &&
      password.isValid &&
      amount.isValid &&
      giftMessage.isValid;
}

class RecipientNameFormz extends FormzInput<String, ValidationError> {
  const RecipientNameFormz.pure([super.value = '']) : super.pure();
  const RecipientNameFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    return null; // valid
  }
}

class AccountNumberFormz extends FormzInput<String, ValidationError> {
  const AccountNumberFormz.pure([super.value = '']) : super.pure();
  const AccountNumberFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    if (value.length < 6)
      return ValidationError.short; // bank account min 6 digits
    return null;
  }
}

class PurposeFormz extends FormzInput<String, ValidationError> {
  const PurposeFormz.pure([super.value = '']) : super.pure();
  const PurposeFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    return null;
  }
}

class PasswordFormz extends FormzInput<String, ValidationError> {
  const PasswordFormz.pure([super.value = '']) : super.pure();
  const PasswordFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return ValidationError.empty;
    if (value.length < 4) return ValidationError.short; // minimum 4 digits
    return null;
  }
}

class GiftAmountFormz extends FormzInput<String, ValidationError> {
  const GiftAmountFormz.pure([super.value = '']) : super.pure();
  const GiftAmountFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return ValidationError.empty;

    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) return ValidationError.invalid;

    return null;
  }
}

class GiftMessageFormz extends FormzInput<String, ValidationError> {
  const GiftMessageFormz.pure([super.value = '']) : super.pure();
  const GiftMessageFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    if (value.length < 5)
      return ValidationError.short; // minimum message length
    return null;
  }
}
