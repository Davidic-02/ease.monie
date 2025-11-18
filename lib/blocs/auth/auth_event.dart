part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent() = _AuthEvent;

  const factory AuthEvent.emailChanged(String email) = _EmailChanged;
  const factory AuthEvent.passwordChanged(String password) = _PasswordChanged;
  const factory AuthEvent.forgotPasswordEmailChanged(String email) =
      _ForgotPasswordEmailChanged;
  const factory AuthEvent.login() = _Login;
  const factory AuthEvent.loginSuccessful() = _LoginSuccessful;
  const factory AuthEvent.loginFailed([String? message]) = _LoginFailed;
  const factory AuthEvent.errorMessage([String? message]) = _ErrorMessage;
  const factory AuthEvent.forgotPassword() = _ForgotPassword;
  const factory AuthEvent.forgotPasswordSuccessful() =
      _ForgotPasswordSuccessful;
  const factory AuthEvent.forgotPasswordFailed([String? message]) =
      _ForgotPasswordFailed;
}
