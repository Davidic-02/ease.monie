part of 'bank_transfer_bloc.dart';

@freezed
abstract class BankTransferState with _$BankTransferState {
  const BankTransferState._();
  const factory BankTransferState({
    String? selectedBank,
    double? amount,
    String? errorMessage,
    @Default(CardHolderFormz.pure()) CardHolderFormz cardHolderName,
    @Default(CardNumberFormz.pure()) CardNumberFormz cardNumber,
    @Default(ExpiryFormz.pure()) ExpiryFormz expiry,
    @Default(CvvFormz.pure()) CvvFormz cvv,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus formStatus,
  }) = _BankTransferState;
  bool get isFormValid =>
      Formz.validate([cardHolderName, cardNumber, expiry, cvv]);
}

class CardHolderFormz extends FormzInput<String, ValidationError> {
  const CardHolderFormz.pure([super.value = '']) : super.pure();
  const CardHolderFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    return null;
  }
}

class CardNumberFormz extends FormzInput<String, ValidationError> {
  const CardNumberFormz.pure([super.value = '']) : super.pure();
  const CardNumberFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    if (!RegExp(r'^\d{16}$').hasMatch(value.replaceAll(' ', ''))) {
      return ValidationError.invalid;
    }
    return null;
  }
}

class ExpiryFormz extends FormzInput<String, ValidationError> {
  const ExpiryFormz.pure([super.value = '']) : super.pure();
  const ExpiryFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value.trim()))
      return ValidationError.invalid;
    return null;
  }
}

class CvvFormz extends FormzInput<String, ValidationError> {
  const CvvFormz.pure([super.value = '']) : super.pure();
  const CvvFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    if (!RegExp(r'^\d{3,4}$').hasMatch(value.trim()))
      return ValidationError.invalid;
    return null;
  }
}
