import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:esae_monie/enums/validator_error.dart';
import 'package:esae_monie/services/logging_helper.dart';
import 'package:esae_monie/services/persistence_services.dart';
import 'package:esae_monie/services/toast_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth;

  AuthBloc(this._auth) : super(const AuthState()) {
    on<_EmailChanged>(_emailChanged);
    on<_PasswordChanged>(_passwordChanged);
    on<_Login>(_login);
    on<_ForgotPassword>(_onForgotPassword);
    on<_ErrorMessage>(_errorMessage);
    on<_LoginFailed>(_loginFailed);
    on<_LoginSuccessful>(_loginSuccessful);
  }

  FutureOr<void> _errorMessage(_ErrorMessage event, Emitter<AuthState> emit) {
    emit(state.copyWith(errorMessage: event.message));
  }

  void _emailChanged(_EmailChanged event, Emitter<AuthState> emit) {
    final email = EmailFormz.dirty(event.email);

    emit(
      state.copyWith(
        email: email.isValid ? email : EmailFormz.pure(event.email),
      ),
    );
  }

  void _passwordChanged(_PasswordChanged event, Emitter<AuthState> emit) {
    final password = PasswordFormz.dirty(event.password);
    emit(
      state.copyWith(
        password: password.isValid
            ? password
            : PasswordFormz.pure(event.password),
      ),
    );
  }

  Future<void> _onForgotPassword(
    _ForgotPassword event,
    Emitter<AuthState> emit,
  ) async {
    if (state.resetStatus == FormzSubmissionStatus.inProgress) return;
    if (!state.email.isValid) {
      emit(
        state.copyWith(
          email: EmailFormz.dirty(state.email.value),
          errorMessage: 'Please fill in your mail correctly',
        ),
      );
      return;
    }
    emit(state.copyWith(resetStatus: FormzSubmissionStatus.inProgress));
    try {
      await _auth.sendPasswordResetEmail(email: event.email);
      emit(
        state.copyWith(
          resetStatus: FormzSubmissionStatus.success,
          errorMessage: null,
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          resetStatus: FormzSubmissionStatus.failure,
        ),
      );
    }
  }

  void _login(_Login event, Emitter<AuthState> emit) async {
    if (state.loginStatus == FormzSubmissionStatus.inProgress) return;

    if (!state.isLoginFormValid) {
      emit(
        state.copyWith(
          email: EmailFormz.dirty(state.email.value),
          password: PasswordFormz.dirty(state.password.value),
          errorMessage: 'Please fill in all fields correctly.',
        ),
      );
      return;
    }
    emit(state.copyWith(loginStatus: FormzSubmissionStatus.inProgress));
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      logInfo('User logged in successfully: ${userCredential.user?.uid}');
      final uid = userCredential.user?.uid;
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final fullName = docSnapshot.data()?['fullName'];
      await PersistenceService().saveUserName(fullName);
      final userEmail = docSnapshot.data()?['email'];
      await PersistenceService().saveUserEmail(userEmail);
      emit(
        state.copyWith(
          loginStatus: FormzSubmissionStatus.success,
          errorMessage: null,
        ),
      );
      PersistenceService().saveSignInStatus(true);
    } on FirebaseAuthException catch (error, trace) {
      logError(error, trace);
      emit(
        state.copyWith(
          loginStatus: FormzSubmissionStatus.failure,
          errorMessage: error.message ?? 'Login Failed',
        ),
      );
    }
  }

  void _loginSuccessful(_LoginSuccessful event, Emitter<AuthState> emit) {
    ToastService.toast('Login Successful');
  }

  void _loginFailed(_LoginFailed event, Emitter<AuthState> emit) {
    ToastService.toast('${state.errorMessage}', ToastType.error);
    emit(state.copyWith(errorMessage: null));
  }
}
