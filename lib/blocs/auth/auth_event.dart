part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent() = _AuthEvent;
  const factory AuthEvent.emailChanged(String email) = _EmailChanged;
  const factory AuthEvent.passwordChanged(String password) = _PasswordChanged;
  const factory AuthEvent.loginSubmitted() = _LoginSubmitted;
  const factory AuthEvent.clearError(String? message) = _ClearError;
  const factory AuthEvent.forgotPasswordRequested(String email) =
      _ForgotPasswordRequested;
}
