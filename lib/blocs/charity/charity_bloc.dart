import 'package:esae_monie/enums/validator_error.dart';
import 'package:esae_monie/models/services_model.dart';
import 'package:esae_monie/presentation/widgets/services_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:formz/formz.dart';

part 'charity_event.dart';
part 'charity_state.dart';
part 'charity_bloc.freezed.dart';

class CharityBloc extends Bloc<CharityEvent, CharityState> {
  CharityBloc() : super(const CharityState()) {
    on<_DonationAmount>(_donatedAmount);
    on<_DonationCompleted>(_donationCompleted);
  }

  void _donatedAmount(_DonationAmount event, Emitter<CharityState> emit) {
    final amount = DonationAmountFormz.dirty(event.amount);

    emit(
      state.copyWith(
        donationAmount: amount.isValid
            ? amount
            : DonationAmountFormz.pure(event.amount),

        errorMessage: null,
      ),
    );
  }

  void _donationCompleted(
    _DonationCompleted event,
    Emitter<CharityState> emit,
  ) {
    final updatedDonatedAmount = state.donatedAmount + event.donatedAmount;

    emit(
      state.copyWith(
        donatedAmount: updatedDonatedAmount,
        donationAmount: DonationAmountFormz.pure(''), // reset input
        errorMessage: null,
      ),
    );
  }
}
