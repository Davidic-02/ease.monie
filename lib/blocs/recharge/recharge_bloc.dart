import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:formz/formz.dart';

import 'package:esae_monie/enums/validator_error.dart';
import 'package:esae_monie/models/selected_network.dart';

part 'recharge_event.dart';
part 'recharge_state.dart';
part 'recharge_bloc.freezed.dart';

class RechargeBloc extends Bloc<RechargeEvent, RechargeState> {
  RechargeBloc() : super(const RechargeState()) {
    on<_PhoneNumberChanged>(_onPhoneNumberChanged);
    on<_AmountChanged>(_onAmountChanged);
    on<_QuickAmountSelected>(_onQuickAmountSelected);
    on<_NetworkSelected>(_onNetworkSelected);
    on<_RechargeSubmitted>(_onRechargeSubmitted);
    on<_ResetForm>(_onResetForm);
  }

  void _onPhoneNumberChanged(
    _PhoneNumberChanged event,
    Emitter<RechargeState> emit,
  ) {
    final phoneNumber = PhoneNumberFormz.dirty(event.phoneNumber);

    emit(
      state.copyWith(
        phoneNumber: phoneNumber.isValid
            ? phoneNumber
            : PhoneNumberFormz.dirty(event.phoneNumber),
      ),
    );
  }

  void _onAmountChanged(_AmountChanged event, Emitter<RechargeState> emit) {
    final amount = AmountFormz.dirty(event.amount);

    emit(
      state.copyWith(
        amount: amount.isValid ? amount : AmountFormz.dirty(event.amount),
      ),
    );
  }

  void _onQuickAmountSelected(
    _QuickAmountSelected event,
    Emitter<RechargeState> emit,
  ) {
    final amount = AmountFormz.dirty(event.amount);

    emit(
      state.copyWith(
        amount: amount,
        submissionStatus: FormzSubmissionStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onNetworkSelected(_NetworkSelected event, Emitter<RechargeState> emit) {
    emit(
      state.copyWith(
        selectedNetwork: event.network,
        submissionStatus: FormzSubmissionStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onRechargeSubmitted(
    _RechargeSubmitted event,
    Emitter<RechargeState> emit,
  ) {
    if (state.submissionStatus == FormzSubmissionStatus.inProgress) return;

    if (!state.isRechargeFormValid) {
      emit(
        state.copyWith(
          phoneNumber: PhoneNumberFormz.dirty(state.phoneNumber.value),
          amount: AmountFormz.dirty(state.amount.value),
          errorMessage: 'Please complete all fields correctly.',
          submissionStatus: FormzSubmissionStatus.failure,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        submissionStatus: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ),
    );
  }

  void _onResetForm(_ResetForm event, Emitter<RechargeState> emit) {
    emit(const RechargeState()); // Reset to initial state
  }
}
