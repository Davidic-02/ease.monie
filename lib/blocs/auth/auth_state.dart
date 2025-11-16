part of 'auth_bloc.dart';

@freezed
abstract class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    @Default(EmailFormz.pure()) EmailFormz email,
    @Default(PasswordFormz.pure()) PasswordFormz password,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus loginStatus,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus resetStatus,
    String? errorMessage,
  }) = _AuthState;

  bool get isLoginFormValid => email.isValid && password.isValid;
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
