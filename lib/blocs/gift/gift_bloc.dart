import 'package:esae_monie/enums/validator_error.dart';
import 'package:esae_monie/models/services_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:formz/formz.dart';

part 'gift_event.dart';
part 'gift_state.dart';
part 'gift_bloc.freezed.dart';

class GiftBloc extends Bloc<GiftEvent, GiftState> {
  GiftBloc() : super(const GiftState()) {
    on<_Started>(_onStarted);
    on<_SelectGift>(_onSelectGift);
    on<_RecipientNameChanged>(_onRecipientNameChanged);
    on<_AccountNumberChanged>(_onAccountNumberChanged);
    on<_PurposeChanged>(_onPurposeChanged);
    on<_PasswordChanged>(_onPasswordChanged);
    on<_GiftAmountChanged>(_onGiftAmountChanged);
    on<_GiftMessageChanged>(_onGiftMessageChanged);
    on<_QuickAmountSelected>(_onQuickAmountSelected);
    on<_SubmitGift>(_onSubmitGift);
    on<_ResetGift>(_onResetGift);
  }

  void _onStarted(_Started event, Emitter<GiftState> emit) {
    final giftsMap = {for (final gift in event.initialGifts) gift.id: gift};
    emit(state.copyWith(gifts: giftsMap));
  }

  void _onSelectGift(_SelectGift event, Emitter<GiftState> emit) {
    emit(state.copyWith(selectedGiftId: event.giftId));
  }

  void _onRecipientNameChanged(
    _RecipientNameChanged event,
    Emitter<GiftState> emit,
  ) {
    final recipientName = RecipientNameFormz.dirty(event.name);
    // ✅ Always emit dirty - no conditional!
    emit(state.copyWith(recipientName: recipientName));
  }

  void _onAccountNumberChanged(
    _AccountNumberChanged event,
    Emitter<GiftState> emit,
  ) {
    final accountNumber = AccountNumberFormz.dirty(event.accountNumber);
    // ✅ Always emit dirty
    emit(state.copyWith(accountNumber: accountNumber));
  }

  void _onPurposeChanged(_PurposeChanged event, Emitter<GiftState> emit) {
    final purpose = PurposeFormz.dirty(event.purpose);
    // ✅ Always emit dirty
    emit(state.copyWith(purpose: purpose));
  }

  void _onPasswordChanged(_PasswordChanged event, Emitter<GiftState> emit) {
    final password = PasswordFormz.dirty(event.password);
    // ✅ Always emit dirty
    emit(state.copyWith(password: password));
  }

  void _onGiftAmountChanged(_GiftAmountChanged event, Emitter<GiftState> emit) {
    final amount = GiftAmountFormz.dirty(event.amount);
    // ✅ Always emit dirty
    emit(state.copyWith(amount: amount));
  }

  void _onGiftMessageChanged(
    _GiftMessageChanged event,
    Emitter<GiftState> emit,
  ) {
    final message = GiftMessageFormz.dirty(event.message);
    // ✅ Always emit dirty
    emit(state.copyWith(giftMessage: message));
  }

  void _onQuickAmountSelected(
    _QuickAmountSelected event,
    Emitter<GiftState> emit,
  ) {
    final amount = GiftAmountFormz.dirty(event.amount.toString());
    emit(state.copyWith(amount: amount));
  }

  Future<void> _onSubmitGift(_SubmitGift event, Emitter<GiftState> emit) async {
    if (state.submissionStatus == FormzSubmissionStatus.inProgress) return;

    if (!state.isGiftFormValid) {
      emit(
        state.copyWith(
          recipientName: RecipientNameFormz.dirty(state.recipientName.value),
          accountNumber: AccountNumberFormz.dirty(state.accountNumber.value),
          purpose: PurposeFormz.dirty(state.purpose.value),
          password: PasswordFormz.dirty(state.password.value),
          amount: GiftAmountFormz.dirty(state.amount.value),
          giftMessage: GiftMessageFormz.dirty(
            state.giftMessage.value,
          ), // Add this!
          errorMessage: 'Please fill in all fields correctly.',
        ),
      );
      return;
    }

    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress));

    try {
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(submissionStatus: FormzSubmissionStatus.success));
    } catch (error) {
      emit(
        state.copyWith(
          submissionStatus: FormzSubmissionStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _onResetGift(_ResetGift event, Emitter<GiftState> emit) {
    emit(
      state.copyWith(
        selectedGiftId: null,
        recipientName: const RecipientNameFormz.pure(),
        accountNumber: const AccountNumberFormz.pure(),
        purpose: const PurposeFormz.pure(),
        password: const PasswordFormz.pure(),
        amount: const GiftAmountFormz.pure(),
        giftMessage: const GiftMessageFormz.pure(),
        submissionStatus: FormzSubmissionStatus.initial,
        errorMessage: null,
      ),
    );
  }
}
