part of 'onboarding_bloc.dart';

@freezed
class OnBoardingEvent with _$OnBoardingEvent {
  const factory OnBoardingEvent() = _OnBoardingEvent;

  const factory OnBoardingEvent.emailChanged(String email) = _EmailChanged;
  const factory OnBoardingEvent.usernameChanged(String username) =
      _UsernameChanged;
  const factory OnBoardingEvent.passwordChanged(String password) =
      _PasswordChanged;
  const factory OnBoardingEvent.passwordConfirmChanged(String passwordConfirm) =
      _PasswordConfirmChanged;
  const factory OnBoardingEvent.fullNameChanged(String fullName) =
      _FullNameChanged;
  const factory OnBoardingEvent.phoneNumberChanged(
    String phoneCode,
    String phoneNumber,
  ) = _PhoneNumberChanged;
  const factory OnBoardingEvent.referrerChanged(String referrer) =
      _ReferrerChanged;
  const factory OnBoardingEvent.signUp() = _SignUp;
  const factory OnBoardingEvent.signUpSuccessful() = _SignUpSuccessful;
  const factory OnBoardingEvent.signUpFailed([String? message]) = _SignUpFailed;
  const factory OnBoardingEvent.acceptTermsChanged(bool acceptTerms) =
      _AcceptTermsChanged;
  const factory OnBoardingEvent.acceptMarketingChanged(bool acceptMarketing) =
      _AcceptMarketingChanged;
  const factory OnBoardingEvent.errorMessage(String? message) = _ErrorMessage;
  const factory OnBoardingEvent.resetSignUpForm() = _ResetSignUpForm;

  const factory OnBoardingEvent.persistCredentialsInBiometricDevice() =
      _PersistCredentialsInBiometricDevice;

  const factory OnBoardingEvent.init() = _Init;
}
