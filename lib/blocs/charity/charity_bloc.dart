import 'package:esae_monie/enums/validator_error.dart';
import 'package:esae_monie/models/services_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:formz/formz.dart';

part 'charity_event.dart';
part 'charity_state.dart';
part 'charity_bloc.freezed.dart';

class CharityBloc extends Bloc<CharityEvent, CharityState> {
  CharityBloc() : super(const CharityState()) {
    on<_Started>(_started);
    on<_DonationAmount>(_donatedAmount);
    on<_DonationCompleted>(_donationCompleted);
    on<_SelectCharity>(_selectCharity);
  }

  void _selectCharity(_SelectCharity event, Emitter<CharityState> emit) {
    emit(
      state.copyWith(selectedCharityId: event.charityId, errorMessage: null),
    );
  }

  void _started(_Started event, Emitter<CharityState> emit) {
    final map = {
      for (final charity in event.initialCharities) charity.id: charity,
    };

    emit(state.copyWith(charities: map));
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
    final charityId = event.charityId;

    // Get current charity
    final currentCharity = state.charities[charityId];
    if (currentCharity == null) return;

    // Create updated charity
    final updatedCharity = currentCharity.copyWith(
      donatedAmount: currentCharity.donatedAmount + event.donatedAmount,
    );

    // Replace in map
    final updatedCharities = Map<String, ServicesModel>.from(state.charities);
    updatedCharities[charityId] = updatedCharity;

    emit(
      state.copyWith(
        charities: updatedCharities,
        donationAmount: DonationAmountFormz.pure(''),
        errorMessage: null,
      ),
    );
  }
}
