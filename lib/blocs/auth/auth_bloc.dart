import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:esae_monie/enums/validator_error.dart';
import 'package:esae_monie/services/logging_helper.dart';
import 'package:esae_monie/services/persistence_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth;

  AuthBloc(this._auth) : super(AuthState()) {
    on<_EmailChanged>(_emailChanged);
    on<_PasswordChanged>(_passwordChanged);
    on<_ForgotPasswordEmailChanged>(_forgotPasswordEmailChanged);
    on<_Login>(_login);
    on<_LoginSuccessful>(_loginSuccessful);
    on<_LoginFailed>(_loginFailed);
    on<_ForgotPassword>(_forgotPassword);
    on<_ForgotPasswordSuccessful>(_forgotPasswordSuccessful);
    on<_ForgotPasswordFailed>(_forgotPasswordFailed);
    on<_ErrorMessage>(_errorMessage);
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

  void _forgotPasswordEmailChanged(
    _ForgotPasswordEmailChanged event,
    Emitter<AuthState> emit,
  ) {
    final forgotPasswordEmail = ForgotPasswordFormz.dirty(event.email);

    emit(
      state.copyWith(
        forgotPasswordEmail: forgotPasswordEmail.isValid
            ? forgotPasswordEmail
            : ForgotPasswordFormz.pure(event.email),
      ),
    );
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

      add(_LoginSuccessful());

      PersistenceService().saveSignInStatus(true);
    } on FirebaseAuthException catch (error, trace) {
      logError(error, trace);
      add(_LoginFailed(error.message));
    }
  }

  void _loginSuccessful(_LoginSuccessful event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        loginStatus: FormzSubmissionStatus.success,
        errorMessage: null,
        user: _auth.currentUser,
        userEmail: _auth.currentUser?.email,
      ),
    );
  }

  void _loginFailed(_LoginFailed event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        loginStatus: FormzSubmissionStatus.failure,
        errorMessage: event.message ?? 'An unknown error occurred.',
      ),
    );

    add(_ErrorMessage(event.message));
  }

  void _forgotPassword(_ForgotPassword event, Emitter<AuthState> emit) async {
    if (state.forgotPasswordStatus == FormzSubmissionStatus.inProgress) return;

    if (!state.forgotPasswordEmail.isValid) {
      emit(
        state.copyWith(
          email: EmailFormz.dirty(state.forgotPasswordEmail.value),
          errorMessage: 'Please fill in your mail correctly',
        ),
      );
      return;
    }
    emit(
      state.copyWith(forgotPasswordStatus: FormzSubmissionStatus.inProgress),
    );

    try {
      await _auth.sendPasswordResetEmail(
        email: state.forgotPasswordEmail.value,
      );

      add(_ForgotPasswordSuccessful());
    } on FirebaseAuthException catch (e) {
      add(_ForgotPasswordFailed(e.message));
      logError(e, null);
    }
  }

  void _forgotPasswordSuccessful(
    _ForgotPasswordSuccessful event,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(
        forgotPasswordStatus: FormzSubmissionStatus.success,
        errorMessage: null,
      ),
    );
  }

  void _forgotPasswordFailed(
    _ForgotPasswordFailed event,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(
        forgotPasswordStatus: FormzSubmissionStatus.failure,
        errorMessage: event.message ?? 'An unknown error occurred.',
      ),
    );

    add(_ErrorMessage(event.message));
  }

  void _errorMessage(_ErrorMessage event, Emitter<AuthState> emit) {
    emit(state.copyWith(errorMessage: event.message));
  }
}
