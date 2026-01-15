part of 'charity_bloc.dart';

@freezed
class CharityEvent with _$CharityEvent {
  const factory CharityEvent.donationAmount(String amount) = _DonationAmount;

  const factory CharityEvent.donationCompleted({
    required ServicesModel charity,
    required double donatedAmount,
  }) = _DonationCompleted;
}
