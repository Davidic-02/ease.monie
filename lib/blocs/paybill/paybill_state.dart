part of 'paybill_bloc.dart';

@freezed
abstract class PayBillState with _$PayBillState {
  const PayBillState._();

  const factory PayBillState({
    String? selectedBill,

    // INTERNET BILL
    @Default(NameFormz.pure()) NameFormz internetName,
    @Default(AccountNumberFormz.pure()) AccountNumberFormz accountNumber,
    @Default(BillPasswordFormz.pure()) BillPasswordFormz password,

    // ELECTRICITY BILL
    @Default(ProviderFormz.pure()) ProviderFormz provider,
    @Default(MeterNumberFormz.pure()) MeterNumberFormz meterNumber,

    // WATER BILL
    @Default(CustomerIdFormz.pure()) CustomerIdFormz customerId,

    // OTHERS BILL
    @Default(OtherBillFormz.pure()) OtherBillFormz otherBill,

    // Form submission status
    @Default(FormzSubmissionStatus.initial)
    FormzSubmissionStatus billSubmissionStatus,
    @Default(null) String? errorMessage,
  }) = _PayBillState;

  bool get isInternetFormValid =>
      internetName.isValid && accountNumber.isValid && password.isValid;
  bool get isElectricityFormValid => provider.isValid && meterNumber.isValid;
  bool get isWaterFormValid => customerId.isValid;
  bool get isOthersFormValid => otherBill.isValid;
}

//==============================================================================
// INTERNET BILL FORMZ
//==============================================================================

class NameFormz extends FormzInput<String, ValidationError> {
  const NameFormz.pure([super.value = '']) : super.pure();
  const NameFormz.dirty([super.value = '']) : super.dirty();
  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return ValidationError.empty;
    if (value.length < 3) return ValidationError.short;
    return null;
  }
}

class AccountNumberFormz extends FormzInput<String, ValidationError> {
  const AccountNumberFormz.pure([String value = '']) : super.pure('');
  const AccountNumberFormz.dirty([super.value = '']) : super.dirty();
  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return ValidationError.empty;
    if (value.length < 6) return ValidationError.short;
    return null;
  }
}

class BillPasswordFormz extends FormzInput<String, ValidationError> {
  const BillPasswordFormz.pure([String value = '']) : super.pure('');
  const BillPasswordFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return ValidationError.empty;
    if (value.length < 6) return ValidationError.invalid;
    return null;
  }
}

//==============================================================================
// ELECTRICITY BILL FORMZ
//==============================================================================

class MeterNumberFormz extends FormzInput<String, ValidationError> {
  const MeterNumberFormz.pure([super.value = '']) : super.pure();
  const MeterNumberFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return ValidationError.empty;
    if (value.length < 3) return ValidationError.short;
    return null;
  }
}

class ProviderFormz extends FormzInput<String, ValidationError> {
  const ProviderFormz.pure([super.value = '']) : super.pure();
  const ProviderFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return ValidationError.empty;
    return null;
  }
}

//==============================================================================
// WATER BILL FORMZ
//==============================================================================
class CustomerIdFormz extends FormzInput<String, ValidationError> {
  const CustomerIdFormz.pure([super.value = '']) : super.pure();
  const CustomerIdFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return ValidationError.empty;
    return null;
  }
}

//==============================================================================
// OTHERS BILL FORMZ
//==============================================================================

class OtherBillFormz extends FormzInput<String, ValidationError> {
  const OtherBillFormz.pure([super.value = '']) : super.pure();
  const OtherBillFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return ValidationError.empty;
    return null;
  }
}
