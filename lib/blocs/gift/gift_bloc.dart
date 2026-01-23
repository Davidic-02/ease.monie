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

    emit(
      state.copyWith(
        recipientName: recipientName.isValid
            ? recipientName
            : RecipientNameFormz.pure(event.name),
      ),
    );
  }

  void _onAccountNumberChanged(
    _AccountNumberChanged event,
    Emitter<GiftState> emit,
  ) {
    final accountNumber = AccountNumberFormz.dirty(event.accountNumber);
    emit(
      state.copyWith(
        accountNumber: accountNumber.isValid
            ? accountNumber
            : AccountNumberFormz.pure(event.accountNumber),
      ),
    );
  }

  void _onPurposeChanged(_PurposeChanged event, Emitter<GiftState> emit) {
    final purpose = PurposeFormz.dirty(event.purpose);

    emit(
      state.copyWith(
        purpose: purpose.isValid ? purpose : PurposeFormz.pure(event.purpose),
      ),
    );
  }

  void _onPasswordChanged(_PasswordChanged event, Emitter<GiftState> emit) {
    final password = PasswordFormz.dirty(event.password);

    emit(
      state.copyWith(
        password: password.isValid
            ? password
            : PasswordFormz.pure(event.password),
      ),
    );
  }

  void _onGiftAmountChanged(_GiftAmountChanged event, Emitter<GiftState> emit) {
    final amount = GiftAmountFormz.dirty(event.amount);

    emit(
      state.copyWith(
        amount: amount.isValid ? amount : GiftAmountFormz.pure(event.amount),
      ),
    );
  }

  void _onGiftMessageChanged(
    _GiftMessageChanged event,
    Emitter<GiftState> emit,
  ) {
    final message = GiftMessageFormz.dirty(event.message);

    emit(
      state.copyWith(
        giftMessage: message.isValid
            ? message
            : GiftMessageFormz.pure(event.message),
      ),
    );
  }

  void _onQuickAmountSelected(
    _QuickAmountSelected event,
    Emitter<GiftState> emit,
  ) {
    final amount = GiftAmountFormz.dirty(event.amount.toString());

    emit(
      state.copyWith(
        amount: amount.isValid
            ? amount
            : GiftAmountFormz.pure(event.amount.toString()),
      ),
    );
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
