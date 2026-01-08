import 'package:esae_monie/enums/validator_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_transfer_event.dart';
part 'bank_transfer_state.dart';
part 'bank_transfer_bloc.freezed.dart';

class BankTransferBloc extends Bloc<BankTransferEvent, BankTransferState> {
  BankTransferBloc() : super(const BankTransferState()) {
    on<_BankChanged>(_bankChanged);
    on<_CardHolderNameChanged>(_cardHolderNameChanged);
    on<_CardNumberChanged>(_cardNumberChanged);
    on<_ExpiryChanged>(_expiryChanged);
    on<_CvvChanged>(_cvvChanged);
    on<_AmountSelected>(_amountSelected);
    on<_Submit>(_submit);
  }

  void _bankChanged(_BankChanged event, Emitter<BankTransferState> emit) {
    emit(state.copyWith(selectedBank: event.bank));
  }

  void _cardHolderNameChanged(
    _CardHolderNameChanged event,
    Emitter<BankTransferState> emit,
  ) {
    final cardHolder = CardHolderFormz.dirty(event.name);
    emit(
      state.copyWith(
        cardHolderName: cardHolder.isValid
            ? cardHolder
            : CardHolderFormz.pure(event.name),
        errorMessage: null,
      ),
    );
  }

  void _cardNumberChanged(
    _CardNumberChanged event,
    Emitter<BankTransferState> emit,
  ) {
    final cardNumber = CardNumberFormz.dirty(event.number);
    emit(
      state.copyWith(
        cardNumber: cardNumber.isValid
            ? cardNumber
            : CardNumberFormz.pure(event.number),
        errorMessage: null,
      ),
    );
  }

  void _expiryChanged(_ExpiryChanged event, Emitter<BankTransferState> emit) {
    final expiry = ExpiryFormz.dirty(event.mmyy);
    emit(
      state.copyWith(
        expiry: expiry.isValid ? expiry : ExpiryFormz.pure(event.mmyy),
        errorMessage: null,
      ),
    );
  }

  void _cvvChanged(_CvvChanged event, Emitter<BankTransferState> emit) {
    final cvv = CvvFormz.dirty(event.cvv);
    emit(
      state.copyWith(
        cvv: cvv.isValid ? cvv : CvvFormz.pure(event.cvv),
        errorMessage: null,
      ),
    );
  }

  void _amountSelected(_AmountSelected event, Emitter<BankTransferState> emit) {
    emit(state.copyWith(amount: event.amount, errorMessage: null));
  }

  Future<void> _submit(_Submit event, Emitter<BankTransferState> emit) async {
    if (!state.isFormValid || state.amount == null) {
      emit(
        state.copyWith(
          cardHolderName: CardHolderFormz.dirty(state.cardHolderName.value),
          cardNumber: CardNumberFormz.dirty(state.cardNumber.value),
          expiry: ExpiryFormz.dirty(state.expiry.value),
          cvv: CvvFormz.dirty(state.cvv.value),
          errorMessage: "Please fill all fields correctly.",
        ),
      );
      return;
    }

    emit(state.copyWith(formStatus: FormzSubmissionStatus.inProgress));
  }
}
