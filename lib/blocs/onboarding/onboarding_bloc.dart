import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:esae_monie/enums/validator_error.dart';
import 'package:esae_monie/services/logging_helper.dart';
import 'package:esae_monie/services/persistence_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';
part 'onboarding_bloc.freezed.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  final FirebaseAuth _auth;
  OnBoardingBloc(this._auth) : super(const OnBoardingState()) {
    on<_EmailChanged>(_emailChanged);
    on<_FullNameChanged>(_fullNameChanged);
    on<_PasswordChanged>(_passwordChanged);
    on<_AcceptTermsChanged>(_acceptTermsChanged);
    on<_PasswordConfirmChanged>(_passwordConfirmChanged);
    on<_PhoneNumberChanged>(_phoneNumberChanged);
    on<_SignUp>(_signUp);
    on<_SignUpSuccessful>(_signUpSuccessful);
    on<_SignUpFailed>(_signUpFailed);
    on<_ErrorMessage>(_errorMessage);
  }

  void _emailChanged(_EmailChanged event, Emitter<OnBoardingState> emit) {
    final email = EmailFormz.dirty(event.email);

    emit(
      state.copyWith(
        email: email.isValid ? email : EmailFormz.pure(event.email),
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
    emit(state.copyWith(phoneNumber: event.phoneNumber));
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

  void _acceptTermsChanged(
    _AcceptTermsChanged event,
    Emitter<OnBoardingState> emit,
  ) {
    emit(state.copyWith(acceptTerms: event.acceptTerms));
  }

  void _signUp(_SignUp event, Emitter<OnBoardingState> emit) async {
    if (state.signUpStatus == FormzSubmissionStatus.inProgress) return;

    if (!state.isSignUpFormValid) {
      emit(
        state.copyWith(
          email: EmailFormz.dirty(state.email.value),
          fullName: FullNameFormz.dirty(state.fullName.value),
          password: PasswordFormz.dirty(state.password.value),
          passwordConfirm: PasswordConfirmFormz.dirty(
            state.passwordConfirm.value,
          ),
          errorMessage: 'Please fill in all fields correctly.',
        ),
      );
      return;
    }

    if (state.acceptTerms == false) {
      emit(
        state.copyWith(
          errorMessage: 'You must accept the terms and conditions to proceed.',
        ),
      );
      return;
    }

    emit(state.copyWith(signUpStatus: FormzSubmissionStatus.inProgress));

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );

      await userCredential.user?.updateDisplayName(state.fullName.value);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'fullName': state.fullName.value,
            'email': state.email.value,
            'phoneNumber': state.phoneNumber,
            'createdAt': FieldValue.serverTimestamp(),
          });

      logInfo('User signed up successfully: ${userCredential.user!.uid}');

      final uid = userCredential.user?.uid;
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final fullName = docSnapshot.data()?['fullName'];
      await PersistenceService().saveUserName(fullName);

      final userEmail = docSnapshot.data()?['email'];
      await PersistenceService().saveUserEmail(userEmail);

      add(const OnBoardingEvent.signUpSuccessful());
    } on FirebaseAuthException catch (error, trace) {
      logError(error, trace);
      add(OnBoardingEvent.signUpFailed(error.message ?? 'Signup failed'));
    }
  }

  void _signUpSuccessful(
    _SignUpSuccessful event,
    Emitter<OnBoardingState> emit,
  ) {
    emit(
      state.copyWith(
        signUpStatus: FormzSubmissionStatus.success,
        errorMessage: null,
      ),
    );
    PersistenceService().saveSignInStatus(true);
  }

  void _signUpFailed(_SignUpFailed event, Emitter<OnBoardingState> emit) {
    emit(
      state.copyWith(
        signUpStatus: FormzSubmissionStatus.failure,
        errorMessage: event.message,
      ),
    );
  }

  FutureOr<void> _errorMessage(
    _ErrorMessage event,
    Emitter<OnBoardingState> emit,
  ) {
    emit(state.copyWith(errorMessage: event.message));
  }
}
