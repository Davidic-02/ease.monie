part of 'charity_bloc.dart';

@freezed
class CharityEvent with _$CharityEvent {
  const factory CharityEvent.started(List<ServicesModel> initialCharities) =
      _Started;

  const factory CharityEvent.donationAmountChanged(String amount) =
      _DonationAmount;
  const factory CharityEvent.selectCharity(String charityId) = _SelectCharity;

  const factory CharityEvent.donationCompleted({
    required String charityId,
    required double donatedAmount,
  }) = _DonationCompleted;
}
