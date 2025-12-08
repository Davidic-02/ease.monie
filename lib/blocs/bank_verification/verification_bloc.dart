import 'package:esae_monie/enums/validator_error.dart';
import 'package:esae_monie/models/bank_response.dart';
import 'package:esae_monie/models/resolve_account_request.dart';
import 'package:esae_monie/models/resolve_account_response.dart';
import 'package:esae_monie/retrofit/bank_api.dart';
import 'package:esae_monie/services/logging_helper.dart';
import 'package:esae_monie/services/service_locator.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:esae_monie/models/bank_model.dart';

part 'verification_event.dart';
part 'verification_state.dart';
part 'verification_bloc.freezed.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc() : super(const VerificationState()) {
    on<_BankAccountChanged>(_bankAccountChanged);
    on<_BankChanged>(_bankChanged);
    on<_Submit>(_submit);
    on<_SubmitSuccessful>(_submitSuccessful);
    on<_SubmitFailed>(_submitFailed);
    on<_GetBanks>(_getBanks);
    on<_GetBanksSuccessful>(_getBanksSuccessful);
    on<_GetBanksFailed>(_getBanksFailed);
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

      final result = await locator<BankApi>().resolveAccount(
        ResolveAccountRequest(
          account_number: state.bankAccount.value,
          account_bank: state.selectedBank.value!.code,
        ),
      );

      add(VerificationEvent.submitSuccessful(result));

      logInfo(result.toJson());
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

  void _getBanks(_GetBanks event, Emitter<VerificationState> emit) async {
    if (state.getBanksStatus == FormzSubmissionStatus.inProgress) return;

    emit(state.copyWith(getBanksStatus: FormzSubmissionStatus.inProgress));

    try {
      final response = await locator<BankApi>().getBanks();
      add(VerificationEvent.getBanksSuccessful(response));
      logInfo(response);
    } catch (error, trace) {
      logError(error, trace);
      add(VerificationEvent.getBanksFailed(error.toString()));
    }
  }

  void _getBanksSuccessful(
    _GetBanksSuccessful event,
    Emitter<VerificationState> emit,
  ) {
    emit(
      state.copyWith(
        banks: event.response.data,
        formzStatus: FormzSubmissionStatus.success,
      ),
    );
  }

  void _getBanksFailed(_GetBanksFailed event, Emitter<VerificationState> emit) {
    emit(
      state.copyWith(
        errorMessage: event.message,
        formzStatus: FormzSubmissionStatus.failure,
      ),
    );
  }
}
