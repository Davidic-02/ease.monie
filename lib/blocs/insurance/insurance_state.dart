part of 'insurance_bloc.dart';

@freezed
abstract class InsuranceState with _$InsuranceState {
  const InsuranceState._();

  const factory InsuranceState({
    @Default(<String, ServicesModel>{}) Map<String, ServicesModel> insurances,

    String? selectedInsuranceId,
    InsuranceModel? selectedInsurancePlan,
    @Default([]) List<ServicesModel> insuranceModel,
    @Default(FirstNameFormz.pure()) FirstNameFormz firstName,

    @Default(LastNameFormz.pure()) LastNameFormz lastName,

    @Default(FamilyMembersFormz.pure()) FamilyMembersFormz familyMembers,

    @Default(PurposeFormz.pure()) PurposeFormz purpose,

    @Default(PaymentPlanFormz.pure()) PaymentPlanFormz paymentPlan,

    @Default(PasswordFormz.pure()) PasswordFormz password,

    @Default(CardNameFormz.pure()) CardNameFormz cardName,

    @Default(CardNumberFormz.pure()) CardNumberFormz cardNumber,

    @Default(CardExpiryFormz.pure()) CardExpiryFormz expiry,

    @Default(CardCvvFormz.pure()) CardCvvFormz cvv,

    @Default(FormzSubmissionStatus.initial)
    FormzSubmissionStatus submissionStatus,

    String? errorMessage,
  }) = _InsuranceState;

  bool get isInsuranceFormValid =>
      selectedInsuranceId != null &&
      selectedInsurancePlan != null &&
      firstName.isValid &&
      lastName.isValid &&
      familyMembers.isValid &&
      purpose.isValid &&
      paymentPlan.isValid &&
      cardName.isValid &&
      cardNumber.isValid &&
      expiry.isValid &&
      cvv.isValid &&
      password.isValid;
}

class FirstNameFormz extends FormzInput<String, ValidationError> {
  const FirstNameFormz.pure([super.value = '']) : super.pure();
  const FirstNameFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationError.empty;
    }
    return null;
  }
}

class LastNameFormz extends FormzInput<String, ValidationError> {
  const LastNameFormz.pure([super.value = '']) : super.pure();
  const LastNameFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationError.empty;
    }
    return null;
  }
}

class FamilyMembersFormz extends FormzInput<String, ValidationError> {
  const FamilyMembersFormz.pure([super.value = '']) : super.pure();
  const FamilyMembersFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationError.empty;
    }

    final count = int.tryParse(value);
    if (count == null || count <= 0) {
      return ValidationError.invalid;
    }

    return null;
  }
}

class PurposeFormz extends FormzInput<String, ValidationError> {
  const PurposeFormz.pure([super.value = '']) : super.pure();
  const PurposeFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationError.empty;
    }
    return null;
  }
}

class PaymentPlanFormz extends FormzInput<String, ValidationError> {
  const PaymentPlanFormz.pure([super.value = '']) : super.pure();
  const PaymentPlanFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationError.empty;
    }
    return null;
  }
}

class PasswordFormz extends FormzInput<String, ValidationError> {
  const PasswordFormz.pure([super.value = '']) : super.pure();
  const PasswordFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationError.empty;
    }
    if (value.length < 4) {
      return ValidationError.short;
    }
    return null;
  }
}

class CardNameFormz extends FormzInput<String, ValidationError> {
  const CardNameFormz.pure([super.value = '']) : super.pure();
  const CardNameFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationError.empty;
    }
    return null;
  }
}

class CardNumberFormz extends FormzInput<String, ValidationError> {
  const CardNumberFormz.pure([super.value = '']) : super.pure();
  const CardNumberFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationError.empty;
    }
    if (value.length < 16) {
      return ValidationError.short;
    }
    return null;
  }
}

class CardExpiryFormz extends FormzInput<String, ValidationError> {
  const CardExpiryFormz.pure([super.value = '']) : super.pure();
  const CardExpiryFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationError.empty;
    }
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return ValidationError.invalid;
    }
    return null;
  }
}

class CardCvvFormz extends FormzInput<String, ValidationError> {
  const CardCvvFormz.pure([super.value = '']) : super.pure();
  const CardCvvFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationError.empty;
    }
    if (value.length < 3) {
      return ValidationError.short;
    }
    return null;
  }
}
