import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:esae_monie/enums/validator_error.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';
part 'onboarding_bloc.freezed.dart';

class OnboardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  OnboardingBloc() : super(const OnBoardingState()) {
    on<_EmailChanged>(_emailChanged);
    on<_UsernameChanged>(_usernameChanged);
    on<_FullNameChanged>(_fullNameChanged);
    on<_PasswordChanged>(_passwordChanged);
    on<_PasswordConfirmChanged>(_passwordConfirmChanged);
    on<_PhoneNumberChanged>(_phoneNumberChanged);
  }

  void _emailChanged(_EmailChanged event, Emitter<OnBoardingState> emit) {
    final email = EmailFormz.dirty(event.email);

    emit(
      state.copyWith(
        email: email.isValid ? email : EmailFormz.pure(event.email),
      ),
    );
  }

  void _usernameChanged(_UsernameChanged event, Emitter<OnBoardingState> emit) {
    final username = UsernameFormz.dirty(event.username);

    emit(
      state.copyWith(
        username: username.isValid
            ? username
            : UsernameFormz.pure(event.username),
      ),
    );
  }

  void _fullNameChanged(_FullNameChanged event, Emitter<OnBoardingState> emit) {
    final fullName = FullNameFormz.dirty(event.fullName);

    emit(
      state.copyWith(
        fullName: fullName.isValid
            ? fullName
            : FullNameFormz.pure(event.fullName),
      ),
    );
  }

  void _phoneNumberChanged(
    _PhoneNumberChanged event,
    Emitter<OnBoardingState> emit,
  ) {
    emit(
      state.copyWith(
        phoneCode: event.phoneCode,
        phoneNumber: event.phoneNumber,
      ),
    );
  }

  void _passwordChanged(_PasswordChanged event, Emitter<OnBoardingState> emit) {
    final password = PasswordFormz.dirty(event.password);

    emit(
      state.copyWith(
        password: password.isValid
            ? password
            : PasswordFormz.pure(event.password),
      ),
    );
  }

  void _passwordConfirmChanged(
    _PasswordConfirmChanged event,
    Emitter<OnBoardingState> emit,
  ) {
    final passwordConfirm = PasswordConfirmFormz.dirty(
      event.passwordConfirm,
      state.password.value,
    );

    emit(
      state.copyWith(
        passwordConfirm: passwordConfirm.isValid
            ? passwordConfirm
            : PasswordConfirmFormz.pure(
                event.passwordConfirm,
                state.password.value,
              ),
      ),
    );
  }
}
