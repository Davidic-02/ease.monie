part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent() = _AuthEvent;

  const factory AuthEvent.emailChanged(String email) = _EmailChanged;
  const factory AuthEvent.passwordChanged(String password) = _PasswordChanged;
  const factory AuthEvent.login() = _Login;
  const factory AuthEvent.loginsuccessful() = _LoginSuccessful;
  const factory AuthEvent.loginFailed([String? message]) = _LoginFailed;
  const factory AuthEvent.errorMessage([String? message]) = _ErrorMessage;
  const factory AuthEvent.forgotPassword(String email) = _ForgotPassword;

  const factory AuthEvent.init() = _Init;
}
