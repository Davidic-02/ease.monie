part of 'gift_bloc.dart';

@freezed
abstract class GiftEvent with _$GiftEvent {
  const factory GiftEvent() = _GiftEvent;
  const factory GiftEvent.init() = _Init;
  const factory GiftEvent.selectGift(String giftId) = _SelectGift;
  const factory GiftEvent.recipientNameChanged(String name) =
      _RecipientNameChanged;
  const factory GiftEvent.accountNumberChanged(String accountNumber) =
      _AccountNumberChanged;
  const factory GiftEvent.purposeChanged(String purpose) = _PurposeChanged;
  const factory GiftEvent.passwordChanged(String password) = _PasswordChanged;
  const factory GiftEvent.giftAmountChanged(String amount) = _GiftAmountChanged;
  const factory GiftEvent.giftMessageChanged(String message) =
      _GiftMessageChanged;
  const factory GiftEvent.quickAmountSelected(double amount) =
      _QuickAmountSelected;

  const factory GiftEvent.submitGift() = _SubmitGift;
  const factory GiftEvent.resetGift() = _ResetGift;
}
