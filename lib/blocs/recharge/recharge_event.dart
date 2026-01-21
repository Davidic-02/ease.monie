part of 'recharge_bloc.dart';

@freezed
class RechargeEvent with _$RechargeEvent {
  const factory RechargeEvent.phoneNumberChanged(String phoneNumber) =
      _PhoneNumberChanged;

  const factory RechargeEvent.networkSelected(SelectedNetwork network) =
      _NetworkSelected;

  const factory RechargeEvent.amountChanged(String amount) = _AmountChanged;

  const factory RechargeEvent.quickAmountSelected(String amount) =
      _QuickAmountSelected;

  const factory RechargeEvent.rechargeSubmitted() = _RechargeSubmitted;
}
