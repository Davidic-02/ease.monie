import 'package:esae_monie/enums/validator_error.dart';
import 'package:esae_monie/models/resolve_account_request.dart';
import 'package:esae_monie/models/resolve_account_response.dart';
import 'package:esae_monie/repository/bank_verification_repo.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:esae_monie/models/bank_model.dart';

part 'verification_event.dart';
part 'verification_state.dart';
part 'verification_bloc.freezed.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  final BankVerificationRepo repo;

  VerificationBloc({required this.repo}) : super(const VerificationState()) {
    on<_BankAccountChanged>(_bankAccountChanged);
    on<_BankChanged>(_bankChanged);
    on<_Submit>(_submit);
    on<_SubmitSuccessful>(_submitSuccessful);
    on<_SubmitFailed>(_submitFailed);
    on<_LoadBanks>(_loadBanks);
  }
  void _loadBanks(_LoadBanks event, Emitter<VerificationState> emit) async {
    try {
      emit(state.copyWith(formzStatus: FormzSubmissionStatus.inProgress));

      final response = await repo.getBanks();

      emit(
        state.copyWith(
          banks: response.data,
          formzStatus: FormzSubmissionStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          formzStatus: FormzSubmissionStatus.failure,
        ),
      );
    }
  }

  void _bankAccountChanged(
    _BankAccountChanged event,
    Emitter<VerificationState> emit,
  ) {
    final bankAccount = BankAccountFormz.dirty(event.number);
    emit(
      state.copyWith(
        bankAccount: bankAccount.isValid
            ? bankAccount
            : BankAccountFormz.dirty(event.number),
      ),
    );
  }

  void _bankChanged(_BankChanged event, Emitter<VerificationState> emit) {
    final bank = BankInput.dirty(event.bank);

    emit(state.copyWith(selectedBank: bank));
  }

  void _submit(_Submit event, Emitter<VerificationState> emit) async {
    if (state.formzStatus == FormzSubmissionStatus.inProgress) return;

    if (!state.isFormValid) {
      emit(
        state.copyWith(
          bankAccount: BankAccountFormz.dirty(state.bankAccount.value),
          selectedBank: BankInput.dirty(state.selectedBank.value),
          errorMessage: 'Please fill in all fields correctly.',
        ),
      );
      return;
    }

    emit(state.copyWith(formzStatus: FormzSubmissionStatus.inProgress));

    try {
      if (state.selectedBank.value == null) {
        emit(state.copyWith(errorMessage: 'Please select a bank.'));
        return;
      }

      final result = await repo.resolveAccount(
        ResolveAccountRequest(
          account_number: state.bankAccount.value,
          account_bank: state.selectedBank.value!.code,
        ),
      );

      add(VerificationEvent.submitSuccessful(result));

      print(result.toJson());
    } catch (error) {
      add(VerificationEvent.submitFailed(error.toString()));
    }
  }

  void _submitSuccessful(
    _SubmitSuccessful event,
    Emitter<VerificationState> emit,
  ) {
    emit(
      state.copyWith(
        verificationResult: event.result,
        formzStatus: FormzSubmissionStatus.success,
      ),
    );
  }

  void _submitFailed(_SubmitFailed event, Emitter<VerificationState> emit) {
    emit(
      state.copyWith(
        errorMessage: event.message,
        formzStatus: FormzSubmissionStatus.failure,
      ),
    );
  }
}
