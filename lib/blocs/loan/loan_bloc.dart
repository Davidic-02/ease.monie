import 'package:bloc/bloc.dart';
import 'package:esae_monie/enums/validator_error.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:formz/formz.dart';

part 'loan_event.dart';
part 'loan_state.dart';
part 'loan_bloc.freezed.dart';

class LoanBloc extends Bloc<LoanEvent, LoanState> {
  LoanBloc() : super(const LoanState()) {
    on<_NameChanged>(_nameChanged);
    on<_CnicChanged>(_cnicChanged);
    on<_MobileChanged>(_mobileChanged);
    on<_PasswordChanged>(_passwordChanged);
    on<_PlanSelected>(_planSelected);
    on<_Submit>(_submit);
  }

  void _planSelected(_PlanSelected event, Emitter<LoanState> emit) {
    emit(state.copyWith(selectedPlan: event.plan));
  }

  void _nameChanged(_NameChanged event, Emitter<LoanState> emit) {
    final name = NameFormz.dirty(event.name);

    emit(
      state.copyWith(name: name.isValid ? name : NameFormz.pure(event.name)),
    );
  }

  void _cnicChanged(_CnicChanged event, Emitter<LoanState> emit) {
    final cnic = CnicFormz.dirty(event.cnic);

    emit(
      state.copyWith(cnic: cnic.isValid ? cnic : CnicFormz.pure(event.cnic)),
    );
  }

  void _mobileChanged(_MobileChanged event, Emitter<LoanState> emit) {
    final mobile = MobileFormz.dirty(event.mobile);

    emit(
      state.copyWith(
        mobile: mobile.isValid ? mobile : MobileFormz.pure(event.mobile),
      ),
    );
  }

  void _passwordChanged(_PasswordChanged event, Emitter<LoanState> emit) {
    final password = PasswordFormz.dirty(event.password);

    emit(
      state.copyWith(
        password: password.isValid
            ? password
            : PasswordFormz.pure(event.password),
      ),
    );
  }

  Future<void> _submit(_Submit event, Emitter<LoanState> emit) async {
    if (state.submissionStatus == FormzSubmissionStatus.inProgress) return;

    if (!state.isFormValid) {
      emit(
        state.copyWith(
          name: NameFormz.dirty(state.name.value),
          cnic: CnicFormz.dirty(state.cnic.value),
          mobile: MobileFormz.dirty(state.mobile.value),
          password: PasswordFormz.dirty(state.password.value),
          submissionStatus: FormzSubmissionStatus.failure,
        ),
      );
      return;
    }

    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.success));
  }
}
