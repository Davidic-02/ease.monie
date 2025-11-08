part of 'onboarding_bloc.dart';

@freezed
abstract class OnBoardingState with _$OnBoardingState {
  const OnBoardingState._();

  const factory OnBoardingState({
    @Default(FullNameFormz.pure()) FullNameFormz fullName,
    @Default(EmailFormz.pure()) EmailFormz email,
    @Default(PasswordFormz.pure()) PasswordFormz password,
    @Default(PasswordConfirmFormz.pure()) PasswordConfirmFormz passwordConfirm,
    String? phoneCode,
    String? phoneNumber,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus signUpStatus,
    String? errorMessage,
    @Default(false) acceptTerms,

    String? fcmToken,

    @Default(false) bool hasPersistedCredentialsInBiometricDevice,
  }) = _OnBoardingState;

  bool get isSignUpFormValid =>
      Formz.validate([fullName, email, password, passwordConfirm]) &&
      phoneNumberValid;

  bool get phoneNumberValid =>
      (phoneNumber?.isNotEmpty ?? false) && phoneNumber!.length > 8;
}

//==============================================================================
// FORMZ -  Full Name
//==============================================================================

class FullNameFormz extends FormzInput<String, ValidationError> {
  const FullNameFormz.pure([super.value = '']) : super.pure();
  const FullNameFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return ValidationError.empty;

    return null;
  }
}

//==============================================================================
// FORMZ -  Username
//==============================================================================

class UsernameFormz extends FormzInput<String, ValidationError> {
  const UsernameFormz.pure([super.value = '']) : super.pure();
  const UsernameFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return ValidationError.empty;

    return null;
  }
}

//==============================================================================
// FORMZ -  EMAIL
//==============================================================================

class EmailFormz extends FormzInput<String, ValidationError> {
  const EmailFormz.pure([super.value = '']) : super.pure();
  const EmailFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return ValidationError.empty;

    if (!EmailValidator.validate(value.trim())) {
      return ValidationError.invalid;
    }

    return null;
  }
}

//==============================================================================
// FORMZ -  Password
//==============================================================================

class PasswordFormz extends FormzInput<String, ValidationError> {
  const PasswordFormz.pure([super.value = '']) : super.pure();
  const PasswordFormz.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return ValidationError.empty;

    if (value.length < 6) {
      return ValidationError.short;
    }

    return null;
  }
}

//==============================================================================
// FORMZ -  Password Confirm
//==============================================================================

class PasswordConfirmFormz extends FormzInput<String, ValidationError> {
  const PasswordConfirmFormz.pure([super.value = '', this.password])
    : super.pure();
  const PasswordConfirmFormz.dirty([super.value = '', this.password])
    : super.dirty();

  final String? password;

  @override
  ValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return ValidationError.empty;

    if (value != password) {
      return ValidationError.invalid;
    }

    return null;
  }
}
